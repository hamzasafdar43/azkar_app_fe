# Sakinah — a pocket book of the Muslim

> *"He it is Who sent down tranquillity (as-sakīnah) into the hearts of the believers."*
> — al-Fath 48:4

## 1 Overview

An adhkar and du'a companion: the transmitted supplications of the Prophet ﷺ, the
prophets before him, his companions and those who followed them — arranged so that
a person can find the right words at the right moment and say them.

The reference product is **Hisn al-Muslim** (*Fortress of the Muslim*) — the pocket
book that sits in a coat pocket and falls open at a bookmark. Everything here is in
service of that: a book, not a feed.

The three things it must do better than the paper book:

* **Count for you.** A dhikr said 33 or 100 times is the ordinary case, and losing
  count is the ordinary failure. F4.
* **Know what time it is.** Morning adhkar at 6am and evening adhkar at 6pm should
  not both be four taps away. F3.
* **Show the Arabic properly.** Large, vowelled, in a face designed for it, at a
  size the reader chooses. F7.

What it must not do is become an app. No feed, no notifications begging for
attention, no streak that breaks. See X4.

## 2 Domain primer

For anyone reading this who does not have the vocabulary.

**Dhikr** (pl. *adhkar*) — remembrance of God: a short formula repeated a set number
of times. *SubhanAllah* thirty-three times after a prayer is a dhikr.

**Du'a** — a supplication: asking. Usually longer, usually not counted.

The app does not draw a hard line between them, because the sources do not: Hisn
al-Muslim mixes both under one chapter heading, and a user looking for "what do I
say when it rains" does not care which category the answer falls into. One content
type, `dhikr`, with an optional repeat count. See §5 F2.

**Ma'thur** (مأثور) — "transmitted". A supplication with a chain back to the Prophet ﷺ
or to the Qur'an, as against one composed later. **Everything in this app is
ma'thur, and everything carries its source.** This is the whole basis of trust in
the category and is not negotiable — see X1.

**Adhkar as-sabah wa-l-masa'** — the morning and evening remembrances, said after
Fajr and after 'Asr. The most-used chapter in the book and the app's front door.

**Qunut** — a supplication said standing in prayer, after rising from ruku'. In the
Witr prayer (prayed after 'Isha, the last prayer of the night) it is the ordinary
practice; *Qunut an-nazilah* is the one said in the obligatory prayers at times of
calamity.

**Sahabah** — the companions who saw the Prophet ﷺ. **Tabi'un** — the generation
after them, who saw the companions but not him.

**Tashkeel / harakat** — the vowel marks on Arabic script. Optional in ordinary
Arabic, essential here: a person reciting words of worship must be able to read
them exactly. Every Arabic string in this app is fully vowelled.

## 3 Users

**U1 — the person who wants to start.** Knows the morning adhkar exist, has never
kept them up. Needs one screen, in order, with a counter, that ends. Not a library.

**U2 — the person who already keeps them.** Knows the words, often by heart. Uses
the app as a *counter and a running order*, and is annoyed by anything between
them and the Arabic. Reads Arabic; may never look at the translation.

**U3 — the child, or the parent sitting with one.** Cannot read Arabic script yet,
or reads it slowly. Needs transliteration, needs the translation, needs the screen
to be uncluttered enough that a seven-year-old can follow where they are.

**U4 — the person in a hard moment.** Bereaved, frightened, in debt, ill, or sitting
with someone who is dying. Opens the app to find the words for exactly this. Search
and the "when you need it" collections exist for U4, and **nothing shown to U4 may
be cheerful**. See X4.

A single design serves U1 and U3 well and U2 adequately; U2's needs are met by
letting them turn things off (F7.4).

## 4 Goals and non-goals

**Goals**

1. Every supplication carries its Arabic, its translation, its transliteration and
   its source, and the source is one tap away at all times.
2. The app works entirely offline, on an aeroplane, in a basement, forever. X2.
3. A first-time user says the morning adhkar within sixty seconds of opening it.
4. Nothing in it is embarrassing to hand to a child or to an elderly relative.

**Non-goals**

1. **Not a prayer-times app.** Qibla, athan, prayer times — all of it is a different
   product with a different sensor and permission story, and half the phones on
   earth already have one. F3 uses the *clock*, and asks for no location.
2. **Not a Qur'an app.** Qur'anic supplications are here as supplications. There is
   no mushaf, no recitation-along, no tafsir.
3. **Not a fiqh authority.** Where scholars differ on whether something is
   established, the app says so and cites both, rather than picking. X1.4.
4. **No social layer.** No sharing counts, no friends, no groups.

## 5 Feature areas

### F1 — Content model

* **F1.1** A **dhikr** is the atom: Arabic text, translation, transliteration,
  repeat count, source citation, and an optional note on its virtue (*fadl*).
* **F1.2** Dhikrs are ordered inside a **chapter** (*bab*): "What to say upon
  waking", "Invocations during ruku'". A chapter is the unit a user reads through.
* **F1.3** Chapters belong to a **collection** — the seven top-level doors of §5 F2.
  A chapter belongs to exactly one collection; a *dhikr* may appear in several
  chapters, since the same words serve several moments.
* **F1.4** Every dhikr has a stable **slug**, assigned once and never reused, so a
  bookmark, a share link and a completion record survive a content re-import.
* **F1.5** Content is versioned as a whole (`content_version`, an integer). The
  client compares its bundled version against the server's and pulls a new snapshot
  when the server is ahead. There is no per-row sync.
* **F1.6** Arabic is stored **fully vowelled**, exactly as the source has it, and is
  never normalised, stripped or "cleaned" on the way in or out.

### F2 — The seven collections

The top-level taxonomy. Each is a door on the home screen.

* **F2.1 Morning & Evening** — the two sittings. The app's front door and the one
  screen most users will ever open. Drives F3.
* **F2.2 Through the Day** — waking, dressing, leaving home, the mosque, eating,
  travelling, sleeping. The bulk of Hisn al-Muslim.
* **F2.3 In the Prayer** — everything said inside salah: the opening supplications,
  ruku', rising from ruku', sujud, **sitting between the two prostrations**,
  tashahhud, the supplications before the salam, what is said after it, and
  **qunut in the Witr**. This collection exists because the user's own words for it
  were "to enhance salah" — a person who prays already, wanting the parts they were
  never taught.
* **F2.4 Prayers of the Prophets** — the supplications of Adam, Nuh, Ibrahim, Yusuf,
  Musa, Ayyub, Yunus, Sulayman, Zakariyya, 'Isa and others, in the Qur'an's own
  words. Each carries its surah and ayah, and the story it sits inside in one line.
* **F2.5 Prayers from the Seerah** — supplications tied to a moment in the Prophet's
  ﷺ life: Ta'if, Badr, the hijrah, the death of his son. The one line of context is
  not decoration here; it is what makes the words land.
* **F2.6 Prayers of the Companions and Those Who Followed** — du'as of Abu Bakr,
  'Umar, 'Ali, Ibn Mas'ud, 'A'ishah and of the Tabi'un. **Marked distinctly** as not
  being from the Prophet ﷺ (X1.3).
* **F2.7 When You Need It** — grief, fear, debt, illness, anger, the evil eye, a
  death, a decision (istikharah). The chapter list a person in trouble scans. U4.

### F3 — Time of day

* **F3.1** The home screen leads with **the sitting that is due now**: morning from
  Fajr until Dhuhr, evening from 'Asr until Maghrib, and nothing at other times.
* **F3.2** Boundaries come from the **clock**, not from prayer times, and are
  approximated by fixed local hours (see the decision log). No location permission
  is ever requested. Non-goal 1.
* **F3.3** A user may open either sitting at any time. F3.1 changes what is
  *offered*, never what is *reachable*.
* **F3.4** The device's timezone is read from the OS and never asked for.

### F4 — Counting

* **F4.1** A dhikr with a repeat count shows a **counter**: the whole card is the
  tap target, and one tap is one repetition.
* **F4.2** Reaching the count advances to the next dhikr in the chapter — after a
  brief pause, so the last repetition is not swallowed by a transition.
* **F4.3** The count is **never lost**: it survives backgrounding, a phone call, a
  crash and a force-quit, because a dhikr half said is a dhikr that must be
  finished, not restarted.
* **F4.4** Counting **down** to zero, not up. What is left to say is the useful
  number; what has been said is not.
* **F4.5** One haptic tick per tap, a distinct one on completion. Silent by default
  in the sense that nothing makes a sound — this is used in mosques.
* **F4.6** A counter can be reset, and a chapter can be started over.
* **F4.7** A **free counter** (*tasbih*), not attached to any dhikr, for a person
  counting something the app does not know about.

### F5 — Progress, honestly

* **F5.1** A sitting is **complete** when every dhikr in it has been counted out.
  Recorded per day, per sitting.
* **F5.2** The record shows **days present**, never consecutive days. X4.
* **F5.3** A missed day is stated plainly and never dramatised, never coloured red,
  and never compared to anyone.
* **F5.4** History is the user's and can be deleted at any time, in one action.

### F6 — Finding

* **F6.1** Search across Arabic, translation and transliteration, offline.
* **F6.2** Arabic search is **diacritic-insensitive**: a user types `اللهم` and
  matches `اللَّهُمَّ`. This is a search-index concern only; F1.6 still holds for
  what is stored and shown.
* **F6.3** Transliteration search is insensitive to the diacritics on the
  transliteration too, so `subhanallah` finds `subḥānallāh`.
* **F6.4** Favourites: a flat, user-ordered list. No folders.

### F7 — Reading

* **F7.1** Arabic renders in a bundled Uthmani-style face at a size the user sets,
  independent of the translation's size.
* **F7.2** Translation and transliteration can each be hidden. A user who reads
  Arabic gets a page with only Arabic on it. U2.
* **F7.3** The source citation is present on every dhikr, collapsed by default,
  one tap from open. Never absent, never behind a menu. X1.1.
* **F7.4** Every reading preference persists and applies everywhere.
* **F7.5** Full right-to-left support for the Arabic, regardless of the app's
  interface language.

### F8 — Sound

* **F8.1** Recorded recitation per dhikr where a recording exists.
* **F8.2** Audio is **opt-in and never autoplays**. The app opens silent.
* **F8.3** Audio is streamed, not bundled, and its absence is never an error — a
  dhikr with no recording simply has no play button. X2 still holds without it.

### F9 — Accounts

* **F9.1** The app is **fully usable signed out**, forever, with no prompt to sign
  in and no feature fenced behind an account. Everything F4–F7 does works locally.
* **F9.2** Signing in exists for exactly one reason: carrying favourites and
  completion history to a second device.
* **F9.3** Magic link by email. No password, no social login, no phone number.
* **F9.4** Deleting the account removes everything owned by it, by cascade.

### F10 — Settings

* **F10.1** Interface language: English and Arabic at launch; Urdu deferred.
* **F10.2** The F7 reading preferences.
* **F10.3** Haptics on/off.
* **F10.4** Sources and licences — what the content is, where it came from, and
  under what terms. X1.5.

## 6 Cross-cutting requirements

### X1 — Authenticity

The requirement the product exists to satisfy. A supplication that is not
transmitted is worse than useless in this category.

* **X1.1** Every dhikr carries a source. There is no path through the app that
  displays one without its citation being available on the same screen.
* **X1.2** A dhikr with a **grading** (sahih, hasan, da'if) carries it, and the
  grader's name. A weak report is either excluded or shown *as weak*, never quietly
  included.
* **X1.3** Anything not from the Prophet ﷺ — a companion's du'a, a tabi'i's — is
  visually and textually distinct. A user must never come away believing they have
  been given a prophetic supplication when they have not. F2.6.
* **X1.4** Where the scholarship differs, the app reports the difference rather than
  resolving it.
* **X1.5** The provenance of every content source, and its licence, is stated in the
  app and in `docs/content-sources.md`.

### X2 — Offline

* **X2.1** Every word of content ships **inside the app binary**. First launch on a
  plane, with no account, shows the complete book.
* **X2.2** The network is only ever used for: a content update (F1.5), sign-in
  (F9.3), sync (F9.2) and audio (F8.3). Losing all four leaves a working app.
* **X2.3** No request is made at launch. Nothing blocks the first screen.

### X3 — Privacy

* **X3.1** No analytics, no third-party SDKs, no advertising identifier, no crash
  reporter that ships content.
* **X3.2** No location permission, ever. Non-goal 1 / F3.2.
* **X3.3** Signed out, nothing leaves the device.
* **X3.4** Email is the only personal datum stored, and only for signed-in users.

### X4 — Nothing celebratory

Inherited deliberately from the Hifz app, and it matters more here.

No points, badges, levels, leaderboards, confetti, streak flames, or "you're on
fire". Days present, not consecutive days. A missed morning is stated, never
dramatised. There is no comparison against other users because there are no other
users visible.

The specific reason: this is worship. A person who says the evening adhkar because
a counter would otherwise reset has been sold something other than what the app
claims to give them. And U4 — bereaved, frightened — must never be met by a
cheerful animation.

The **one** celebratory-adjacent thing permitted: a quiet, unhurried completion
state at the end of a sitting. It says the sitting is done. It does not congratulate.

### X5 — Accessibility

* **X5.1** WCAG AA contrast in both light and dark.
* **X5.2** Everything respects the system text size, including the Arabic — which
  scales from the user's F7.1 setting *and* the system's.
* **X5.3** Minimum 48pt tap targets. F4.1's counter is deliberately the whole card.
* **X5.4** Screen-reader labels on every control; the Arabic is marked with its
  language so the reader does not attempt it in English.
* **X5.5** The counter is usable one-handed without looking — it is used with eyes
  closed.

### X6 — Data

* **X6.1** Content is public and unauthenticated. It is a book.
* **X6.2** Everything personal is row-level-security scoped in the database, so a
  query that forgets its WHERE clause returns nothing rather than someone else's.
* **X6.3** Content ids are stable slugs (F1.4); personal rows key off them.

## 7 Open questions

1. **The morning/evening boundary.** Fixed clock hours are wrong at high latitudes
   in summer and wrong for anyone whose Fajr is not near dawn. Prayer times would
   be right and would cost a location permission and a calculation-method setting.
   Is that trade worth revisiting? See decision log.
2. **Which transliteration scheme.** Full ALA-LC with macrons and dots is precise
   and unreadable to U3. A simplified scheme is readable and imprecise. Currently
   mixed, because the sources are mixed.
3. **Weak (da'if) reports.** Some widely-said adhkar rest on weak chains. Exclude,
   or include clearly marked? Currently: include the source's own grading verbatim,
   exclude nothing — which defers the question rather than answering it.
4. **Urdu.** The user base is substantially Urdu-reading. Deferred at launch, but
   the content model is language-keyed so it is an import, not a schema change.
5. **Audio.** Streaming from a third-party host (F8.3) means the app has a
   dependency it does not control. Bundling would cost ~80 MB.
6. **The name.** *Sakinah* — the tranquillity God sends down — was chosen for the
   feeling the UI is meant to have. Not confirmed with the user.

## 8 Decision log

Decisions made in building this, kept short. The long form of everything decided
unattended is in `docs/decisions-pending-review.md`.

* Three repos, no monorepo root — matching the Hifz and Al-Qaswa projects.
* FastAPI + psycopg, no ORM. Hand-written SQL, forward-only migrations, RLS.
* Native Flutter client, no state-management package.
* Content ships bundled and is served by the API for updates (F1.5, X2.1). This is
  the one structural departure from the Hifz app, where all content is fetched.
* Accounts are optional (F9.1). Also a departure: Hifz and Al-Qaswa both require one.
