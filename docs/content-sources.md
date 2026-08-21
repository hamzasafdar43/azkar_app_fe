# Where the content came from, and under what terms

PRD X1.5 says the provenance and licence of every source is stated in the app
and here. This is the second half of that; the first is the Sources panel at the
bottom of the settings screen.

There are three content sources and one typeface source.

---

## 1. Morning and evening — Seen Arabic

**What:** the 34 supplications of the morning and evening sittings, which become
26 in the morning list and 24 in the evening one (the file marks each as morning
only, evening only, or both).

**Where:** [Seen-Arabic/Morning-And-Evening-Adhkar-DB](https://github.com/Seen-Arabic/Morning-And-Evening-Adhkar-DB),
vendored at `adhkar_api/content/sources/adhkar_{ar,en}.json`.

**Licence:** MIT. Redistribution, including inside a commercial app, is
explicitly permitted. **This is the only content source with a written licence
grant**, which is why it wins for the chapter it covers.

**Why it wins:** it is the richest of the three. Every entry carries fully
vowelled Arabic, an English translation, a transliteration, the repeat count in
words as well as digits, the narrated virtue (*fadl*), and a full hadith
citation including the grader's name. Hisn al-Muslim's own feed covers the same
chapter with no citation and no virtue, so chapter 27 of that feed is
deliberately skipped — see `HISN_COLLECTION` in `scripts/build_content.py`.

---

## 2. The rest of the book — Hisn al-Muslim

**What:** 131 of the 132 chapters of *Hisn al-Muslim* (*Fortress of the
Muslim*), by Sa'id ibn 'Ali ibn Wahf al-Qahtani — 267 supplications, which after
skipping chapter 27 supply "In the Prayer", "Through the Day" and "When You Need
It".

**Where:** `hisnmuslim.com`'s own developer feed — a chapter index at
`/api/{ar,en}/husn_{ar,en}.json` and one file per chapter. Vendored verbatim at
`adhkar_api/content/sources/hisn/`.

**Licence: none stated.** This is the feed the book's own publisher serves for
app developers, which is an *implied* grant and not a written one.

> **This is TODO item 1 and a release blocker.** A free app distributed to a
> handful of people is one thing; a store listing is another. Before release,
> either obtain a written permission, or replace this source. Everything is
> structured so that replacing it is a rewrite of one function
> (`load_hisn` in `scripts/build_content.py`) rather than of the app.

**Known gaps in this source, all of them real:**

* **No per-supplication citation.** The feed gives the chapter and nothing else,
  so these 267 entries cite "Hisn al-Muslim — *chapter title*". That is a true
  statement of where the text came from and a weaker one than every other
  collection manages. TODO item 2.
* **No grading.** X1.2 asks for one where it exists; none is available here.
* **Transliteration is missing for about 40 entries**, and where it exists it
  uses a machine convention — `AAabduk` for عَبْدُك. The builder rewrites the
  doubled capital A as an apostrophe, which is a legibility floor rather than an
  answer; PRD open question 2 is the answer.
* **The English chapter titles have spelling and grammar errors** ("Invocation
  for when it thunder", "vocation for someone who says"). They are the app's
  entire navigation, so they are overridden in
  `adhkar_api/content/curated/chapter_titles.json`. The Arabic titles are the
  source's own and are untouched.
* **Two entries had the English filed under the transliteration key** and the
  translation left empty. Both are instructions rather than supplications; the
  builder detects the case and moves the text.
* **The feed is not well-formed JSON.** It carries a BOM, unescaped newlines
  inside strings, and one chapter is missing the closing quote on its title key.
  The tolerance lives in `load_json`; the vendored files stay exactly as served.

---

## 3. Qur'anic supplications — Tanzil

**What:** the 36 supplications in "Prayers of the Prophets", sliced out of their
ayat.

**Where:** [risan/quran-json](https://github.com/risan/quran-json), whose Arabic
is the Tanzil project's Uthmani text and whose English is the accompanying
translation. Only the ~36 cited ranges are vendored, at
`adhkar_api/content/sources/quran_extract.json`.

**Licence:** the Tanzil project permits free distribution of its text
non-commercially and verbatim, with attribution and without modification. The
repository's own code is MIT.

> A commercial release needs this checked as carefully as item 2. Verbatim is
> satisfied — the app slices whole clauses out of ayat and never alters a
> character — but "non-commercial" is a term someone should read properly before
> a paid listing exists. TODO item 1.

**Note on slicing.** No word of the Qur'an is typed into this repository.
`content/curated/prophets.json` names an ayah range; `scripts/_slices.py` names
the first and last words of the supplication *without harakat*; the builder
folds the ayah to find them and slices the vowelled original at the offset it
found. A marker that does not match fails the build. This is what stops "And
say:" being glued to the front of a du'a, and what stops a hand-typed marker
introducing a misvowelled word.

---

## 4. Seerah and Companions — the nine books

**What:** the 14 supplications in "Prayers from the Seerah" and "Prayers of the
Companions".

**Where:** [AhmedBaset/hadith-json](https://github.com/AhmedBaset/hadith-json) —
50,884 narrations from 17 books, fully vowelled. Only the 14 cited narrations
are vendored, at `adhkar_api/content/sources/hadith_extract.json`; the books
themselves are ~55 MB and are downloaded on demand into a gitignored cache by
`scripts/extract_hadith.py`.

**Licence:** the repository states no licence. Same status as item 2 — though
the underlying texts are ninth-century and long out of copyright, so what is at
issue is the compilation, not the words.

**The English is written by hand** in the curated files, unlike everything else
here. A hadith's translation is one flowing paragraph with the supplication
embedded in it and no reliable seam to cut on; the Arabic has the printed
edition's quotation convention and the English does not. Each was written
against the source dataset's own English.

---

## 5. The typefaces — Amiri and Amiri Quran

**Where:** the [Amiri Project](https://github.com/aliftype/amiri), via Google
Fonts. Bundled at `adhkar_app_flutter/assets/fonts/`.

**Licence:** SIL Open Font Licence 1.1, which permits redistribution inside an
application binary explicitly. The licence text ships at
`assets/fonts/OFL.txt` and both faces are named in the app's Sources panel.

This is the only content decision that goes *against* the family precedent — the
Al-Qaswa pubspec argues at length for using system faces and bundling nothing.
That argument was made for an app where Arabic is one of four languages a
*story* might be in. Here the Arabic is the product, and the system faces render
vowelled Qur'anic orthography with the harakat colliding into the letters above
them at the sizes this app uses. For words of worship that is not a cosmetic
problem. ~980 KB.

---

## What a licence audit would need to conclude

Before this app is listed anywhere, someone has to answer three questions in
writing:

1. May we redistribute the *Hisn al-Muslim* text as served by hisnmuslim.com?
2. Does Tanzil's non-commercial term permit whatever business model this ends up
   with — including free-with-no-ads, which is the current intent?
3. Does the hadith-json compilation carry any claim, and if so whose?

Items 1 and 3 have a cheap answer if the answer is no: both are compilations of
public-domain texts, and both could be rebuilt from a source that does grant
permission. Item 2's answer is likelier to be "yes, if the app stays free".
