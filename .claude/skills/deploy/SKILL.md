---
name: deploy
description: Running Sakinah on Neon and Render — which connection string goes where, the deploy order, the environment variable that will bite, and how to diagnose a live failure. Load for anything about DATABASE_URL, deploying, or a 500 from the live API.
---

# Deploy

Neon for Postgres, Render for the API. Both free tiers are enough: the busiest
endpoint answers "nothing has changed" in a few hundred bytes.

Full runbook in `docs/deployment.md`. The parts that matter:

## Two connection strings, and which goes where

* **Pooled** (`-pooler` in the host) → **Render**. The app opens a connection
  per request and returns it, which is what PgBouncer's transaction mode is for.
* **Direct** (no `-pooler`) → **your laptop**, for migrations and the content
  import. Those are multi-statement and create roles, which a transaction pooler
  is not for.

`AUTO_MIGRATE` is `false` on Render permanently, because Render only ever holds
the pooled string. So the deploy order is:

```bash
# DIRECT url in the environment
.venv/bin/python scripts/migrate.py && .venv/bin/python scripts/import_content.py
```

…and *then* let Render deploy. Code that needs a column must never reach
production before the column does.

## The variable that will bite

`ALLOW_INSECURE_DEV_MODE=true` lets the service boot with no mail provider on a
public URL — which means it hands a working sign-in token to anyone who asks,
for any address.

**Setting `RESEND_API_KEY` does not close it.** The guard in `app/main.py` only
refuses to start when dev mode is on *and* the escape hatch is off. Leaving the
variable behind means the next person who unsets the mail key silently reopens
the hole. **Delete the variable.** TODO item 3, a release blocker.

## Diagnosing

```bash
curl -s https://<service>/health/db | python3 -m json.tool
```

`/health` deliberately never touches Postgres — a health check that woke a
scaled-to-zero Neon compute every thirty seconds would burn the free tier's
hours for nothing. So the service can look healthy while every real endpoint
500s, and this answers the other question. It connects **directly** rather than
through the pool, because the pool swallows the real error and raises
`PoolTimeout` thirty seconds later.

| Symptom | Cause |
| --- | --- |
| `effective_role` is not `adhkar_app` | migration 0002 did not take. Every authenticated endpoint is 500ing **and RLS is not applying** |
| `pooled: false` on Render | the direct string was pasted in. Works, then falls over under concurrency |
| `ok: false` with `detail` | the real libpq error, userinfo redacted. Usually a wrong host or a missing CA |
| `supplications: 0` | migrations ran, `import_content.py` did not |

## `sslrootcert=system`

Neon's copy-paste string says this, and the libpq inside psycopg's binary wheel
has no system trust store to find — so it resolves to nothing and every
connection dies with "certificate verify failed" while the string looks perfect.
`app/db.py:resolve_ca` swaps in certifi's bundle. Verification stays full; this
changes *which* trust store is used, not whether the server is authenticated.

## Content updates are not code deploys

```bash
.venv/bin/python scripts/build_content.py     # bump CONTENT_VERSION first
.venv/bin/python scripts/import_content.py    # against the DIRECT url
```

The import is one transaction and upserts by slug, so it is safe against a
database people are reading from: a reader sees the whole old book or the whole
new one, never half, and no favourite or completion is disturbed.

Clients pull the new snapshot next time they are online (F1.5). A client that
never goes online keeps the book it shipped with — intended, not a failure.
