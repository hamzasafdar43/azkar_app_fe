# The film — Adhkar

A 47-second piece for Reels, TikTok, Shorts and Stories. Nothing in it is
stock: the screens are real screenshots of a real build, and the music is
synthesised here from arithmetic.

> Moved 2026-09-07 from `adhkar_app_flutter/marketing/` — the film sits with
> the app documentation, not inside the Flutter tree. Same three companion
> films (Salah, Qaswa, Tibyan) live under their own `docs` repos.

```bash
python3 soundtrack.py bed.wav 46.97         # the bed, cut to the film
swift render.swift                          # 1080x1920 -> out/sakinah.mp4
swift render.swift storyboard.json out/sakinah-4x5.mp4 1080 1350
```

Both need only macOS. There is deliberately no ffmpeg: Homebrew on this
machine belongs to another account (the same reason `~/flutter/bin/flutter`
is used over the Homebrew one), so the pictures go through AVFoundation and
CoreText exactly as the icons go through `design/rasterize.swift`.

## The four pieces

| | |
| --- | --- |
| `storyboard.json` | every word on screen and every duration. **Edit this first** — it is the only file that needs touching to change the script |
| `shots/` | screenshots, straight off the simulator at 1206x2622 |
| `soundtrack.py` | the bed. No sample, no recording, nothing to licence |
| `render.swift` | draws each frame and muxes. Takes no editorial decisions |

## Why the bed sounds like that

A drone on D with its fifth and octave, under a sparse line in **maqam
Hijaz**. The augmented second between E-flat and F-sharp is the interval that
reads as Arab rather than as European, and it is the only reason the track
sounds like this app instead of like a meditation stock cue.

The committed default is this synthesised bed, because it is the only one that
survives a clone: `music/` and `out/` are ignored, so a licensed download is on
the machine that fetched it and nowhere else.

It is synthesised because the alternative is not: a nasheed or a recitation
pulled off the web is somebody's work, and a platform's content matcher will
claim it on upload even when the licence is fine. If a licensed bed is bought
later, point `audio` in the storyboard at it — nothing else changes.

A recitation of Qur'an was deliberately **not** used as background music.

## Retaking the screenshots

The status bar is overridden so it reads 9:41 with a full battery and no
"back to app" breadcrumb from whatever launched the build:

```bash
xcrun simctl status_bar <udid> override --time "9:41" --batteryState discharging --batteryLevel 100
```

Launch from `simctl launch` rather than from another app, or the breadcrumb
comes back. Screenshots 12–14 are the dark theme (`simctl ui <udid>
appearance dark`); the film runs light for the morning half and dark for the
evening half, which is the arc rather than a mixed palette.

The reader's counts persist, so a dhikr that was counted out in an earlier
session shows "Next" instead of a counter. The reset control in the reader's
app bar puts the ring back.

## Layout

Every measurement in `render.swift` is expressed against the 1080x1920 the
piece was designed at and scaled by `k = h / 1920`, so a new aspect ratio is
two command-line arguments and not a second layout to keep in step.

## What it claims

Only things the app does today. The time-budget sitting (N6), the source on
every supplication (X1.1), the counting (F4), search (F6), the seven
collections (F2) and the local-only record (F9.1) are all on screen and all
real. Nothing here promises audio (F8) or the reports screen (N4).
