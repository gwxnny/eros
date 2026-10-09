-- Eros Phase 1 schema. Run in Supabase > SQL Editor.
create table public.profiles(
  id uuid primary key references auth.users on delete cascade,
  display_name text, nickname text, created_at timestamptz default now());
create table public.couples(
  id uuid primary key default gen_random_uuid(),
  title text, partner_name text, start_date date, anniversary date,
  created_by uuid default auth.uid(), created_at timestamptz default now());
create table public.couple_members(
  couple_id uuid references public.couples on delete cascade,
  user_id uuid references auth.users on delete cascade,
  joined_at timestamptz default now(), primary key(couple_id,user_id));
create table public.invites(
  code text primary key,
  couple_id uuid not null references public.couples on delete cascade,
  created_by uuid default auth.uid(),
  expires_at timestamptz default now()+interval '7 days',
  accepted_by uuid, accepted_at timestamptz);

create function public.handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$
begin insert into profiles(id,display_name) values(new.id, coalesce(new.raw_user_meta_data->>'name','')); return new; end $$;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();

create function public.is_member(cid uuid) returns boolean language sql stable security definer set search_path=public as $$
  select exists(select 1 from couple_members where couple_id=cid and user_id=auth.uid()) $$;
create function public.shares_couple(uid uuid) returns boolean language sql stable security definer set search_path=public as $$
  select exists(select 1 from couple_members a join couple_members b on a.couple_id=b.couple_id
  where a.user_id=auth.uid() and b.user_id=uid) $$;

alter table profiles enable row level security;
alter table couples enable row level security;
alter table couple_members enable row level security;
alter table invites enable row level security;

create policy "own or partner profile" on profiles for select using (id=auth.uid() or shares_couple(id));
create policy "update own profile" on profiles for update using (id=auth.uid());
create policy "members read couple" on couples for select using (is_member(id));
create policy "members update couple" on couples for update using (is_member(id));
create policy "members read members" on couple_members for select using (is_member(couple_id));
create policy "members read invites" on invites for select using (is_member(couple_id));
-- no direct inserts/deletes: all pairing goes through the functions below.

create function public.create_couple(p_partner text, p_start date, p_anniversary date default null) returns uuid
language plpgsql security definer set search_path=public as $$
declare cid uuid;
begin
  if auth.uid() is null then raise exception 'Not signed in'; end if;
  if exists(select 1 from couple_members where user_id=auth.uid()) then raise exception 'You already have a shared space'; end if;
  insert into couples(partner_name,start_date,anniversary,created_by) values(p_partner,p_start,p_anniversary,auth.uid()) returning id into cid;
  insert into couple_members values(cid,auth.uid());
  return cid;
end $$;

create function public.create_invite() returns text
language plpgsql security definer set search_path=public as $$
declare cid uuid; c text;
begin
  select couple_id into cid from couple_members where user_id=auth.uid();
  if cid is null then raise exception 'Create your space first'; end if;
  if (select count(*) from couple_members where couple_id=cid)>=2 then raise exception 'Your space is already paired'; end if;
  delete from invites where couple_id=cid and accepted_at is null;
  c:=upper(substr(md5(random()::text||clock_timestamp()::text),1,8));
  insert into invites(code,couple_id,created_by) values(c,cid,auth.uid());
  return c;
end $$;

create function public.accept_invite(p_code text) returns uuid
language plpgsql security definer set search_path=public as $$
declare inv invites;
begin
  if auth.uid() is null then raise exception 'Not signed in'; end if;
  if exists(select 1 from couple_members where user_id=auth.uid()) then raise exception 'You already belong to a shared space'; end if;
  select * into inv from invites where code=upper(trim(p_code)) and accepted_at is null and expires_at>now() for update;
  if not found then raise exception 'This invitation is invalid or has expired'; end if;
  if (select count(*) from couple_members where couple_id=inv.couple_id)>=2 then raise exception 'This space is already paired'; end if;
  insert into couple_members values(inv.couple_id,auth.uid());
  update invites set accepted_by=auth.uid(), accepted_at=now() where code=inv.code;
  return inv.couple_id;
end $$;

create function public.leave_couple() returns void
language plpgsql security definer set search_path=public as $$
declare cid uuid;
begin
  select couple_id into cid from couple_members where user_id=auth.uid();
  if cid is null then return; end if;
  delete from couple_members where couple_id=cid and user_id=auth.uid();
  if not exists(select 1 from couple_members where couple_id=cid) then delete from couples where id=cid; end if;
end $$;

revoke execute on all functions in schema public from public, anon;
grant execute on function create_couple(text,date,date), create_invite(), accept_invite(text), leave_couple(), is_member(uuid), shares_couple(uuid) to authenticated;
