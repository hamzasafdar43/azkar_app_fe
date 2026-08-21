# Architecture — the decisions that are expensive to reverse

Six of them. Everything else in this project is a preference.

---

## 1. The content is a build artefact, not a database read

There is one content artefact: `adhkar_api/content/snapshot.json`, ~590 KB, and
it has three consumers:

```
content/sources/     vendored third-party data, verbatim
content/curated/     what we wrote — references, context, our chapter titles
        │
        │  scripts/build_content.py
        ▼
content/snapshot.json ──┬──► adhkar_app_flutter/assets/content/  (bundled, X2.1)
                        ├──► Postgres, via scripts/import_content.py
                        └──► GET /api/v1/content/snapshot
```

Three consumers, one shape, by construction. `test_served_snapshot_matches_the_bundled_one`
is what holds it together, and it is the most important test in the project:
PRD F1.5 has the client parse a downloaded snapshot with the *same* loader it
uses for its bundled asset, so a drift between those two shapes breaks the update
path on devices that have already shipped — the one class of bug that cannot be
fixed by deploying the server.

**Why a builder at all**, rather than editing content in a database and
generating the snapshot from it? Because the content's provenance is the
product. Every supplication has to be traceable to a source file and a licence,
and a build step from vendored inputs makes that a property of the pipeline
rather than a promise. It also means the whole book can be rebuilt from scratch,
offline, in two seconds — which is what makes a correction cheap.

**Why store it in Postgres too**, if the client never reads from there? Because
a *correction* has to be findable. "Which supplications cite Abu Dawud?", "which
have no transliteration?" — one SQL statement, versus a script over a blob.

**The slice-and-verify rule.** No word of the Qur'an and no word of a hadith is
typed into this repository. The curated files name a reference and the first and
last words of the supplication *without harakat*; the builder folds the source
text to find them and slices the **vowelled original** at the offset it found. A
marker that does not match is a build failure. This is what prevents "And say:"
being glued to the front of a du'a, and what prevents a hand-typed marker
introducing a misvowelled word into something a person recites.

**Reversing it** means giving up the offline guarantee (X2) or the provenance
guarantee (X1). Both are the product.

---

## 2. Content ships inside the binary

PRD X2.1. The complete book is an asset in the app bundle. The API serves the
same snapshot with a `content_version`, and the client replaces its copy when
the server is ahead (F1.5). There is no per-row fetch and no cache to warm.

The reason is where this app is used: a mosque basement, a plane, a hospital, a
country where data is expensive. An adhkar app that needs a network is broken in
exactly the places it matters most. X2.3 says nothing blocks the first screen,
and the cheapest way to guarantee that is to have the content already there.

**What it costs:** a content correction needs either an app update or a user who
opens the app online. A typo in an Arabic word of worship is a serious defect,
and this makes fixing it slower than server-rendered content would.

---

## 3. Accounts are optional

PRD F9.1 — the app is fully usable signed out, forever. No sign-in prompt on
launch, no feature behind an account.

This is the one structural departure from the sibling apps, and it is
deliberate. Al-Qaswa and Tibyan both require an account because both are
*records* — a child's progress, a hafiz's revision history — worthless without
continuity. This is a **book**. Demanding an email address before showing
someone the morning adhkar is charging for something that should be free at the
point of use.

**What it costs:** two code paths for every piece of personal state, and a merge
problem on first sign-in (see TODO item 4). The local store
(`data/local_store.dart`) is the whole surface, and it is the *primary* home for
user state rather than a cache in front of a server.

---

## 4. Postgres, no ORM, forward-only migrations, row-level security

Inherited from the sibling projects and re-adopted for the same reasons.

**No ORM.** Hand-written SQL, so the schema moves stacks unchanged and only
`app/db.py` would be thrown away.

**Forward-only migrations.** Add a numbered file; never edit an applied one. The
only record that `0003` ran is its name, so changing what that name means makes
the database and the repository disagree with no way to notice.

**Row-level security is the enforcement, not a backstop.** Every statement runs
as the unprivileged `adhkar_app` role via `SET LOCAL ROLE`, with
`app.current_user_id` bound. The handlers in `routes/sync.py` deliberately carry
no `WHERE user_id = …`: a handler that forgot one returns nothing rather than
someone else's record.

**The part that looks redundant and is not:** Neon's default role holds
`BYPASSRLS`, which bypasses RLS outright — `FORCE ROW LEVEL SECURITY` does not
stop it, because FORCE only subjects the table *owner* to its policies. Postgres
tests `BYPASSRLS` against the **effective** role, so the role switch is the only
thing enforcing isolation. Remove it and every policy silently stops applying.
`test_two_accounts_cannot_see_each_other` is the alarm.

**One place deviates, on purpose.** `users`, `magic_link_tokens` and `sessions`
sit outside RLS, because all three are read *before* there is an identity to
scope by — a policy on `sessions` keyed to `current_app_user_id()` could never
match, since resolving the session is what produces that id. They are protected
by only ever being reached through a lookup by 256-bit token hash. The
consequence is migration 0005: account deletion goes through a `SECURITY
DEFINER` function that takes no id and can only remove the bound row, rather
than a `GRANT DELETE ON users` that would put every account one handler bug away
from removal.

---

## 5. The morning/evening boundary is the clock

PRD F3.2, X3.2, and non-goal 1. Fixed local hours from the device's own
timezone. No location permission is requested and no prayer-time calculation
exists in the app.

The sunnah times are "after Fajr" and "after 'Asr", which means prayer times,
which means a location permission, a calculation method (at least six are in
common use), a madhhab setting for 'Asr, and a high-latitude rule. That is a
second product bolted onto this one, and one the user's phone probably already
has.

What makes it defensible rather than merely cheap is **F3.3**: the boundary
decides what is *offered first*, never what is reachable. Both sittings are
always one tap away. Being wrong costs a tap.

**Where it is properly wrong:** high latitudes in summer. `core/day_part.dart`
and its reversal are in decisions-pending-review §1.

---

## 6. Nothing celebratory

PRD X4, inherited from Tibyan and load-bearing here in a way it is not there.

No points, badges, levels, leaderboards, confetti or streaks. Days present,
never consecutive days. A missed morning is stated, never dramatised.

Two reasons, and the second is the one that decides it:

1. A person who says the evening adhkar because a counter would otherwise reset
   has been sold something other than what this app claims to give them.
2. **U4** — someone arrives at this app bereaved, frightened, in debt, or
   sitting with someone who is dying. "When You Need It" exists for them. Not
   one thing on the path they take may be cheerful.

Exactly one celebratory-adjacent thing is permitted: a quiet, unhurried state at
the end of a sitting that says it is done. It does not congratulate.

**This is under active revision.** The user has asked for goals and progress
rings (TODO N2, N3). Rings *within* a sitting are compatible; goals and rings
*across days* are not, and that is a product decision flagged for them rather
than taken.
