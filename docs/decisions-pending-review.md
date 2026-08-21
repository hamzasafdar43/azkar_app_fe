# Decisions taken without the user — pending review

Every call made while building unattended, with the reasoning and how to undo it.
Nothing here is settled; each is a judgement that deserves a second opinion. Once
reviewed, the ones that stand move into the `general` skill's "Settled decisions"
section and are deleted from here.

Ordered by how much I would want a second opinion, most first.

---

## 1. The morning/evening boundary is the **clock**, not prayer times

**What I did.** F3.1 offers the morning sitting from 04:00 to 12:00 local and the
evening sitting from 15:00 to 20:00, from the device's own timezone. No location
permission is requested and no prayer-time calculation exists in the app.

**Why.** The sunnah times are "after Fajr" and "after 'Asr", which means prayer
times, which means a location permission, a calculation method (there are at least
six in common use), a madhhab setting for 'Asr, and a high-latitude rule. That is a
second product bolted onto this one, and it is a product a user's phone probably
already has. It also breaks X3.2 — asking a worshipper for their location in order
to show them a book is a bad trade.

Crucially, F3.3 means the cost of being wrong is *small*: the boundary decides what
is **offered first**, never what is reachable. A user at 13:00 who wants the
morning adhkar taps one more time.

**Cost if wrong.** In a Scottish summer, Fajr is around 02:30 and 'Asr around
17:30, so the offered sitting will be wrong for part of the year. Anyone in the far
north or south will notice.

**To reverse.** Two options, in increasing cost:
 1. A manual override in settings — "my day starts at" / "my evening starts at".
    An hour of work, no permission, and it fixes the high-latitude case for anyone
    willing to set it once. **This is what I would do first.**
 2. Real prayer times: a calculation library, a location permission, a method
    picker. `core/day_part.py` and its Dart twin are the only things that would
    change; everything downstream reads `DayPart.morning | evening | neither`.

---

## 2. Accounts are **optional**, unlike every other app in this family

**What I did.** F9.1 — the app is fully usable signed out, forever. No sign-in
prompt on launch, no feature behind an account. Favourites, counters, reading
preferences and completion history all work locally. Signing in only adds sync.

**Why.** Al-Qaswa and Tibyan both require an account because both are *records* —
a child's progress, a hafiz's revision history — that are worthless without
continuity. This is a **book**. Demanding an email address before showing someone
the morning adhkar is asking for payment in personal data for something that
should be free at the point of use, and the first thing a lot of users would do is
close it.

**Cost if wrong.** Two code paths for every piece of personal state — local store
and server — and the merge on first sign-in is a real problem (see the TODO). If
the product later depends on knowing its users, this makes that harder.

**To reverse.** Hard, and getting harder with every screen. The local store
(`data/local_store.dart`) is the whole surface; making accounts mandatory means
deleting it and routing everything through the repository. Better to decide now
than in six months.

---

## 3. Content ships **inside the binary**, with the API as an updater

**What I did.** X2.1 — the complete book is a JSON asset in the app bundle. The API
serves the same snapshot with a `content_version`, and the client replaces its copy
when the server is ahead. There is no per-row fetch and no content cache to warm.

**Why.** An adhkar app that needs a network is broken in exactly the places it is
most used: a mosque basement, a plane, a hospital, a country with expensive data.
X2.3 says nothing blocks the first screen, and the cheapest way to guarantee that
is to have the content already there. The snapshot is ~1.5 MB of JSON — smaller
than a single illustration in the Kids app.

**Cost if wrong.** A content correction needs either an app update or a user who
opens the app online. A typo in an Arabic word of worship is a serious defect, and
this makes fixing it slower than it would be with server-rendered content.

**To reverse.** The client already knows how to pull a snapshot; making it the only
path is deleting the asset and the seed-on-first-run branch. But X2 is a product
requirement, so this is a product reversal, not a refactor.

---

## 4. The app is called **Sakinah**

**What I did.** Named it Sakinah (سَكِينَة) — the tranquillity God sends down on
the hearts of the believers (al-Fath 48:4). Used in the PRD, the pubspec, the API
title and the theme.

**Why.** The brief asked for serenity. *Sakinah* is the Qur'an's own word for
exactly the state the UI is meant to induce, it is short, it transliterates without
ambiguity, and it is not already the name of three apps on the store — unlike
*Hisn*, *Dhikr* and *Athkar*.

**Cost if wrong.** A rename touches the pubspec, the bundle identifier, the theme
file and every doc. Cheap now, annoying after TestFlight.

**To reverse.** Now, cheaply. `rg -l Sakinah` finds all of it.

---

## 5. Companions' and Tabi'un's du'as are **marked, not separated out**

**What I did.** X1.3 — F2.6's supplications sit in the same list widget as
prophetic ones, but carry an explicit attribution line ("Said by 'Umar ibn
al-Khattab, may Allah be pleased with him") and a distinct chip. They are not put
behind a warning screen.

**Why.** The distinction that matters religiously is *provenance*, and provenance
is what the citation already carries. A warning interstitial would suggest the
content is doubtful, which is a different claim from "this is not prophetic" —
'Umar's du'a is authentically 'Umar's.

**Cost if wrong.** A user who does not read the attribution line comes away
thinking they have a prophetic supplication. The line is the only thing preventing
that, so its prominence is load-bearing.

**To reverse.** `ui/dhikr/attribution.dart` is the one place it is rendered.

---

## 6. Weak reports are **included with their grading shown**, not excluded

**What I did.** Open question 3 is deferred by taking the source's grading verbatim
and displaying it. Nothing is dropped for being weak, and nothing weak is shown
without saying so.

**Why.** Excluding is a fiqh judgement, and non-goal 3 says this app does not make
those. Some widely-practised adhkar rest on contested chains, and a user who has
said one daily for twenty years is not served by it silently vanishing.

**Cost if wrong.** It puts the judgement on a user who may not have the training to
make it. A scholar reviewing this may well say the app should have taken a position.

**To reverse.** The grading is a column (`gradings.grade`); filtering on it is a
`WHERE` clause and a settings toggle.

---

## 7. Content sources, and what that costs

**What I did.** Three sources, all recorded in `docs/content-sources.md`:

 * **Morning & evening** — the Seen-Arabic *Morning and Evening Adhkar DB*, MIT
   licensed. The best of the three: vowelled Arabic, translation, transliteration,
   repeat count, virtue, and a full hadith citation with grading.
 * **The rest of the book** — hisnmuslim.com's own developer API, which is the
   publisher of *Hisn al-Muslim* serving its own text for app developers. 132
   chapters, 267 supplications. No per-dhikr citation in the feed, which is a
   real gap against X1.1 — see TODO.
 * **Qur'anic supplications** — Tanzil's Uthmani text with an English translation,
   via `risan/quran-json`.

**Why.** Typing 267 vowelled Arabic supplications by hand would introduce errors
into words of worship, which is the worst possible place to introduce them.

**Cost if wrong.** The hisnmuslim.com API has no stated licence — it is offered for
app developers by the book's publisher, which is an implied grant, not a written
one. A commercial release needs this settled. It is TODO item 1.

**To reverse.** `scripts/import_content.py` has one function per source.

---

## 8. A bundled Arabic font, against the family precedent

**What I did.** Bundled **Amiri Quran** (SIL OFL) for Arabic. Al-Qaswa's pubspec
argues explicitly for using system faces and bundling nothing.

**Why.** That argument was made for an app where Arabic is one of four languages
the *story* might be in. Here the Arabic **is** the product — F7.1 — and the
system faces render vowelled Qur'anic orthography with the harakat colliding into
the letters above them at the sizes this app uses. Amiri Quran is designed for
exactly this text. OFL, so redistribution inside a binary is explicitly permitted,
unlike the Gotham situation the Kids app inherited.

**Cost if wrong.** ~400 KB.

**To reverse.** Delete the `fonts:` block; `ArabicText` falls back to the system.

---

## 9. Sync is a **union**; removing a favourite does not propagate

**What I did.** `PUT /sync` merges what a device sends into what the server
holds and never deletes. A favourite removed on one device comes back the next
time another device syncs.

**Why.** On the wire, "removed here" and "added there, not seen here yet" are
the same thing. Telling them apart needs a tombstone per row and a clock;
guessing wrong silently deletes something a user chose to save. Completions are
worse — they are facts about days that happened, and nothing should remove one
except the user asking (which is `DELETE /sync/history`).

**Cost if wrong.** Un-favouriting is not durable across devices, which will look
like a bug to anyone with two.

**To reverse.** A `deleted_at` column on `favourites`, a `since` parameter, and
the client tracking what it has acknowledged. Half a day. TODO item 4, and
`test_sync_is_a_union_and_does_not_delete` asserts the current behaviour so that
changing it is deliberate.

---

## 10. Account deletion goes through a `SECURITY DEFINER` function

**What I did.** Migration 0005 adds `delete_current_account()`, which takes no
arguments and deletes the row bound for the current transaction. The application
role holds no `DELETE` on `users`.

**Why.** A test found that `DELETE /auth/account` failed outright — 0001 grants
SELECT, INSERT and UPDATE on `users` and no DELETE. The obvious fix is to add
the grant, and it is the wrong one: `users` sits outside row-level security
(every row in it is read *before* there is an identity to scope by), so a
blanket DELETE would put every account in the system one handler bug away from
removal. Account deletion is the one genuinely irreversible operation here.

**Cost if wrong.** A function is less obvious than a statement, and someone will
eventually wonder why the route does a `SELECT` to delete something.

**To reverse.** Don't. If a second deletion path is ever needed, add a second
function rather than the grant.

---

## 11. The Companions collection is named for what it actually contains

**What I did.** "Prayers of the Companions" has three chapters — *taught to one
of them*, *prayers he made for them*, *said by one of them* — and only the third
is marked `transmitted`. It holds exactly one supplication.

**Why.** The brief asked for "prayers from Ashaab/Tabieen". What is available in
a vowelled, machine-readable corpus is overwhelmingly *prophetic* supplications
connected to a named companion, not companions' own words. Presenting those
under a heading that implies otherwise would be the exact failure X1.3 exists to
prevent. So the collection is named for the three things it really holds.

The Tabi'un are absent entirely. Their du'as are in the zuhd literature — Ibn
Abi Shaybah, Abu Nu'aym's *Hilyah* — none of it available as a vowelled corpus,
and typing them from memory is what the whole slice-and-verify pipeline exists
to prevent.

**Cost if wrong.** The brief asked for something the app half-delivers, and says
so rather than pretending.

**To reverse.** Find or build the corpus. TODO item 7.

---

## 12. Our English chapter titles replace the source's

**What I did.** `content/curated/chapter_titles.json` overrides the English
title of all 131 imported Hisn chapters. The Arabic titles are untouched.

**Why.** The feed's English has real errors — "Invocation for when it thunder",
"vocation for someone who says", "Invocations for if you are stricken by in your
faith" — and these titles are the app's entire navigation. They are also all
prefixed "Invocation for", which makes a 81-item list unscannable. Ours say the
moment: "When it rains", not "Invocation for when it rains".

**Cost if wrong.** They are a translation choice we made and did not source. A
reader comparing against the printed book will find them worded differently.

**To reverse.** Delete the file; the builder falls back to the feed's titles.

---

## 13. Hisn's `((...))` quotation markers are stripped

**What I did.** The doubled parentheses the book uses to separate transmitted
words from the compiler's own instructions are removed for display. Everything
else — every harakah, every inline instruction, every ellipsis — is untouched.

**Why.** They are punctuation belonging to a printed page and they read as an
error on a phone. F1.6 is about vowels and normalisation, not about a printer's
quotation convention.

**Cost if wrong.** The boundary between the transmitted words and the
instructions around them is now less visible than the book makes it — e.g.
"say this three times, raising the voice on the third" now runs on from the
supplication with nothing marking the join.

**To reverse.** `clean_hisn_arabic` in `build_content.py`. A better fix would be
to *split* on the markers into a text field and an instruction field, which is
the thing worth doing if this bothers anyone.
