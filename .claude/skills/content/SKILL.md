---
name: content
description: The Sakinah content pipeline — how the book is sourced, built, verified and imported. Load before touching anything under adhkar_api/content/, before adding or correcting a supplication, before changing build_content.py or _slices.py, and before answering questions about where a du'a came from or why the Arabic looks the way it does.
---

# The content pipeline

The book is a **build artefact**, and the build is strict on purpose.

```
content/sources/     vendored third-party data, verbatim, never edited
content/curated/     what we wrote — references, context, our chapter titles
        │  scripts/build_content.py
        ▼
content/snapshot.json  →  the Flutter asset, Postgres, and GET /content/snapshot
```

327 supplications, 151 chapters, 7 collections, ~590 KB.

## The rule that governs everything here

**No word of the Qur'an and no word of a hadith is typed into this repository.**

The curated files name a *reference* — an ayah range, or a book and hadith
number — plus the first and last words of the supplication **written without
harakat**. The builder folds the source text (drops every combining mark, the
Qur'anic annotation signs, and the hamza distinctions), finds the needle in the
folded form, maps the offset back through `index_map`, and slices the **vowelled
original**.

A needle that does not match raises `SystemExit`. It never falls back.

Two bugs this has already caught, both invisible to anyone who does not read
Arabic:

* Slicing the *un-normalised* string while indexing the NFC-normalised one put
  the tail of the previous word in front of a du'a (`َاۚ رَبَّنَا ٱفۡتَحۡ`).
* The end offset landed on the last *letter* of the needle, and the fold that
  found the needle had dropped the harakah that follows it — so every sliced
  supplication ended one vowel short. `الدِّين` for `الدِّينِ`.

If you change `slice_between`, re-read the built Arabic of at least
`dua-shuayb-iftah-baynana`, `dua-musa-zalamtu-nafsi` and `dua-abu-bakr-fi-salati`.

## The four sources

Full provenance and licence in `docs/content-sources.md`. In brief:

| Source | Covers | Licence |
| --- | --- | --- |
| Seen Arabic adhkar DB | morning & evening (50) | **MIT** — the only written grant |
| hisnmuslim.com feed | the other 131 chapters (267) | none stated — TODO 1 |
| Tanzil, via `risan/quran-json` | Prophets (36) | free non-commercial, verbatim |
| `AhmedBaset/hadith-json` | Seerah + Companions (14) | none stated — TODO 1 |

`load_hisn` **skips chapter 27** (morning and evening) because the Seen Arabic
source covers the same ground with transliteration, virtue and a graded
citation, and the feed has none of those.

## Adding a supplication

**From the Qur'an** — add to `content/curated/prophets.json` with an ayah range,
then run the extractor snippet in `scripts/build_content.py`'s history or add
the range to `content/sources/quran_extract.json` by hand from the full Qur'an
JSON. Add slice markers to `scripts/_slices.py` if the range carries narrative
frame ("So he called upon his Lord: …", "And say: …"), which most do.

**From a hadith** — find it first. The books are cached under
`content/.cache/`; a fold-insensitive search over them is how every one of the
current fourteen was located. Then add to `seerah.json` or `companions.json`
with `{"book": ..., "hadith": <idInBook>}` and `from`/`to` needles, and run:

```bash
.venv/bin/python scripts/extract_hadith.py
```

That downloads what it needs and rewrites `content/sources/hadith_extract.json`,
which is the committed artefact. Then rebuild.

**The English for a hadith is written by hand** in the curated file, unlike
everything else — a hadith's translation is one paragraph with the du'a embedded
and no reliable seam. Write it against the source dataset's own English.

**Every entry needs a `reference`.** The builder refuses without one (X1.1).

## Attribution — the thing that must not be got wrong

`attributionKind` is one of three, and it is explicit in the curated file rather
than inferred from the collection:

* `quran` — from the Qur'an. Rendered in the Amiri Quran face.
* `prophetic` — transmitted from the Prophet ﷺ. The default.
* `transmitted` — **said by someone other than the Prophet ﷺ.** Renders a
  different chip, with the speaker named, because X1.3 says a user must never
  come away believing they were given a prophetic supplication when they were
  not.

A du'a the Prophet ﷺ *taught to* a companion, or *made for* one, is `prophetic`.
Only a companion's own words are `transmitted`. There is currently exactly one:
`dua-umar-istisqa`. A test asserts it.

## Rebuilding

```bash
.venv/bin/python scripts/build_content.py
cp content/snapshot.json ../adhkar_app_flutter/assets/content/
.venv/bin/python scripts/import_content.py
```

**Bump `CONTENT_VERSION` in `build_content.py`** when the change should reach
existing installs, or no client will notice (F1.5).

The builder also checks: slugs are unique and well-formed, every chapter belongs
to a real collection, no dhikr is orphaned from every chapter, and the Arabic is
non-empty. It builds the search index (`fold` for Arabic, `fold_latin` for
transliteration) so that every consumer searches identically — the client's
`foldQuery` in `state/app_state.dart` is the query half and must agree.

## Things the sources get wrong, already handled

* The hisnmuslim feed is not well-formed JSON — BOM, unescaped newlines, and one
  chapter missing a closing quote on its title key. `load_json` tolerates it;
  the vendored files stay exactly as served.
* Its `LANGUAGE_ARABIC_TRANSLATED_TEXT` field is the **transliteration**, not a
  translation. For two entries the English was filed there and the translation
  left empty; the builder detects and moves it.
* Its transliteration writes ع as a doubled capital A (`AAabduk`). Rewritten to
  an apostrophe. PRD open question 2 is the real answer.
* Its English chapter titles have spelling and grammar errors. Overridden in
  `content/curated/chapter_titles.json` — the app's whole navigation.
* Hisn wraps transmitted words in `((...))`. Those are the printed page's
  quotation marks, not text, and are stripped.
* Two ayat begin with the rub'-al-hizb ornament ۞, which is a page mark and not
  a letter. Stripped.
