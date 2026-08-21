---
name: backend
description: The Sakinah API — what each route does and why there are so few of them, the error and wire envelopes, the auth flow, and the sync merge semantics. Load before touching adhkar_api/app/, adding an endpoint, or changing a wire shape.
---

# The API

```
app/main.py        lifespan, CORS, error handlers, /health and /health/db
app/config.py      seven values from the environment
app/db.py          the pool, and the transaction that switches role
app/deps.py        who is calling
app/errors.py      the { data } / { error } envelopes
app/security.py    token generation and hashing
app/mail.py        the one email
app/serialize.py   wire shapes — the other half of data/content.dart
app/migrate.py     forward-only, applied in filename order
app/routes/        content, auth, sync
```

**The app it serves works without it.** The whole book is in the Flutter binary
(X2.1) and accounts are optional (F9.1), so everything here is an *update* path
or a *sync* path. That shapes what is worth building: no admin UI, no caching
layer, no read replica, because the busiest endpoint answers "nothing has
changed" in a few hundred bytes.

## The envelopes

Success is `{"data": ...}`. Failure is
`{"error": {"code", "message", "issues": [{field, message}]}}`. FastAPI's own
422 body is a different shape and is translated in `main.py`.

`serialize.py` is the other half of the client's `data/content.dart`. Every key
there is read by name over here, so a rename is a breaking change to a shipped
app — one that cannot be fixed by deploying the server.

## Routes

### content — unauthenticated on purpose (X6.1)

* `GET /content/version` — one integer. **This is the request that will actually
  be made.** A client that is up to date should learn so in a few hundred bytes,
  not by downloading 600 KB to find out nothing changed.
* `GET /content/snapshot` — the whole book, five statements, no joins. The
  client reassembles the graph from the join table exactly as it does for the
  bundled asset, so this and the builder produce the same object.
* `GET /content/dhikrs/{slug}` — one supplication, for a share or deep link.

**There is deliberately no per-chapter or per-collection endpoint.** The client
never needs one — it holds the whole book — and adding them creates a second way
to fetch content that can disagree with the first.

An empty database answers `contentVersion: 0` rather than 404, because every
client reads 0 as "older than mine" and nobody downloads an empty snapshot over
a working bundled one.

### auth — magic link, no password (F9.3)

```
POST   /auth/request   { email }   → a link is emailed (or returned, in dev mode)
POST   /auth/verify    { token }   → a session token + the account
GET    /auth/me
DELETE /auth/session               → this session only
DELETE /auth/account               → F9.4, by cascade
```

No registration step: requesting a link for an unknown address creates the
account on verification, because asking someone whether they have been here
before is asking them to remember.

`POST /auth/request` **does not say whether an account existed** — that answer
would make it a way to test whether an address is registered.

`POST /auth/verify` is safe against double redemption: `consumed_at IS NULL` in
the UPDATE's WHERE clause means two simultaneous redemptions produce one session
and one 401.

`DELETE /auth/session` revokes **this** session and no others — signing out on a
phone must not sign the same person out on their tablet.

`DELETE /auth/account` calls `delete_current_account()`, a `SECURITY DEFINER`
function that takes no id. The app role holds no DELETE on `users` on purpose;
see the `database` skill.

**Dev mode**: with no `RESEND_API_KEY` the link comes back in the response.
`_guard_dev_mode` in `main.py` refuses to start that way on a public origin
unless `ALLOW_INSECURE_DEV_MODE` is set. That variable is TODO item 3.

### sync — the whole of what an account does (F9.2)

```
GET    /sync           → favourites, completions, preferences
PUT    /sync           → merge this device's state in, return the merged result
DELETE /sync/history   → F5.4
```

**The merge is a union and deletions do not propagate.** This is deliberate and
documented at the top of the module:

* A completion is a *fact about a day that happened*. Nothing should remove one
  except the user asking.
* A favourite removed on one device and not yet synced is indistinguishable, on
  the wire, from one added on another device and not yet seen here. Resolving
  that correctly needs per-row tombstones and clocks; resolving it *wrongly*
  silently deletes things a user saved.

So unsyncing works on the device it was done on, and another device brings it
back until it too has been told. A real defect — TODO item 4 — that fails by
keeping too much rather than losing something, which is the right direction.

`test_sync_is_a_union_and_does_not_delete` asserts it, so changing it is
deliberate.

Preferences are last-write-wins on the whole row: they are settings, and a
settings screen is a single act of intent.

**The handlers carry no `WHERE user_id = …`.** That is not an oversight — RLS
scopes them. See the `database` skill.

## Adding an endpoint

1. Decide whether it is content (public, `transaction()`) or personal
   (`with_user()`).
2. Wire shape goes in `serialize.py`, and the Dart model changes with it.
3. Return through `errors.ok()`.
4. Add a test to `tests/test_end_to_end.py` — it runs against a real database
   and the RLS test is what would catch a scoping mistake.

`executemany` is a **cursor** method, not a connection method. Open one cursor
for the transaction.
