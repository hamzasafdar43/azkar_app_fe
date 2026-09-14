"""Match every supplication in the app to a sunnah.com/hisn:N URL.

Reads the app snapshot and the local hisnmuslim.com feed (whose per-entry
`ID` is the same global hadith number Sunnah.com uses for the Hisn book),
and writes `docs/dua-hisn-urls.md` — one row per (chapter × dhikr), same
order as `dua-sources.md`, with either `https://sunnah.com/hisn:<ID>` or
`NOT FOUND (<old reference>)`.

Caveats printed at the top of the output:
  * Letter suffixes (a, b, c) that sunnah.com uses to split one printed
    hadith across sub-parts are NOT resolved here — the local feed carries
    a single ID per entry. `hisn:75a` (Al-Qahtani's opening line) is one
    such gap: it appears on sunnah.com but not in the local feed.
  * Supplications that do not come from Hisn al-Muslim (Prophets from the
    Qur'an, Seerah/Companions from other hadith books) are legitimately
    NOT FOUND — a hisn: URL does not exist for them.

Usage:  python3 docs/dua_references/build_hisn_urls.py
"""

from __future__ import annotations
import json, pathlib, re, sys, unicodedata
from collections import defaultdict
from difflib import SequenceMatcher

# Reuse the surah-name → number map from the sibling script.
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from build_dua_sources import SURAH  # noqa: E402


# "Surat Al-Baqarah 2:255", "Surah Al-Baqarah, Verse 255", or bare "2:255-257".
_QURAN_SURAH = re.compile(
    r"Sur(?:at|ah)?\s+([A-Za-z' \-]+?)\s+(\d+):(\d+)(?:\s*-\s*(\d+))?"
)
_QURAN_NAMED = re.compile(
    r"Sur(?:at|ah)?\s+([A-Za-z' \-]+?)\s*,?\s*(?:Verse|Ayah)s?\s+(\d+)(?:\s*-\s*(\d+))?",
    re.I,
)
_QURAN_NUM = re.compile(r"\b(\d+):(\d+)(?:\s*-\s*(\d+))?\b")


def quran_url(ref: str):
    """Return (url, label) for a Qur'anic reference, or (None, None)."""
    if not ref:
        return None, None
    m = _QURAN_SURAH.search(ref)
    if m:
        key = m.group(1).lower().strip().rstrip(",.")
        if key in SURAH:
            s = SURAH[key]
            a1 = int(m.group(3))
            a2 = int(m.group(4)) if m.group(4) else None
            return _fmt(s, a1, a2)
    m = _QURAN_NAMED.search(ref)
    if m:
        key = m.group(1).lower().strip().rstrip(",.")
        if key in SURAH:
            s = SURAH[key]
            a1 = int(m.group(2))
            a2 = int(m.group(3)) if m.group(3) else None
            return _fmt(s, a1, a2)
    m = _QURAN_NUM.search(ref)
    if m:
        s = int(m.group(1))
        a1 = int(m.group(2))
        a2 = int(m.group(3)) if m.group(3) else None
        if 1 <= s <= 114:
            return _fmt(s, a1, a2)
    return None, None


def _fmt(s: int, a1: int, a2: int | None):
    if a2 and a2 > a1:
        return (f"https://quran.com/{s}/{a1}-{a2}", f"Qur'an {s}:{a1}-{a2}")
    return (f"https://quran.com/{s}/{a1}", f"Qur'an {s}:{a1}")


# Mirror the builder's fold — no harakat, no hamza distinctions.
_SIGNS = "".join(chr(c) for c in range(0x06D6, 0x06EE)) + "ـ"
_FOLD = str.maketrans({
    "أ": "ا", "إ": "ا", "آ": "ا", "ٱ": "ا",
    "ى": "ي", "ئ": "ي", "ؤ": "و", "ة": "ه",
})


def fold(text: str) -> str:
    decomposed = unicodedata.normalize("NFD", text or "")
    bare = "".join(
        c for c in decomposed
        if not unicodedata.combining(c) and c not in _SIGNS
    )
    return unicodedata.normalize("NFC", bare).translate(_FOLD)


_PUNCT = "،.,:;!؟?()\"'`*[]{}"


def clean(text: str) -> str:
    """Strip the hisnmuslim feed's decorative wrappers so folded strings
    compare cleanly to the snapshot's slice."""
    text = text or ""
    text = text.replace("((", "").replace("))", "")
    text = text.replace("﴿", "").replace("﴾", "")
    # The Prophet's salutation glyph vs the spelled-out phrase — the feed
    # writes one and the app the other. Fold both to a canonical form.
    text = text.replace("ﷺ", "صلى الله عليه وسلم")
    # The feed appends evening/short-form variants in square brackets;
    # drop them before matching against a single morning dhikr.
    text = re.sub(r"\[[^\]]*\]", " ", text)
    # Collapse whitespace and strip all punctuation — the same phrase
    # cited in two places often disagrees on commas alone.
    text = re.sub(r"\s+", " ", text)
    text = "".join(c for c in text if c not in _PUNCT)
    text = re.sub(r"\s+", " ", text).strip()
    return text


def load_feed(hisn_dir: pathlib.Path):
    """Return [(id, chapter_num, folded_text_clean, full_ar)] for every
    entry in every chapter."""
    out = []
    for f in sorted(hisn_dir.glob("*.json"), key=lambda p: int(p.stem)):
        try:
            data = json.loads(f.read_text(encoding="utf-8-sig"))
        except Exception:
            continue
        if not isinstance(data, dict):
            continue
        for _title, rows in data.items():
            if not isinstance(rows, list):
                continue
            for r in rows:
                if not isinstance(r, dict):
                    continue
                ar = r.get("ARABIC_TEXT") or ""
                folded = fold(clean(ar))
                if folded:
                    out.append((r.get("ID"), int(f.stem), folded, ar))
    return out


def best_match(dhikr_ar: str, feed):
    """Return (ID, chapter_num) for the best hisn feed match, or None."""
    needle = fold(clean(dhikr_ar))
    if not needle:
        return None

    # 1) exact fold-equality
    for hid, ch, hay, _ in feed:
        if hay == needle:
            return (hid, ch)

    # 2) dhikr wholly contained in one feed entry (Qur'anic ayat inside
    # a longer entry; short dhikr like a tasbih fragment inside a fuller
    # narration). Prefer the shortest such match — a substring match
    # against a very long feed entry is weaker than one against a
    # tightly-scoped one.
    if len(needle) >= 15:
        contained = [(hid, ch, len(hay)) for hid, ch, hay, _ in feed
                     if needle in hay]
        if contained:
            contained.sort(key=lambda t: t[2])
            return (contained[0][0], contained[0][1])

    # 3) a feed entry wholly contained in the dhikr — dhikr adds framing
    # (isti'adha before Ayat al-Kursi, or the compiler's opening line).
    if len(needle) >= 15:
        contains = [(hid, ch, len(hay)) for hid, ch, hay, _ in feed
                    if len(hay) >= 20 and hay in needle]
        if contains:
            contains.sort(key=lambda t: -t[2])
            return (contains[0][0], contains[0][1])

    # 4) fuzzy match — handles mushaf vs full-writing orthography
    # (النفثت / النفاثات) that the fold does not equalise. Two modes:
    #   a) same-length fuzzy on entries within ±30% length
    #   b) windowed fuzzy on longer entries (short Qur'anic dhikr as a
    #      near-substring of a compiled group like the three Quls)
    best_ratio = 0.0
    best_hit = None
    for hid, ch, hay, _ in feed:
        if len(hay) < 15:
            continue
        ratio_len = min(len(needle), len(hay)) / max(len(needle), len(hay))
        if ratio_len >= 0.7:
            r = SequenceMatcher(None, needle, hay, autojunk=False).ratio()
            if r > best_ratio:
                best_ratio = r
                best_hit = (hid, ch)
        elif len(needle) >= 30 and len(hay) > len(needle):
            # Slide a window over hay, sized to needle. Anchor on the
            # needle's first 8 folded chars to keep the search cheap.
            anchor = needle[:8]
            start = 0
            while True:
                pos = hay.find(anchor, start)
                if pos < 0:
                    break
                window = hay[pos: pos + int(len(needle) * 1.15)]
                r = SequenceMatcher(None, needle, window,
                                    autojunk=False).ratio()
                if r > best_ratio:
                    best_ratio = r
                    best_hit = (hid, ch)
                start = pos + 1
    if best_ratio >= 0.88 and best_hit is not None:
        return best_hit

    # 5) long common prefix — same du'a with a slightly different tail
    # (a variant ending, or one source truncates where the other quotes
    # more). Take the entry whose first N characters equal the dhikr's,
    # for N = min(len(needle), len(hay)) * 0.9 and at least 60 chars.
    if len(needle) >= 60:
        best = None
        for hid, ch, hay, _ in feed:
            if len(hay) < 60:
                continue
            common = 0
            for a, b in zip(needle, hay):
                if a != b:
                    break
                common += 1
            threshold = int(0.9 * min(len(needle), len(hay)))
            if common >= threshold and common >= 60:
                score = common - abs(len(needle) - len(hay))
                if best is None or score > best[0]:
                    best = (score, hid, ch)
        if best:
            return (best[1], best[2])

    return None


def snip(s: str, n: int = 60) -> str:
    s = (s or "").replace("\n", " ").replace("|", "\\|").strip()
    return s if len(s) <= n else s[: n - 1].rstrip() + "…"


def build(snapshot_path: pathlib.Path, hisn_ar_dir: pathlib.Path,
          out_path: pathlib.Path):
    snap = json.loads(snapshot_path.read_text())
    feed = load_feed(hisn_ar_dir)

    dhikrs_by_slug = {d["slug"]: d for d in snap["dhikrs"]}
    cd_by_chapter: dict[str, list] = defaultdict(list)
    for cd in snap["chapterDhikrs"]:
        cd_by_chapter[cd["chapter"]].append(cd)
    chapters_by_collection: dict[str, list] = defaultdict(list)
    for ch in snap["chapters"]:
        chapters_by_collection[ch["collection"]].append(ch)

    out: list[str] = []
    push = out.append

    push("# Adhkar — sunnah.com and quran.com URLs\n\n")
    push("For every supplication in the app:\n\n")
    push("* If it is from the Qur'an (`attributionKind: quran`), the "
         "`https://quran.com/<surah>/<ayah>` URL parsed from the reference "
         "string.\n")
    push("* Otherwise, the `https://sunnah.com/hisn:<N>` URL from an Arabic "
         "match against the local hisnmuslim.com feed.\n")
    push("* Otherwise, `NOT FOUND (<old ref>)`.\n\n")
    push(f"Snapshot: contentVersion `{snap.get('contentVersion')}`. "
         f"Feed: `adhkar_api/content/sources/hisn/ar/` "
         f"({len(feed)} entries across 132 chapters).\n\n")
    push("**Two caveats before you review a NOT FOUND row.**\n\n")
    push("* **Letter suffixes not resolved.** sunnah.com splits some printed "
         "hadiths into `hisn:75a`, `hisn:75b`, `hisn:75c`. The local feed "
         "carries one row per printed ID, so the `a`/`b`/`c` variants can only "
         "be added by a human check. Where a `hisn:<N>` URL is produced below, "
         "the correct final URL may be `hisn:<N>a`.\n")
    push("* **Some supplications do not come from Hisn al-Muslim.** Prophets' "
         "du'as get a `quran.com` URL from their surah/ayah reference; the 14 "
         "Seerah/Companions entries come from other hadith books and have no "
         "`hisn:` URL. A NOT FOUND for those is not a gap.\n")
    push("* **Ambiguous placement.** Some du'as appear in more than one Hisn "
         "chapter — the three Quls sit in `hisn:70` (after prayer) and "
         "`hisn:76` (morning/evening) both. The matcher picks one; either URL "
         "opens the right recitation, but the chapter context on the page "
         "may not match the app's chapter.\n\n")
    push("Regenerate with `python3 docs/dua_references/build_hisn_urls.py`.\n\n---\n\n")

    total = matched_hisn = matched_quran = not_found = 0
    per_collection = defaultdict(lambda: [0, 0])  # [matched, total]

    for coll in snap["collections"]:
        push(f"## {coll['title']['en']}\n\n")
        for ch in sorted(chapters_by_collection[coll["slug"]],
                         key=lambda c: c["order"]):
            entries = sorted(cd_by_chapter[ch["slug"]],
                             key=lambda x: x["order"])
            if not entries:
                continue
            push(f"### {ch['title']['en']}\n\n")
            push("| # | Slug | Arabic (snip) | Reference |\n"
                 "|---:|---|---|---|\n")
            for entry in entries:
                d = dhikrs_by_slug.get(entry["dhikr"])
                if not d:
                    continue
                total += 1
                per_collection[coll["title"]["en"]][1] += 1
                ref_en = (d.get("reference") or {}).get("en") \
                         or (d.get("reference") or {}).get("ar") or ""
                cell = None
                if d.get("attributionKind") == "quran":
                    q_url, q_label = quran_url(ref_en)
                    if q_url:
                        matched_quran += 1
                        per_collection[coll["title"]["en"]][0] += 1
                        cell = f"[{q_label}]({q_url})"
                if cell is None:
                    m = best_match(d.get("arabic", ""), feed)
                    if m:
                        matched_hisn += 1
                        per_collection[coll["title"]["en"]][0] += 1
                        hid, _ = m
                        url = f"https://sunnah.com/hisn:{hid}"
                        cell = f"[hisn:{hid}]({url})"
                    else:
                        not_found += 1
                        cell = f"**NOT FOUND** ({snip(ref_en, 140)})"
                push(f"| {entry['order']} | `{d['slug']}` "
                     f"| <span dir=\"rtl\">{snip(d.get('arabic',''), 60)}</span> "
                     f"| {cell} |\n")
            push("\n")
        push("---\n\n")

    push("## Coverage\n\n")
    push("| Collection | Matched | Total | % |\n|---|---:|---:|---:|\n")
    for name, (mm, tt) in per_collection.items():
        pct = f"{100*mm/tt:.0f}%" if tt else "-"
        push(f"| {name} | {mm} | {tt} | {pct} |\n")
    matched = matched_hisn + matched_quran
    pct_all = f"{100*matched/total:.0f}%" if total else "-"
    push(f"| **All** | **{matched}** | **{total}** | **{pct_all}** |\n\n")
    push(f"Of the {matched} matched: {matched_hisn} to `sunnah.com/hisn:N`, "
         f"{matched_quran} to `quran.com/S/A`.\n")

    out_path.write_text("".join(out))
    return {"rows": total, "hisn": matched_hisn, "quran": matched_quran,
            "not_found": not_found}


if __name__ == "__main__":
    here = pathlib.Path(__file__).resolve().parent  # docs/dua_references
    project_root = here.parent.parent.parent        # AdhkarApp
    api_root = project_root / "adhkar_api"
    stats = build(
        snapshot_path=api_root / "content" / "snapshot.json",
        hisn_ar_dir=api_root / "content" / "sources" / "hisn" / "ar",
        out_path=here / "dua-hisn-urls.md",
    )
    print("dua-hisn-urls.md written · " +
          " · ".join(f"{k}: {v}" for k, v in stats.items()))
