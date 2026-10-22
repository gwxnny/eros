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
- A banner with both your names, a custom background photo, "Since Monday, 9 December 2024", a live count of time together and a live countdown to your next anniversary, both in years, months, days, hours, minutes and seconds.
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

**Stamps** (in Collection)
- Cut a stamp from any photo: pick the area, shape and edge, add a place and time. The stamp gets perforated edges and goes into a paged stamp album.
- Tap a stamp to see the photo it was cut from, with the stamp-shaped hole left in it. The uncut original is not kept.

**Photobooth**
- Upload your own stickers and keep them in a saved library shared with your partner. Drag, resize and rotate them on the strip.
- Booth flow: countdown photo sequence (4, 6, 8 or 10 shots), pick your favourites, style the strip, then watch it print. You can also use your own photos.
- Upload, camera capture, or pick photos from your diary.
- Layouts: 4-photo strip, 3-photo strip, 2-photo strip, 2×2 grid.
- Presets, background colour, border, spacing, corners, film filters, brightness and contrast, stickers, caption, names, date stamp, text alignment and position.
- Export PNG or JPEG, and save strips into your memories.

**Settings**
- Profile photo, display name, nickname, favourite categories.
- Relationship name and dates, invitation code, partner status, disconnect.
- Appearance: light, dark or automatic; rose or dusty-blue accent; decoration toggle.
- Reminder preferences, data export (JSON), photo backup (ZIP), change password, log out, delete account.

**Partnership** (equal members, one shared space)
- Five icon tabs: Home, Together (Diary, Plans, Timeline), Activities (Perspectives, Places, Photobooth), Notifications (with unread badge) and Settings. Mobile uses a bottom bar.
- Both partners' photos and names appear equally; every memory, photo, story and comment shows who added it and when.
- Either partner can add their own story, photos, comments and reactions to a shared memory. Only the person who wrote something can edit or delete it.
- Memories can be private (only you) or shared. A partner can move a shared memory to Recently Deleted (the owner is told and either can restore it), but only the creator can delete it forever, and not while the other person has added to it.
- In-app notifications for what your partner posts or changes, grouped when related, never for your own actions or private content.
- Shared accent colours for the whole app, set by either partner, with a live preview and reset.
- Optional calendar sharing, including availability-only. Leaving or deleting an account never deletes shared content; it shows as "Former member".

**Folders, cutouts and scrapbook**
- Shared folders group memories, keepsakes and scrapbook pages. Deleting a folder never deletes what's inside it.
- Cutout studio: lasso, crop, erase and restore brushes, undo and redo, and automatic subject cutout that runs on your device. Cutouts are transparent PNGs; the original photo is kept.
- Scrapbook elements are saved one by one and edited only by whoever added them, so you can both work on the same page without overwriting each other. Move, resize, rotate, layer, duplicate, frame, outline and shadow, with undo and redo.
- Automatic cutout uses the open-source `@imgly/background-removal` library (AGPL-3.0), loaded from a CDN when first used. Your photo is processed in your browser and is never uploaded; only the model files are downloaded (tens of MB, then cached). It's free to use. If you ever make Eros a public product, check that licence.

**Scrapbook editing and assistant**
- Tap any scrapbook element to get a Canva-style toolbar: for text, font, size, colour, bold, italic, alignment, shadow and rotation; for images, size, rotation, frame, outline and shadow; plus layer order, copy and delete.
- Ten paper styles for scrapbook pages, including kraft, vintage, lined, grid, dotted and linen. They also appear in exported images.
- A built-in assistant (the chat icon in the header) opens pages, adds plans, birthdays, bucket-list ideas and folders, searches memories and answers quick questions. It runs entirely in your browser; it is not a language model and nothing you type is sent anywhere.

**Scrapbook look**
- The whole app sits on seamless paper (generated in the browser, so there are no visible tiles), with taped cards, stitched edges, print-style photos, a hand-drawn underline on page titles and sticky-note toasts.

**Albums and any-format uploads**
- Collection → Albums: drop or choose as many photos, videos and files as you like, in any format, up to 50 MB each (Supabase's free-plan limit). Originals are kept untouched, with small previews made on your device.
- Memories accept any file type too: images are resized and saved as photos (up to 30 per memory, iPhone HEIC photos are converted in the browser), and videos and other files are kept as attachments.
- Free storage is 1 GB in total across photos, videos and files, so large videos use it up quickly. Albums shows how much it is using.

**Places from memories**
- Any location you type on a shared memory is added to Places automatically, with a map pin when it can be found, and the memory's date is counted as a visit. Private memories are never added.

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
schema_8.sql            Couple cover photo, stamp collection, storage update rule
schema_9.sql            Saved sticker library for the Photobooth
schema_10.sql           Partnership: contributions, notifications, privacy, shared colours
schema_11.sql           Folders, cutout stickers, collaborative scrapbook elements
schema_12.sql           Albums (any file type) and file attachments on memories
Assets/font/Tourmines.otf     Logo font
Assets/images/logo.png        Favicon and home-screen icon
README.md
```

Netlify is case-sensitive. Keep the folder names exactly `Assets`, `font` and `images`.

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