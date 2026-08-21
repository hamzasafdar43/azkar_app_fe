---
name: general
description: Orientation for the Sakinah project (AdhkarApp) — where the FastAPI backend, Flutter client, content pipeline and PRD/architecture docs live, which sibling skill covers what, the settled decisions that must not be re-litigated, and the current state of every feature. Load this at the start of ANY work in ~/Documents/Projects/AdhkarApp, before searching for files or answering questions about features, content, schema, API endpoints or screens.
---

# Sakinah — general orientation

One tree is live: `~/Documents/Projects/AdhkarApp`. If a path is not under it, it
is not ours. **Three git repos, no monorepo root**, each with its own remote
under `github.com/Al-Qaswa/`:

```
~/Documents/Projects/AdhkarApp/
  adhkar_api/                  BE  — FastAPI + psycopg, no ORM. Also the content pipeline.
  adhkar_api/migrations/       DB  — numbered .sql, forward-only
  adhkar_api/content/          the sources, the curated files, the built snapshot
  adhkar_app_flutter/          FE  — native Flutter client
  adhkar_docs/                 PRD, architecture, content sources, deployment, TODO
  adhkar_docs/.claude/skills/  agent skills, including this file
```

**Sakinah** (سَكِينَة) is the app's name — the tranquillity God sends down. The
one-line description is "a pocket book of the Muslim": 327 transmitted
supplications across seven collections, every one carrying its source.

## Which skill to load

| Working on | Load |
| --- | --- |
| anything under `content/`, adding or correcting a supplication, the builder | **`content`** |
| `adhkar_api/app/` — routes, wire shapes, auth, sync | **`backend`** |
| SQL, migrations, RLS policies, a query returning nothing | **`database`** |
| `adhkar_app_flutter/` — screens, state, the design system, running it | **`client`** |
| Neon, Render, `DATABASE_URL`, a 500 from the live API | **`deploy`** |

Load the specific skill rather than re-reading code: they exist so that
`build_content.py`, five migrations and `render.yaml` do not have to be re-read
to find facts already written down.

## The docs

All paths relative to `adhkar_docs/`:

| File | What it is |
| --- | --- |
| `docs/PRD.md` | 1 Overview · 2 Domain primer · 3 Users · 4 Goals/non-goals · 5 Features F1–F10 · 6 Cross-cutting X1–X6 · 7 Open questions · 8 Decision log |
| `docs/architecture.md` | the six decisions expensive to reverse |
| `docs/content-sources.md` | every word's provenance and licence |
| `docs/decisions-pending-review.md` | every call made unattended, ranked by how much a second opinion is wanted |
| `docs/TODO.md` | part one: debt taken on knowingly. part two: what the user has asked for next (N1–N8) |
| `docs/dev_setup.md` | running it locally with no cloud account |
| `docs/deployment.md` | Neon + Render runbook |

**Feature IDs (`F4.3`, `X1.1`, `N6`) are the shared vocabulary** — use them in
commits, comments, tests and questions.

## Feature state

| | State | Where |
| --- | --- | --- |
| F1 content model | done | `scripts/build_content.py`, `data/content.dart`, migration 0003 |
| F2 seven collections | done | 327 supplications, 151 chapters |
| F3 time of day | done | `core/day_part.dart` |
| F4 counting | done | `ui/dhikr/reader_screen.dart` |
| F5 progress | **part** | F5.1–F5.4 locally; no reports screen (TODO N4) |
| F6 finding | **part** | F6.1–F6.3 done; F6.4 favourites done, no dedicated screen |
| F7 reading | done | `ui/widgets/arabic_text.dart`, `ui/settings/` |
| F8 sound | **not started** | audio URLs are in the content; nothing plays them |
| F9 accounts | **server only** | API done and tested; the client does not call it (TODO 5) |
| F10 settings | **part** | F10.2–F10.4 done; F10.1 language switching not wired |

## Settled decisions — do not re-litigate

**Every supplication carries its source (X1.1).** Enforced in three places: the
builder raises, the `dhikrs.reference` column is `NOT NULL CHECK (<> '{}')`, and
two tests assert it. This is the product's one non-negotiable claim.

**Arabic is never modified (F1.6).** Stored fully vowelled exactly as the source
has it. The only permitted transformation is *slicing* a supplication out of a
longer text, and a slice whose marker is not found is a **build failure**. No
word of the Qur'an and no word of a hadith is typed into the repository — see
the `content` skill.

**What is not from the Prophet ﷺ is marked (X1.3).** `attribution` is a
constrained column with three values, and `transmitted` renders a different chip
with the speaker named. Never infer attribution from which collection a
supplication sits in.

**Content ships inside the binary (X2.1).** ~590 KB asset; the API is an
*updater*, not the source at runtime. Nothing blocks the first screen; the app
has no network dependency at all today.

**Accounts are optional (F9.1), forever.** No sign-in prompt on launch, no
feature behind an account. The local store is the *primary* home for personal
state, not a cache. This is the deliberate departure from Al-Qaswa and Tibyan.

**The morning/evening boundary is the clock, not prayer times (F3.2).** No
location permission, ever. It decides what is *offered*, never what is
reachable, which is what makes fixed hours defensible.

**Nothing celebratory (X4).** No points, badges, levels, leaderboards, confetti
or streaks. Days present, never consecutive days. The reason that decides it is
U4: someone opens this bereaved or frightened, and nothing on their path may be
cheerful. *Under active revision* — the user has asked for goals and rings
(TODO N2, N3); rings within a sitting are compatible, goals across days are not.

**Handlers never write `WHERE user_id = …`.** Row-level security does it. A
query that forgets returns nothing rather than someone else's record.

**The snapshot the API serves and the one bundled in the app must stay the same
shape.** `test_served_snapshot_matches_the_bundled_one` is the most important
test in the project — a drift breaks the update path on shipped devices.

## Commands

Backend, from `adhkar_api`:

```bash
.venv/bin/uvicorn app.main:app --reload --port 8000
```

```bash
.venv/bin/python scripts/migrate.py && .venv/bin/python scripts/import_content.py
```

```bash
DATABASE_URL=postgresql://$USER@localhost:5432/adhkar_test .venv/bin/python -m pytest tests
```

Client, from `adhkar_app_flutter`:

```bash
flutter test && flutter analyze
```

## Machine-specific facts

* **Homebrew's Flutter is not usable by this user.** `/opt/homebrew/share/flutter`
  is owned by a different macOS account and every command fails writing its
  cache. Use `~/flutter/bin/flutter` (3.44.9 / Dart 3.12.2).
* **Postgres runs as `ayeshasmacbookpro`**, not as the login user and not as
  `postgres`. Local URL: `postgresql://ayeshasmacbookpro@localhost:5432/adhkar`.
* `.env` is gitignored and must never be committed.
* `adhkar_api/content/.cache/` holds ~55 MB of hadith books, downloaded on
  demand and gitignored. The committed artefact is `hadith_extract.json`.
