# What is deferred, why, and what it costs to leave

Two halves. **Debt** is what was taken on knowingly while building, each with the
gate it blocks. **Next** is what the user has asked for since, not yet built.

---

# Part one — debt

## 1. The content has no written licence. *Release blocker.*

Two of the four content sources grant nothing in writing:

* **Hisn al-Muslim**, from `hisnmuslim.com`'s developer feed — the book's own
  publisher serving it for app developers, which is an implied grant.
* **hadith-json**, the nine-books compilation the Seerah and Companions
  collections are sliced from — no licence stated.

And Tanzil's Qur'an text is free to redistribute *non-commercially*, which needs
reading properly against whatever this app's business model turns out to be.

**Blocks:** any store listing. A free app among a handful of people is one
thing; a public listing is another.

**Cost to fix:** low, if the answer is no. Both unlicensed sources are
compilations of texts centuries out of copyright, and `build_content.py` has one
function per source — replacing one is a rewrite of that function, not of the
app. Full detail in [content-sources.md](content-sources.md).

## 2. 267 supplications cite a chapter, not a hadith

The Hisn feed carries no per-supplication citation, so everything from it cites
"Hisn al-Muslim — *chapter title*". PRD X1.1 says every supplication carries its
source, and this technically satisfies it while being much weaker than the other
three collections manage. X1.2's grading is missing for the same 267.

**Blocks:** nothing hard. But X1.1 is the product's one non-negotiable claim,
and this is the softest place in it.

**Cost to fix:** real work. The printed *Hisn al-Muslim* has a footnote per
supplication; matching 267 of them to a machine-readable hadith corpus is
mostly automatable (the Arabic is already vowelled on both sides and the fold in
`build_content.py` would do the matching) but needs a human pass.

## 3. `ALLOW_INSECURE_DEV_MODE` on a public origin. *Release blocker.*

With no `RESEND_API_KEY`, the API hands sign-in links back in the response body
to anyone who asks for one — which is what makes local development possible
without an inbox. `app/main.py` refuses to start that way on a public origin
*unless* `ALLOW_INSECURE_DEV_MODE=true`.

**Blocks:** anyone outside the team having an account.

**Cost to fix:** set `RESEND_API_KEY` **and delete the escape-hatch variable**.
Setting the key while leaving the variable behind fixes nothing for the next
person who unsets the key.

## 4. Sync deletions do not propagate

`PUT /sync` is a union. A favourite removed on one device comes back the next
time another device syncs, because on the wire "removed here" and "added there,
not seen here yet" are the same thing without per-row tombstones and clocks.

Documented at the top of `app/routes/sync.py` and asserted by
`test_sync_is_a_union_and_does_not_delete`, so changing it is deliberate.

**Blocks:** nothing. It fails by keeping too much rather than losing something,
which is the right direction for a list of supplications someone chose to save.

**Cost to fix:** a `deleted_at` column on `favourites` and a `since` parameter,
plus the client tracking what it has acknowledged. Half a day, and only worth it
once people actually have two devices.

## 5. There is no sync client

The API's sync endpoints are built and tested; the Flutter app does not call
them. Nothing in the app talks to the network at all — there is no `http`
dependency in the pubspec. F9.1 makes this survivable (the app is fully usable
signed out) but F9.2, the entire reason to have an account, is server-side only.

**Blocks:** accounts being useful to anyone.

**Cost to fix:** `http` + `flutter_secure_storage`, an `ApiClient`, and a merge
into `LocalStore`. The merge is the interesting part; the transport is not.
See "Next" item N1, which is the same work seen from the product side.

## 6. No deep link for the sign-in email

`GET /auth/verify` renders a page that shows the code for the user to paste back
into the app. That is honest and it is not good.

**Cost to fix:** a universal link / app link, platform config on both sides, and
turning that handler into a redirect. Half a day, mostly certificate plumbing.

## 7. The Tabi'un are missing, and the Companions collection is thin

"Prayers of the Companions" has one supplication that is a companion's own
words. The rest are prophetic supplications taught to a named person or made for
one — which is why the collection is named "Taught to them, made for them, said
by them" rather than something that would overclaim.

The companions' own du'as, and the Tabi'un's, are in the zuhd literature — Ibn
Abi Shaybah's *Musannaf*, Abu Nu'aym's *Hilyah*, Ibn al-Mubarak. None of it
exists as a vowelled machine-readable corpus, and typing it from memory is
exactly what the whole slice-and-verify pipeline exists to prevent.

**Cost to fix:** find or build the corpus. Days, not hours.

## 8. Audio is not built

F8. Every supplication from the two Hisn-derived sources carries a recording URL
and nothing plays it. PRD open question 5 is the reason: streaming from a
third-party host is a dependency we do not control, and bundling is ~80 MB.

## 9. Only English chrome

F10.1 promises English and Arabic at launch. The content is language-keyed and
carries Arabic throughout; the app's own strings are English literals in the
widget tree. Urdu is open question 4 and is an import, not a schema change.

## 10. No layout regression test

The Hifz app learned this the hard way: the widget test suite's default surface
is wider than any phone, so overflows hide. There is no equivalent of its
`phone_layout_test.dart` here yet, driving the real screens at 320pt and 390pt,
at 1.6× text, in dark.

**Cost to fix:** an afternoon, and it will find things.

---

# Part two — next, as asked for

Raised by the user on 2026-08-21. Numbered N-something so they can be referred
to before they earn PRD feature IDs.

## N1. Guest by default, with a way in — *and the whole point of signing in*

> "either u can use as guest, launch > main screen — or there is tiny button on
> main to sign up/in — then u can start recording azkar"

Launching straight to the book is already how it works (F9.1) and is not
negotiable. What is missing is the **tiny button**: a quiet affordance on the
home screen, and an answer to "why would I?".

The answer the user gives is *recording* — a signed-in user's completions are
kept and reported back (N4, N5). That is a sharper reason than "sync across
devices", and it means N1 depends on debt item 5.

**Shape:** an unobtrusive row at the bottom of home — not a banner, not a modal,
never on launch. Signed in, it becomes the account row.

## N2. Goals for the morning and evening sittings

> "goals for mor/eve"

A target the user sets — say the morning sitting five days a week.

**⚠ This revises PRD X4**, which rules out anything that reads as a score, and
says days present rather than consecutive days. A goal is not a streak, but it
is the first thing in this app that can be *failed*, and U4 (someone opening
this bereaved or frightened) is the reason X4 is written the way it is.

**The reading that keeps X4 intact:** a goal is a private intention, stated once,
never counted down at the user, never coloured red, and never mentioned on a day
it was missed. "Said on 4 of the last 7 days" with a quiet marker at 5, rather
than "1 to go!" — and nothing on the home screen about it at all.

**This is the user's call, not mine.** Flagged rather than assumed.

## N3. Progress rings

> "rings for progress"

Two readings, and they are very different products:

* **Within a sitting** — a ring around the counter that fills as the repetitions
  are said. This is just a better counter and it is entirely compatible with X4.
  Cheap, and worth doing regardless.
* **Across days** — three closing rings, Apple-Fitness style. This is the
  gamification X4 rules out by name.

**Building the first.** The second waits on N2's answer.

## N4. Week and month reports

> "week/month reports"

The data is already there — `completions` holds a row per sitting per day, both
locally and server-side, and `AppState.daysPresent` already reads it.

**Shape:** a calendar grid of the month with the days present marked, and a
single sentence. No bar chart of "your best week", no comparison to last month.
X4's rule is that a missed day is stated and never dramatised, which a calendar
does naturally and a trend line does not.

## N5. Prayer of the day

> "prayer of the day to familiarize with new prayers"

One supplication surfaced on the home screen daily, drawn from parts of the book
the user has not opened.

The nice property: it needs **no server and no randomness that has to be
stored**. Seed a shuffle with the date, and every device shows the same
supplication on the same day without anyone coordinating — while the "not yet
opened" weighting stays local and private.

**Care needed:** the rotation must not put a funeral supplication or a du'a for
the dying in front of someone at breakfast. The pool needs a curated exclusion,
which is a content field, not a client filter.

## N6. "I have N minutes" — a sitting sized to the time available

> "morning/eve > option to set for how many minutes i wanna read, show as much"

The best idea in this list, and the one most in the spirit of the app: someone
with four minutes before work says the four minutes' worth rather than opening a
26-item list and abandoning it.

**What it needs:** a duration per supplication. The repeat count is a poor
proxy — `subhanallah` a hundred times and a long du'a said once are both "one
item" and nothing like the same length. Estimating from Arabic character count
times repeat is a decent first pass and can be tuned later from real counting
data, which the app is in a position to collect.

**What it must not do:** truncate the sitting silently. The order in the book is
the order it is said in, so a shortened sitting is an explicit "the first N of
26", with the rest one tap away — not a different sitting that looks complete.

## N7. Read a whole collection on one page

> "prophet prayers and such others, i dont wanna click each name and then read,
> all on 1 page option etc"

Right, and it applies well beyond the Prophets. The current reader is one
supplication per page, which is correct for *counting out a sitting* and wrong
for *reading through a collection*.

**Shape:** a mode toggle on the collection screen — paged (count it) or
continuous (read it). Continuous is a single scroll of the whole collection with
chapter headings inline, no counters, no page turns.

Cheap: `DhikrBody` already renders one supplication as a list of slivers, so
continuous mode is the same widget in a different scroll parent.

## N8. Icons for the chapters, not just the collections

> "i want more icons etc for travel and other things clothes, as its long list"

"Through the Day" is 81 chapters of text rows, which is a wall. Icons per
chapter would make it scannable — clothes, travel, food, sleep, the mosque,
rain, Hajj.

**Where it belongs:** a `glyph` column on `chapters`, mirroring the one
`collections` already has. The client maps a symbolic name to an icon (see
`glyphIcon`), so this ships as a content change and needs no app release.
81 names to assign, an hour of work, and one migration.

**Also worth doing at the same time:** "Through the Day" is long enough that it
wants sub-grouping — waking, the mosque, eating, travel, sleeping — which is a
content change too, not a code one.
