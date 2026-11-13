# Straight to the Pavilion

A retro cricket trump card game for 80s, 90s and 2000s kids. Pure HTML, CSS and JavaScript: no build step.

## Folder layout

```
index.html            the game (all code)
cards.csv             every card: stats plus a link to the player's photo
players/              player photos, one file per player (e.g. rahul-dravid.jpg)
flags/                country flags
stadiums/             stadium backgrounds
audio/                crowd-sfx.mp3
database/             supabase-setup.sql (online accounts, run once in Supabase)
```

## Run it on your PC

`index.html` loads `cards.csv` with `fetch`, and browsers block that when you double-click the file.
Use a local server instead: in VS Code install **Live Server**, right-click `index.html`, **Open with Live Server**.

## Publish

Push the whole folder to your GitHub repo (the repo root should contain `index.html`) and turn on
**Settings > Pages > Deploy from a branch > main / root**.

## Editing cards.csv

One row per player per format. Columns:

| column | notes |
|---|---|
| format | `Test`, `ODI` or `T20I` |
| name | shown on the card; the photo is matched by this name |
| country | `IND AUS PAK ENG SL WI SA NZ BAN ZIM AFG IRE` (needs a matching flag in `flags/`) |
| role | `Batsman`, `Bowler`, `Wicket-keeper`, `Batting All-rounder`, `Bowling All-rounder` |
| matches, runs, average, hundreds, fifties, wickets, bowl_avg, catches_stumpings, not_outs, highest | numbers; leave `bowl_avg` blank if the player never bowled |
| bbi_wickets, bbi_runs | best bowling in an innings, e.g. 5 and 32. Blank if none |
| strike_rate, econ_rate | used only for T20I rows |
| photo | path such as `players/rahul-dravid.jpg`. Blank = initials on a gradient |

Tips: keep each format at 60 cards (12 per role) so the deal is even for 2 to 6 players. Save as
**CSV UTF-8** from Excel. Keep the header row as it is.

## Adding a player photo

1. Export the image at about 720 x 774 px (ratio 0.93:1), JPG, 40 to 60 KB.
2. Name it after the player in lowercase with dashes, e.g. `sachin-tendulkar.jpg`, and put it in `players/`.
3. Put `players/sachin-tendulkar.jpg` in the `photo` column for that player's rows (all three formats if he is in all three).

Keep the top 25% of the picture free of the face: the name banner covers it, and the flag covers the top-right corner.

## Online accounts (optional)

Without setup, accounts are saved on each device only. To make usernames unique across devices, follow
the steps in the chat: create a free Supabase project, run `database/supabase-setup.sql`, then paste the
project URL and key into `const DBCFG={url:"",key:""};` near the top of the script in `index.html`.
