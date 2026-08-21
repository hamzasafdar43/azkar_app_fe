# Getting it running

No cloud account is needed. A local Postgres and a simulator are enough.

## Once

```bash
brew install postgresql@17 && brew services start postgresql@17
```

```bash
createdb adhkar && createdb adhkar_test
```

Backend, from `adhkar_api`:

```bash
python3.13 -m venv .venv && .venv/bin/pip install -r requirements.txt
```

```bash
cp .env.example .env
```

Leave `RESEND_API_KEY` empty. With no mail provider the API runs in **dev mode**
and returns the sign-in link in the response body instead of emailing it, which
is what makes the auth flow usable without an inbox. `app/main.py` refuses to do
that on a public origin.

## Each time

Migrate, import the book, serve:

```bash
.venv/bin/python scripts/migrate.py && .venv/bin/python scripts/import_content.py
```

```bash
.venv/bin/uvicorn app.main:app --reload --port 8000
```

Check it:

```bash
curl -s localhost:8000/health/db | python3 -m json.tool
```

`effective_role` must read `adhkar_app`. If it does not, migration 0002 did not
take and every authenticated endpoint will 500 — see architecture §4.

Client, from `adhkar_app_flutter`:

```bash
flutter run
```

The client does not call the API at all today (TODO item 5). It reads the
bundled snapshot, so it runs with the backend stopped.

## Rebuilding the book

After editing anything under `adhkar_api/content/`:

```bash
.venv/bin/python scripts/build_content.py
```

```bash
cp content/snapshot.json ../adhkar_app_flutter/assets/content/
```

```bash
.venv/bin/python scripts/import_content.py
```

If you added a hadith citation to `content/curated/seerah.json` or
`companions.json`, run the extractor first — it downloads the nine books into a
gitignored cache and pulls out just the narrations cited:

```bash
.venv/bin/python scripts/extract_hadith.py
```

**The builder is strict on purpose.** It refuses to emit a supplication with no
citation, and a Qur'anic or hadith slice whose marker is not found is a build
failure rather than a silent fallback. If it fails, it has caught something.

## Tests

Backend — writes real rows, so point it at the scratch database:

```bash
DATABASE_URL=postgresql://$USER@localhost:5432/adhkar_test .venv/bin/python -m pytest tests
```

That database needs migrating and importing once, the same as the main one.

Client:

```bash
flutter test && flutter analyze
```

## Troubleshooting

**`permission denied to set role "adhkar_app"`** — migration 0002 has not run,
or ran as a different role than the one now connecting. Re-run
`scripts/migrate.py` as the role in your `DATABASE_URL`.

**`certificate verify failed` against a managed Postgres** — the connection
string says `sslrootcert=system`, and the libpq inside psycopg's wheel has no
system trust store to find. `app/db.py:resolve_ca` handles this; if you see it,
that function was bypassed.

**`expected dev mode; is RESEND_API_KEY set?`** in the tests — it is set in your
`.env`. Unset it, or the auth fixture cannot get a link back.

**Flutter cannot write to its cache** — on this machine the Homebrew Flutter
under `/opt/homebrew/share/flutter` is owned by a different macOS user. Use
`~/flutter/bin/flutter`.
