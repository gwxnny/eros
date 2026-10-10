# Eros

A private digital space for two: a cozy scrapbook, diary and planner for a couple's memories.

Eros is a static web app (one `index.html`) backed by Supabase for accounts, database and private photo storage. It works on desktop, tablet and mobile browsers.

---

## Contents

- [Features](#features)
- [Project structure](#project-structure)
- [Setup](#setup)
- [Running locally](#running-locally)
- [Deploying to Netlify](#deploying-to-netlify)
- [How privacy and security work](#how-privacy-and-security-work)
- [Features that need extra setup](#features-that-need-extra-setup)
- [Known limitations](#known-limitations)
- [Testing checklist](#testing-checklist)
- [Troubleshooting](#troubleshooting)

---

## Features

**Accounts and pairing**
- Sign up, log in, forgot and reset password, email verification (if enabled in Supabase), persistent sessions.
- Guided setup: create a shared space with your start and anniversary dates.
- Invite your partner with a code or link (expires after 7 days). Either partner can disconnect, with a confirmation.

**Home**
- Days together, years and months, countdown to your next anniversary.
- Today's memory (with "Show another"), On this day, Upcoming plans.
- Today's question: a daily prompt you each answer privately; answers are revealed once you've both replied.
- Memory stats (memories, photos, dates, places, keepsakes) from your real data.

**Memory Diary**
- Title, date, location, story, category, tags, up to 8 photos per memory (resized on upload).
- Nine fixed categories: Everyday Moments, Food, Dates, Trips and Holidays, Milestones, Celebrations, Gifts, Random Moments, Other. Categories can't be added or changed by users.
- Favourite, archive, edit, delete (with confirmation).
- Search, filters (category, tag, location, date range, created by, favourites) and four views: Grid, Timeline, List, Calendar.
- Photo viewer with swipe, arrows, dots and a full-screen zoom.

**Timeline**
- Chronological story grouped by year with yearly recaps, "Jump to year", automatic start date and anniversaries.
- Add, edit and delete moments; link a moment to a diary memory; optionally weave diary memories in.

**Perspectives (Two Perspectives)**
- Both partners write their own version of a moment. Nothing is shown until you've both answered, or until a reveal date you choose.
- Once revealed: side-by-side answers and a shared reflection.

**Plans**
- Calendar (Month and Agenda), events with time, location, budget, notes, itinerary, things to bring, reservation and links.
- Birthdays, anniversaries and other events can repeat every year.
- In-app reminders (1 day to 2 weeks before), countdowns, done and cancelled states.
- Turn a finished event into a diary memory with details pre-filled.
- Bucket list with category, priority, budget, favourites and done status; link completed items to memories.

**Places**
- Interactive map (OpenStreetMap via Leaflet) with pins, list fallback if the map can't load.
- Category, address lookup, coordinates, notes, visit dates, favourites, a "want to visit" list, filters, and related memories.

**Collection**
- Keepsakes: take a photo or upload; rotate, trim, brightness, contrast and a "Clean document" mode. Your original is saved untouched next to the cleaned-up copy.
- Optional text reading (OCR) for printed text, with editable results.
- Scrapbook pages: drag keepsakes and text onto paper backgrounds, resize and rotate, export as a PNG image.

**Photobooth**
- Upload, camera capture, or pick photos from your diary.
- Layouts: 4-photo strip, 3-photo strip, 2-photo strip, 2×2 grid.
- Presets, background colour, border, spacing, corners, film filters, brightness and contrast, stickers, caption, names, date stamp, text alignment and position.
- Export PNG or JPEG, and save strips into your memories.

**Settings**
- Profile photo, display name, nickname, favourite categories.
- Relationship name and dates, invitation code, partner status, disconnect.
- Appearance: light, dark or automatic; rose or dusty-blue accent; decoration toggle.
- Reminder preferences, data export (JSON), photo backup (ZIP), change password, log out, delete account.

**Design**
- Soft pink `#F8E3E8` and soft blue `#C2DAE8` brand colours, with separately designed light and dark themes.
- Dongle for the interface, Tourmines for the logo.
- Mobile bottom navigation with a "More" menu, plus a floating "+" button to add a memory from anywhere.

---

## Project structure

```
index.html              The whole app (HTML, CSS, JavaScript)
schema.sql              Accounts, spaces, invitations
schema_2a.sql           Memory Diary and the private photo bucket
schema_2c.sql           Timeline and Two Perspectives
schema_3.sql            Calendar events and bucket list
schema_4.sql            Places, keepsakes, scrapbook pages
schema_5.sql            Photobooth creations
schema_6.sql            Profile preferences, daily question, account deletion
schema_7.sql            Locks memory categories to the fixed list
Assets/font/Tourmines.otf     Logo font
Assets/images/logo.png        Favicon and home-screen icon
README.md
```

---

Open `http://localhost:8080`. Any static file server works. There's no build step and no `npm install`.

The app loads these from CDNs, so you need an internet connection:

| Library | Used for | Loaded |
|---|---|---|
| supabase-js 2.45.4 | Auth, database, storage | On page load |
| Leaflet 1.9.4 | Places map | On page load |
| Tesseract.js 5.1.1 | Reading printed text from keepsakes | Only when you press "Read printed text" |
| JSZip 3.10.1 | Photo backup ZIP | Only when you press "Download all photos" |
| Google Fonts (Dongle) | Interface font | On page load |

---

## Deploying to Netlify

1. Push this folder to a GitHub repository.
2. In Netlify, choose **Add new site → Import an existing project** and select the repo.
3. Leave the build command empty and set the publish directory to `.` (or the folder containing `index.html`).
4. After the first deploy, add your Netlify URL to Supabase **Redirect URLs** (see step 4 above).

Each push to the main branch redeploys the site.

---

## How privacy and security work

- Every table has row-level security. A signed-in user can only read or write rows belonging to their own shared space.
- Photos are in a private bucket. They're shown through short-lived signed links. Storage rules check that you belong to the space whose ID is the first part of the file path.
- Pairing, leaving a space and deleting an account go through database functions, not direct table edits.
- Two Perspectives answers and daily-question answers are hidden by the database itself until the reveal condition is met. A direct API request cannot return a partner's answer early.
- Memory categories are locked to the fixed list by a database constraint.
- Passwords are handled by Supabase Auth. Eros never sees or stores them.

---

## Features that need extra setup

| Feature | Status |
|---|---|
| Map and address search | Works out of the box using OpenStreetMap. The public tile and search services are meant for light use, which suits a private two-person app. For heavy use, switch to a paid tile provider. |
| Reading text from keepsakes | Works when online. The OCR engine is downloaded the first time you use it. |
| Email verification and password reset emails | Use Supabase's built-in email, which has low sending limits. For reliable delivery, add your own SMTP provider in Supabase. |
| Push or email reminders | Not available. Reminders appear inside the app only. |

---

## Known limitations

- Reminders are in-app only. There are no push or email notifications.
- Keepsake photos can be rotated, trimmed and enhanced, but skewed photos can't be straightened (no perspective correction). Text reading works for printed text only, not handwriting.
- Scrapbook export is a PNG image. There's no printable PDF.
- Video, voice recordings, stickers on diary memories, and per-memory comments are not built.
- The calendar has Month and Agenda views but no week view.
- The timeline has no side-by-side comparison of relationship stages.
- Photobooth stickers are placed automatically, and photos are centre-cropped with no manual repositioning.
- Memory categories are fixed. Tags are free text.
- Large photo ZIP backups run in your browser and can be slow on big libraries.
- Photos from some phones in HEIC format may need to be converted to JPG first. Most phone browsers do this automatically when you pick a photo.

---

## Testing checklist

The app was built in stages. Run through this on two accounts (use a private window for the second).

1. Sign up account A, create a space, copy the invite link.
2. Sign up account B from the link and confirm both show as paired.
3. Add a memory with photos on A. Confirm B sees it.
4. Start a Two Perspectives. Answer on A and confirm B cannot see A's answer. Answer on B and confirm both appear.
5. Answer Today's question on each account the same way.
6. Add a birthday event that repeats yearly. Mark a date done and create a memory from it.
7. Add a place, use "Find on map", and check the pin appears.
8. Photograph a ticket in Collection, try "Clean document" and "Read printed text".
9. Build a scrapbook page and export it.
10. Make a photobooth strip, download it, and save it to a memory.
11. Switch light, dark and automatic themes in Settings, then refresh.
12. Download your data (JSON) and photos (ZIP).
13. Check key pages at phone, tablet and desktop widths.
14. Delete a throwaway account and confirm a partner keeps shared memories.

---

## Troubleshooting

**"Did you run schema_X.sql?"** The error message names the file. Run it in the SQL Editor, and run the earlier ones first if you skipped them.

**Photos don't appear.** Confirm the `memories` bucket exists (created by `schema_2a.sql`) and is private, and that you're signed in. Signed links expire after an hour; refresh the page.

**Sign-up emails don't arrive or links go to the wrong place.** Check Site URL and Redirect URLs in Supabase, and your spam folder. Supabase's default email sender is rate-limited.

**The invite link doesn't pair.** Invitations expire after 7 days and only work for an account that isn't already in a space. Create a new code in Settings → Your relationship.

**The logo font or favicon is missing.** Check the file names and that the `Assets/font` and `Assets/images` folders are capitalised exactly as shown.

**The map is blank.** Check your connection. If the map library can't load, Eros shows the list of places instead.

**Exporting a photobooth strip fails.** Re-upload the photo from your device instead of picking it from the diary, then export again.

**Changes don't show after deploying.** Hard-refresh the page (Ctrl+Shift+R, or Cmd+Shift+R on Mac) to clear the cached copy.
