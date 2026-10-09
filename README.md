# Eros: Phase 1 (foundation)

1. Supabase > SQL Editor: paste and run `schema.sql`.
2. Supabase > Authentication > URL Configuration: set Site URL to your Netlify URL and add it (and http://localhost:8080) to Redirect URLs.
3. Adelia: add your licensed file as `fonts/Adelia.woff2`. Until then the logo uses a fallback script font.
4. Run locally: `python3 -m http.server 8080` in this folder, or push to GitHub and connect the repo to Netlify (no build command, publish directory `.`).
