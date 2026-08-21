---
name: database
description: The Sakinah schema — five migrations, what is inside row-level security and what is deliberately outside it, why the role switch is not optional, and the rules for adding a migration. Load before writing SQL, adding a migration, or diagnosing a query that returns nothing.
---

# The schema

Five forward-only migrations. **Never edit one that has been applied** — the
only record that `0003` ran is its name, so changing what that name means makes
the database and the repository disagree with no way to notice.

```
0001_accounts.sql            users, magic_link_tokens, sessions, the app role, pg_trgm
0002_app_role_membership.sql lets the connecting role SET ROLE to adhkar_app
0003_content.sql             collections, chapters, dhikrs, chapter_dhikrs, content_version
0004_personal.sql            favourites, completions, preferences — all RLS
0005_account_deletion.sql    delete_current_account(), SECURITY DEFINER
```

## The role switch is what enforces isolation

Every statement runs through `app/db.py:transaction()`, which does
`SET LOCAL ROLE adhkar_app` and binds `app.current_user_id`.

**It looks redundant and it is not.** Neon's default role holds `BYPASSRLS`, and
that attribute bypasses row-level security outright — `FORCE ROW LEVEL SECURITY`
does **not** stop it, because FORCE only subjects the table *owner* to its
policies. Postgres tests `BYPASSRLS` against the **effective** role, so switching
to `adhkar_app` is the only thing that re-enables per-user isolation. Remove the
`SET LOCAL ROLE` and every policy in 0004 silently stops applying.

0002 exists because 0001 creates the role and grants it privileges but never
grants anyone *membership* in it. On a local superuser connection that omission
is invisible; on Neon, RDS or Supabase the connecting role is not a superuser and
`SET LOCAL ROLE` fails on the very first request, taking every endpoint with it.
The membership is granted `WITH INHERIT FALSE, SET TRUE` — inheriting the
privileges automatically would blur the line the role exists to draw.

Both settings are transaction-local, so nothing leaks into the next request over
a pooled connection. That is what makes this safe on PgBouncer.

## What is inside RLS and what is not

**Inside** — `favourites`, `completions`, `preferences`. One `FOR ALL` policy
each, `user_id = current_app_user_id()` in both USING and WITH CHECK. There is
no sharing in this app and no admin view of a user's record, so "it is mine" is
the whole access model and one policy states it exactly once.

**Outside, deliberately** — `users`, `magic_link_tokens`, `sessions`. All three
are read *before* there is an identity to scope by: a policy on `sessions` keyed
to `current_app_user_id()` could never match, because resolving the session is
what produces that id. They are protected by only ever being reached through a
lookup by 256-bit token hash.

**Outside, because it is a book** — `collections`, `chapters`, `dhikrs`,
`chapter_dhikrs`, `content_version`. X6.1: content is public. `SELECT` only for
the app role; writes happen through `scripts/import_content.py` as the owner.

### The consequence: account deletion

Because `users` is outside RLS, `GRANT DELETE ON users TO adhkar_app` would put
every account in the system one handler bug away from removal — and deletion is
the one genuinely irreversible operation here. 0005 instead adds
`delete_current_account()`, `SECURITY DEFINER`, `SET search_path = public,
pg_temp`, which takes **no id** and can only delete the row bound for this
transaction. The app holds no DELETE on the table.

(That migration exists because a test found the bug: `DELETE /auth/account`
failed with "permission denied for table users".)

## Handlers never write `WHERE user_id = …`

Not an oversight. RLS does the scoping, so a handler that forgot one returns
nothing rather than someone else's record — which is the property X6.2 exists to
give. `test_two_accounts_cannot_see_each_other` is the alarm.

## Content tables

Two things worth knowing:

**`dhikrs.reference` is `NOT NULL CHECK (reference <> '{}'::jsonb)`.** X1.1 is
the product's one non-negotiable claim, so it is a constraint rather than a
convention: a supplication with no citation cannot be stored, which means it
cannot be served, which means it cannot reach a phone.

**`favourites.dhikr_slug` and `completions.chapter_slug` are deliberately NOT
foreign keys.** The client is the source of truth for both — they are set
offline, on a device whose bundled book may be a version behind. A foreign key
would make syncing from an older client fail on a slug the server has since
re-slugged, turning a content edit into data loss. They are validated by shape;
an unresolvable slug is simply not rendered.

**Localised text is JSONB keyed by language code.** Never one column per
language — Urdu is a deferred *import*, not a schema change.

## Adding a migration

Add a new numbered file. Then:

```bash
.venv/bin/python scripts/migrate.py
```

Against the **direct** endpoint, never the pooled one — migrations are
multi-statement and create roles. `AUTO_MIGRATE` is off on Render for that
reason, so **migrate before deploying code that needs the change**.

`schema_migrations` is deliberately left without a grant to `adhkar_app`: the
application has no business reading it, and `/health/db` reads it before the
role switch.

## When a query returns nothing

In order of likelihood:

1. No user bound — the route used `transaction()` instead of `with_user()`.
2. The role switch did not happen. Check `/health/db`'s `effective_role`.
3. The row genuinely belongs to someone else. That is RLS working.
