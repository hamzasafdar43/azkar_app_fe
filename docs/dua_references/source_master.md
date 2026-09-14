# How the du'as got into the app

Companion to [`dua-hisn-urls.md`](dua-hisn-urls.md) (per-dhikr
sunnah.com/quran.com URLs) and [`dua-full.md`](dua-full.md) (every field the
app has for every supplication).

For licences and terms of use of each source, see
[`docs/content-sources.md`](../content-sources.md). This file is about the
**process** — how content flows from those sources into the app.

## The core rule

**No word of the Qur'an and no word of a hadith is typed into this repository.**

Every one of the 327 supplications is *sliced* out of a source file the builder
was pointed at. If a slice does not match, the build hard-fails — there is no
fallback. That strictness has already caught two silent bugs (a stray
tail-of-previous-word prepended to one du'a, and every sliced du'a losing its
final vowel because the fold dropped it and the slice landed one letter short).

## The four sources

All four are vendored into `adhkar_api/content/sources/`, verbatim (BOM,
malformed JSON, quirky quoting and all — the builder tolerates the ugliness
rather than editing the files).

| Source | Covers | Count | Licence |
|---|---|---:|---|
| **Seen Arabic adhkar DB** (MIT-licensed community repo) | Morning & evening chapter | 50 | MIT (only written grant) |
| **hisnmuslim.com feed** (the JSON their site itself serves) | The other 131 Hisn al-Muslim chapters | 267 | none stated — TODO 1 |
| **Tanzil**, via `risan/quran-json` | Prophets' du'as from the Qur'an | 36 | free non-commercial, verbatim |
| **`AhmedBaset/hadith-json`** (Bukhari, Muslim, Tirmidhi, Nasa'i, Abu Dawud, Ibn Majah, Malik) | Seerah + Companions du'as | 14 | none stated — TODO 1 |

`load_hisn` **skips Hisn chapter 27** (morning and evening): the Seen Arabic
source covers the same ground with transliteration, virtue, and a graded
citation, none of which the feed carries.

## How a single du'a gets into the app

For every one of the 327 supplications, a curated JSON file names three things
— *no Arabic prose*:

```json
{
  "slug": "dua-musa-zalamtu-nafsi",
  "book": "quran",
  "from": "رب اني ظلمت نفسي",
  "to":   "فغفر له",
  "reference": {"en": "Qur'an 28:16"},
  "attributionKind": "quran"
}
```

The curated files live under `adhkar_api/content/curated/`:

- `chapters.json`, `chapter_titles.json`, `collections.json` — structure
- `morning_evening.json`, `prophets.json`, `seerah.json`, `companions.json` — needles + refs
- Everything else uses the hisnmuslim feed directly

At build time (`adhkar_api/scripts/build_content.py`):

1. Load the source file (Qur'an JSON, hisn chapter, hadith book).
2. **Fold** it — strip every combining mark, Qur'anic annotation sign, tatweel,
   and hamza distinction — so the search is orthography-tolerant.
   `أ / إ / آ / ٱ` all become `ا`, etc.
3. Find `from` and `to` in the folded string. Map the folded offsets back
   through an `index_map` to the **original vowelled** string.
4. Slice out that range and write it to `snapshot.json` as the du'a's `arabic`
   field.

If either needle doesn't match, the build hard-fails. Slice markers for du'as
that carry narrative frame ("So he called upon his Lord: …", "And say: …") live
in `adhkar_api/scripts/_slices.py`.

## Chapters, titles, and English

- **Chapters** and their ordering come from Hisn al-Muslim, plus 3 chapters we
  added: Prophets, Seerah, Companions.
- **English chapter titles** are our own — `chapter_titles.json` overrides the
  feed's titles, which have spelling and grammar errors.
- **English translations for Qur'anic du'as** are sliced from Sahih
  International (via the same `quran-json` repo), by the same fold-and-slice
  mechanism.
- **English translations for hadith du'as** are written by hand in the curated
  file — a hadith's English is one paragraph with the du'a embedded and no
  reliable seam, so slicing doesn't work.
- **References** (the citations that end each du'a in the app) come from those
  same sources: Seen Arabic's field for morning/evening, hisnmuslim's field for
  the rest, and hand-written for the Seerah/Companions batch.

## Attribution

`attributionKind` is explicit in every curated entry, not inferred:

- `quran` — from the Qur'an. Rendered in the Amiri Quran face.
- `prophetic` — transmitted from the Prophet ﷺ. The default.
- `transmitted` — **said by someone other than the Prophet ﷺ.** A different
  chip is rendered and the speaker is named, because PRD X1.3 forbids letting a
  user come away believing they were given a prophetic supplication when they
  were not.

A du'a the Prophet ﷺ *taught to* a companion, or *made for* one, is
`prophetic`. Only a companion's own words are `transmitted`. There is currently
exactly one: `dua-umar-istisqa`. A test asserts it.

## Output

Everything collapses into a single ~590 KB `snapshot.json` that ships three
ways:

- Flutter asset in the client (`adhkar_app_flutter/assets/content/snapshot.json`)
- imported into Postgres by `adhkar_api/scripts/import_content.py`
- served at `GET /content/snapshot` (with an ETag on `contentVersion`)

Bump `CONTENT_VERSION` in `build_content.py` when a change should reach
installed apps.

## Why the references we show sometimes disagree with sunnah.com

Two real reasons, neither of them a bug:

1. **Different print editions cite different volume/page numbers.**
   "Abu Dawud 4/322" vs "2/86" is the same hadith in two editions. sunnah.com
   standardises on the Darussalam numbering; our text was transcribed from a
   Hisn al-Muslim print edition that used a different one.
2. **The same du'a often lives in multiple chapters, from different narrations.**
   The three Quls appear in `hisn:70` (after prayer, narrated by Uqbah → Abu
   Dawud + Nasa'i) *and* `hisn:76` (morning/evening → Abu Dawud + Tirmidhi).
   Same words, different hadith.

Because of (2), the sunnah.com URL match in [`dua-hisn-urls.md`](dua-hisn-urls.md)
picks one chapter; either URL opens the correct recitation, but the chapter
context on sunnah.com may not match the app's chapter. This is called out in
the caveats at the top of that file.

## Adding a supplication

**From the Qur'an** — add to `content/curated/prophets.json` with an ayah
range, then either run the extractor snippet in `scripts/build_content.py`'s
history or add the range to `content/sources/quran_extract.json` by hand from
the full Qur'an JSON. Add slice markers to `scripts/_slices.py` if the range
carries narrative frame.

**From a hadith** — find it first. The books are cached under
`content/.cache/`; a fold-insensitive search over them is how every one of the
current 14 was located. Then add to `seerah.json` or `companions.json` with
`{"book": ..., "hadith": <idInBook>}` and `from`/`to` needles, and run:

```bash
.venv/bin/python scripts/extract_hadith.py
```

That rewrites `content/sources/hadith_extract.json`, which is the committed
artefact. Then rebuild.

Every entry needs a `reference` — the builder refuses without one (PRD X1.1).

## Rebuilding

```bash
.venv/bin/python scripts/build_content.py
cp content/snapshot.json ../adhkar_app_flutter/assets/content/
.venv/bin/python scripts/import_content.py
```

The builder also checks: slugs are unique and well-formed, every chapter
belongs to a real collection, no dhikr is orphaned from every chapter, and the
Arabic is non-empty. It builds the search index (`fold` for Arabic, `fold_latin`
for transliteration) so that every consumer searches identically — the client's
`foldQuery` in `state/app_state.dart` is the query half and must agree.

## Things the sources get wrong, already handled

- The hisnmuslim feed is not well-formed JSON — BOM, unescaped newlines, and
  one chapter missing a closing quote on its title key. `load_json` tolerates
  it; the vendored files stay exactly as served.
- Its `LANGUAGE_ARABIC_TRANSLATED_TEXT` field is the **transliteration**, not
  a translation. For two entries the English was filed there and the
  translation left empty; the builder detects and moves it.
- Its transliteration writes ع as a doubled capital A (`AAabduk`). Rewritten
  to an apostrophe.
- Its English chapter titles have spelling and grammar errors. Overridden in
  `chapter_titles.json`.
- Hisn wraps transmitted words in `((...))`. Those are the printed page's
  quotation marks, not text, and are stripped.
- Two ayat begin with the rub'-al-hizb ornament ۞, which is a page mark and
  not a letter. Stripped.
