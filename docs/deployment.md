# Deployment — Neon and Render

The same shape as the sibling projects: Neon for Postgres, Render for the API.
Both free tiers are enough for this service, because the busiest endpoint
answers "nothing has changed" in a few hundred bytes.

## Neon

One project, one database. Two connection strings, and **which one you use
matters**:

* **Pooled** — the host with `-pooler` in it. This is what Render gets. The app
  opens a connection per request and returns it, which is exactly what
  PgBouncer's transaction mode is for.
* **Direct** — the host without it. This is what migrations and the content
  import use, from a laptop.

Migrations are multi-statement and create roles, which is not what a transaction
pooler is for. `AUTO_MIGRATE` is therefore `false` on Render, and the deploy
order is:

```bash
# with the DIRECT url in the environment
.venv/bin/python scripts/migrate.py && .venv/bin/python scripts/import_content.py
```

…and *then* let Render deploy. Code that needs a column must never reach
production before the column does.

## Render

Create the service from `adhkar_api/render.yaml`, or set the same values by
hand. Everything marked `sync: false` is entered in the dashboard and never
committed.

| Variable | |
| --- | --- |
| `DATABASE_URL` | the **pooled** Neon string |
| `APP_BASE_URL` | this service's public URL — the sign-in link is opened on a phone |
| `RESEND_API_KEY` | a mail provider. Without it the API is in dev mode |
| `MAIL_FROM` | a verified sender |
| `ALLOW_INSECURE_DEV_MODE` | **delete this before anyone outside the team has an account** |
| `AUTO_MIGRATE` | `false`, permanently |
| `CORS_ORIGINS` | only for a Flutter *web* build |

### The one that will bite

`ALLOW_INSECURE_DEV_MODE=true` lets the service boot with no mail provider on a
public URL — which means it hands a working sign-in token to anyone who asks for
one, for any address. It exists so the service can be stood up before mail is
configured.

**Setting `RESEND_API_KEY` does not close it.** The guard in `app/main.py` only
refuses to start when dev mode is on *and* the escape hatch is off. Leaving the
variable behind means the next person who unsets the mail key silently reopens
the hole. **Delete the variable.** TODO item 3.

## Diagnosing a live failure

```bash
curl -s https://<service>/health/db | python3 -m json.tool
```

`/health` deliberately never touches Postgres — a health check that woke a
scaled-to-zero Neon compute every thirty seconds would burn the free tier's
hours for nothing. So the service can look healthy while every real endpoint
500s, and `/health/db` is what answers the other question. It connects directly
rather than through the pool, because the pool swallows the real error and
raises `PoolTimeout` thirty seconds later.

What to read in the output:

* **`effective_role` is not `adhkar_app`** — migration 0002 did not take. Every
  authenticated endpoint is 500ing and row-level security is not applying.
* **`pooled: false`** on Render — the direct string was pasted in. It will work
  and then fall over under any concurrency.
* **`ok: false` with `detail`** — the real libpq error, with any userinfo
  redacted. Usually a wrong host or a missing CA.
* **`supplications: 0`** — migrations ran but `import_content.py` did not.

## Content updates

A content change is a three-step deploy, and none of the steps is a code deploy:

```bash
.venv/bin/python scripts/build_content.py        # rebuild the snapshot
.venv/bin/python scripts/import_content.py       # against the DIRECT url
```

Bump `CONTENT_VERSION` in `scripts/build_content.py` before rebuilding, or no
client will notice. Clients pull the new snapshot the next time they are online
(F1.5); a client that never goes online keeps the book it shipped with, which is
the intended behaviour and not a failure.

The import is one transaction and upserts by slug, so it is safe to run against
a database people are reading from: a reader sees the whole old book or the
whole new one, never half of each, and no favourite or completion is disturbed.
