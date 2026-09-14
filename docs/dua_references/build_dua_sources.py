"""Regenerate `dua-sources.md` from the app's content snapshot.

Reads `adhkar_api/content/snapshot.json` (contentVersion 1) and writes
`docs/dua-sources.md` — one table per collection × chapter, with a
sunnah.com / quran.com URL where the citation string is specific enough
to form one automatically.

Usage:
    python3 docs/dua_references/build_dua_sources.py

The snapshot lives in a sibling repo:
    ../adhkar_api/content/snapshot.json

Two easy wins when fixing a row:
  1. A book pattern is missing — extend BOOKS with the regex + sunnah.com slug.
  2. A pattern took a volume/page instead of the hadith number — the parser
     prefers "No. NNNN"; add that shape to the raw source data or tighten the
     book's regex.
"""

from __future__ import annotations
import json, re, pathlib
from collections import defaultdict


# ---------- surah name → number (for quran.com URLs) ----------
SURAH = {
    "al-fatihah": 1, "al-baqarah": 2, "al-baqara": 2, "ali imran": 3,
    "aali imran": 3, "al-i imran": 3, "an-nisa": 4, "an-nisa'": 4,
    "al-ma'idah": 5, "al-maidah": 5, "al-an'am": 6, "al-anam": 6,
    "al-a'raf": 7, "al-araf": 7, "al-anfal": 8, "at-tawbah": 9,
    "yunus": 10, "hud": 11, "yusuf": 12, "ar-ra'd": 13, "ibrahim": 14,
    "al-hijr": 15, "an-nahl": 16, "al-isra": 17, "al-isra'": 17,
    "al-kahf": 18, "maryam": 19, "ta-ha": 20, "al-anbiya": 21,
    "al-anbiya'": 21, "al-hajj": 22, "al-mu'minun": 23, "al-muminun": 23,
    "an-nur": 24, "al-furqan": 25, "ash-shu'ara": 26, "ash-shuara": 26,
    "an-naml": 27, "al-qasas": 28, "al-ankabut": 29, "ar-rum": 30,
    "luqman": 31, "as-sajdah": 32, "al-ahzab": 33, "saba": 34, "saba'": 34,
    "fatir": 35, "ya-sin": 36, "yaseen": 36, "yasin": 36, "as-saffat": 37,
    "sad": 38, "az-zumar": 39, "ghafir": 40, "fussilat": 41, "ash-shura": 42,
    "az-zukhruf": 43, "ad-dukhan": 44, "al-jathiyah": 45, "al-ahqaf": 46,
    "muhammad": 47, "al-fath": 48, "al-hujurat": 49, "qaf": 50,
    "adh-dhariyat": 51, "at-tur": 52, "an-najm": 53, "al-qamar": 54,
    "ar-rahman": 55, "al-waqi'ah": 56, "al-hadid": 57, "al-mujadilah": 58,
    "al-hashr": 59, "al-mumtahanah": 60, "as-saff": 61, "al-jumu'ah": 62,
    "al-munafiqun": 63, "at-taghabun": 64, "at-talaq": 65, "at-tahrim": 66,
    "al-mulk": 67, "al-qalam": 68, "al-haqqah": 69, "al-ma'arij": 70,
    "nuh": 71, "al-jinn": 72, "al-muzzammil": 73, "al-muddaththir": 74,
    "al-qiyamah": 75, "al-insan": 76, "al-mursalat": 77, "an-naba": 78,
    "an-nazi'at": 79, "'abasa": 80, "abasa": 80, "at-takwir": 81,
    "al-infitar": 82, "al-mutaffifin": 83, "al-inshiqaq": 84, "al-buruj": 85,
    "at-tariq": 86, "al-a'la": 87, "al-ala": 87, "al-ghashiyah": 88,
    "al-fajr": 89, "al-balad": 90, "ash-shams": 91, "al-layl": 92,
    "ad-duha": 93, "ash-sharh": 94, "at-tin": 95, "al-alaq": 96,
    "al-'alaq": 96, "al-qadr": 97, "al-bayyinah": 98, "az-zalzalah": 99,
    "al-adiyat": 100, "al-qari'ah": 101, "at-takathur": 102, "al-asr": 103,
    "al-humazah": 104, "al-fil": 105, "quraysh": 106, "al-ma'un": 107,
    "al-kawthar": 108, "al-kafirun": 109, "an-nasr": 110, "al-masad": 111,
    "al-lahab": 111, "al-ikhlas": 112, "al-falaq": 113, "an-nas": 114,
}

# (regex, sunnah slug, human name) — order matters (first hit wins).
BOOKS = [
    (r"(?:Sahih\s+)?(?:al-?)?Bukhari(?:\s+in\s+Al-?Adab\s+Al-?Mufrad)?",
     "bukhari", "Bukhari"),
    (r"(?:Sahih\s+)?Muslim",                                     "muslim",   "Muslim"),
    (r"(?:Sunan\s+)?Ab[iu]\s+Da(?:w|u)o?ud",                     "abudawud", "Abu Dawud"),
    (r"(?:Jami'?\s*at-?)?(?:Al-?)?Tirmidhi",                     "tirmidhi", "Tirmidhi"),
    (r"(?:Sunan\s+)?(?:an-?|Al-?)?Nasa'?i",                       "nasai",    "Nasa'i"),
    (r"(?:Sunan\s+)?Ibn\s+Majah",                                 "ibnmajah", "Ibn Majah"),
    (r"(?:Musnad\s+)?Ahmad",                                      "ahmad",    "Ahmad"),
    (r"(?:Muwatta\s+)?Malik",                                     "malik",    "Malik"),
]

# Collections sunnah.com does not host — worth citing but no URL to form.
OTHER_BOOKS = [
    (r"\bAl-?Hakim\b",                              "Al-Hakim (al-Mustadrak)"),
    (r"\bAl-?Tabarani\b",                           "Al-Tabarani"),
    (r"\bIbn\s+Al-?Sunni\b",                        "Ibn al-Sunni ('Amal al-Yawm wal-Layla)"),
    (r"\bAl-?Bayhaqi\b",                            "Al-Bayhaqi"),
    (r"\bAl-?Darimi\b",                             "Al-Darimi"),
    (r"\bAl-?Adab\s+Al-?Mufrad\b",                  "Al-Adab al-Mufrad"),
    (r"\bAl-?Nawawi\b",                             "Al-Nawawi (Al-Adhkar)"),
    (r"\bAmal\s+Al-?Yawm\s+wal-?Laylah\b",          "'Amal al-Yawm wal-Laylah"),
    (r"\bIbn\s+Hibban\b",                           "Ibn Hibban"),
]

QURAN_NUM = re.compile(r"(\d+):(\d+)")
QURAN_SURAH = re.compile(r"Surat?\s+([A-Za-z' \-]+?)\s+(\d+):(\d+)")


def find_hits(ref: str):
    hits, seen = [], set()
    for pat_body, slug, human in BOOKS:
        if slug in seen:
            continue
        # 1) prefer "No. NNNN" within the same clause
        m = re.compile(rf"\b{pat_body}\b((?:[^.;]|\.(?!\s+[A-Z]))*?)\b[Nn]o\.?\s*(\d+)",
                       re.I).search(ref)
        if m:
            hits.append((slug, m.group(2), human)); seen.add(slug); continue
        # 2) '#' style
        m = re.compile(rf"\b{pat_body}\b((?:[^.;]|\.(?!\s+[A-Z]))*?)#\s*(\d+)",
                       re.I).search(ref)
        if m:
            hits.append((slug, m.group(2), human)); seen.add(slug); continue
        # 3) fall back only for a bare "<book> NNNN" — where the number is
        # the first standalone integer right after the book name, not part of
        # a "volume/page" pair like "4/322". Refs that only give volumes and
        # pages are left for a human to resolve rather than URL-guessed.
        m = re.compile(rf"\b{pat_body}\b\s+(\d{{2,6}})(?![0-9/])",
                       re.I).search(ref)
        if m:
            hits.append((slug, m.group(1), human)); seen.add(slug)
    return hits


def parse_source(kind: str, ref: str):
    """Return (primary_url, primary_label, extra_hits, off_sunnah_books)."""
    if not ref:
        return (None, None, [], [])
    if kind == "quran":
        m = QURAN_SURAH.search(ref)
        if m:
            key = m.group(1).lower().strip().rstrip(",.")
            if key in SURAH:
                s = SURAH[key]; a = int(m.group(3))
                return (f"https://quran.com/{s}/{a}", f"Qur'an {s}:{a}", [], [])
        m = QURAN_NUM.search(ref)
        if m:
            s, a = int(m.group(1)), int(m.group(2))
            return (f"https://quran.com/{s}/{a}", f"Qur'an {s}:{a}", [], [])
    hits = find_hits(ref)
    others = [name for pat, name in OTHER_BOOKS if re.search(pat, ref, re.I)]
    if hits:
        s, n, hu = hits[0]
        return (f"https://sunnah.com/{s}:{n}", f"{hu} {n}",
                [(hu2, n2, f"https://sunnah.com/{s2}:{n2}") for s2, n2, hu2 in hits[1:]],
                others)
    return (None, None, [], others)


# ---------- Hisn al-Muslim chapter map ----------
def load_hisn_chapters(sd: pathlib.Path):
    m = {}
    for f in sorted(sd.glob("*.json"), key=lambda p: int(p.stem)):
        try:
            data = json.loads(f.read_text(encoding="utf-8-sig"))
        except Exception:
            continue
        if isinstance(data, dict):
            for k in data:
                m[k.strip().lower()] = int(f.stem)
    return m


def hisn_label(ref: str, chapters: dict):
    m = re.match(r"Hisn al-Muslim\s*[—-]\s*(.+)", ref)
    if not m:
        return None
    name = m.group(1).strip().lower().rstrip(".")
    if name in chapters:
        return f"Hisn al-Muslim ch. {chapters[name]}"
    for k, v in chapters.items():
        if name in k or k in name:
            return f"Hisn al-Muslim ch. {v}"
    return f"Hisn al-Muslim — {m.group(1).strip()}"


def snip(s: str, n: int = 50):
    if not s:
        return ""
    s = s.replace("\n", " ").replace("|", "\\|").strip()
    return s if len(s) <= n else s[: n - 1].rstrip() + "…"


def build(snapshot_path: pathlib.Path, hisn_dir: pathlib.Path,
          out_path: pathlib.Path):
    snap = json.loads(snapshot_path.read_text())
    hisn_chapters = load_hisn_chapters(hisn_dir)

    dhikrs_by_slug = {d["slug"]: d for d in snap["dhikrs"]}
    cd_by_chapter = defaultdict(list)
    for cd in snap["chapterDhikrs"]:
        cd_by_chapter[cd["chapter"]].append(cd)
    chapters_by_collection = defaultdict(list)
    for ch in snap["chapters"]:
        chapters_by_collection[ch["collection"]].append(ch)

    lines = []
    push = lines.append
    push("# Adhkar — dua sources for review\n\n")
    push("Every one of the 327 supplications in the app, alongside its primary\n")
    push("hadith or Qur'an citation and, where possible, a direct link on\n")
    push("[sunnah.com](https://sunnah.com) or [quran.com](https://quran.com).\n\n")
    push("Grouped by the seven collections and their 151 chapters.\n\n")
    push("**Legend**\n\n")
    push("| | |\n|---|---|\n")
    push("| **[Book #####](https://sunnah.com)** | resolved to a numbered hadith on sunnah.com |\n")
    push("| **[Qur'an s:a](https://quran.com)** | Qur'an verse resolved from the surah/āyah |\n")
    push("| _Hisn al-Muslim ch. N_ | reference is the book itself, not a numbered hadith. Look up the underlying hadith at [hisnmuslim.com](https://www.hisnmuslim.com/) or in a printed Hisn — a reviewer can then add a sunnah.com URL |\n")
    push("| **· needs check** | citation could not be resolved automatically; raw text printed below |\n\n")
    push("Regenerate with `python3 docs/dua_references/build_dua_sources.py` whenever the snapshot changes.\n\n")

    push("## Contents\n\n")
    for c in snap["collections"]:
        push(f"* [{c['title']['en']}](#{c['slug']})\n")
    push("* [Coverage](#coverage)\n\n---\n\n")

    total = linked = hisn_labeled = external_only = 0

    for coll in snap["collections"]:
        push(f"## {coll['title']['en']}\n<a id=\"{coll['slug']}\"></a>\n\n")
        push(f"_{coll['subtitle']['en']}._\n\n")

        for ch in sorted(chapters_by_collection[coll["slug"]],
                         key=lambda c: c["order"]):
            entries = sorted(cd_by_chapter[ch["slug"]], key=lambda x: x["order"])
            if not entries:
                continue
            push(f"### {ch['title']['en']}\n\n")
            if ch.get("note", {}).get("en"):
                push(f"<sub>{ch['note']['en']}</sub>\n\n")
            push("| # | Arabic | Translation | Source |\n|---:|---|---|---|\n")
            pending = []
            for entry in entries:
                d = dhikrs_by_slug.get(entry["dhikr"])
                if not d:
                    continue
                total += 1
                ar = snip(d.get("arabic", ""), 46)
                en = snip((d.get("translation") or {}).get("en", ""), 90)
                ref = (d.get("reference") or {}).get("en", "")
                primary_url, primary_label, extras, others = parse_source(
                    d.get("attributionKind"), ref)
                if primary_url:
                    linked += 1
                    cell = f"[{primary_label}]({primary_url})"
                    if extras:
                        cell += " · also " + " · ".join(
                            f"[{hu} {n}]({u})" for hu, n, u in extras[:2])
                    if others:
                        cell += " · " + "/".join(others[:2])
                elif ref.startswith("Hisn al-Muslim"):
                    hisn_labeled += 1
                    cell = f"_{hisn_label(ref, hisn_chapters) or 'Hisn al-Muslim'}_"
                elif others:
                    external_only += 1
                    cell = " · ".join(others[:3])
                    pending.append((d["slug"], ref))
                else:
                    cell = "**· needs check**"
                    pending.append((d["slug"], ref))
                push(f"| {entry['order']} | <span dir=\"rtl\">{ar}</span> "
                     f"| {en} | {cell} |\n")
            push("\n")
            for slug, ref in pending:
                push(f"> **{slug}** — raw citation:  _{snip(ref, 220)}_\n\n")
        push("\n---\n\n")

    unresolved = total - linked - hisn_labeled - external_only
    push("## Coverage\n<a id=\"coverage\"></a>\n\n")
    push("| | | |\n|---|---:|---|\n")
    push(f"| Rows (dua × chapter) | **{total}** | some duas appear in more than one chapter |\n")
    push(f"| Direct sunnah.com / quran.com link | **{linked}** ({100*linked/total:.0f}%) "
         "| pulled from `No.` in the citation, or the surah/āyah in the Qur'an ones |\n")
    push(f"| Labelled to a Hisn al-Muslim chapter | **{hisn_labeled}** "
         f"({100*hisn_labeled/total:.0f}%) | underlying hadith number needs a manual lookup |\n")
    push(f"| Off-sunnah collection only | **{external_only}** | Al-Hakim, Al-Tabarani, Ibn al-Sunni — sunnah.com does not host these |\n")
    push(f"| Needs a human | **{unresolved}** | raw string printed below the row |\n\n")

    out_path.write_text("".join(lines))
    return {"total": total, "linked": linked, "hisn": hisn_labeled,
            "external": external_only, "unresolved": unresolved}


if __name__ == "__main__":
    here = pathlib.Path(__file__).resolve().parent  # docs/dua_references
    project_root = here.parent.parent.parent        # AdhkarApp
    api_root = project_root / "adhkar_api"
    stats = build(
        snapshot_path=api_root / "content" / "snapshot.json",
        hisn_dir=api_root / "content" / "sources" / "hisn" / "en",
        out_path=here / "dua-sources.md",
    )
    print("dua-sources.md written · " +
          " · ".join(f"{k}: {v}" for k, v in stats.items()))
