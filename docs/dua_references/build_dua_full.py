"""Regenerate `dua-full.md` from the app's content snapshot.

Collection × chapter grouping, same ordering as `dua-hisn-urls.md`, but prints
every field the app has for each supplication: Arabic, transliteration,
translation, virtue, reference, repeat, attribution, audio URL when present.

Usage:
    python3 docs/dua_references/build_dua_full.py

Reads `../adhkar_api/content/snapshot.json` and writes `docs/dua-full.md`.
"""

from __future__ import annotations
import json, pathlib
from collections import defaultdict


ATTRIBUTION_LABEL = {
    "quran": "Qur'an",
    "prophetic": "Prophetic (from the Prophet ﷺ)",
    "transmitted": "Transmitted (from a companion or later)",
}


def block(label: str, text: str, rtl: bool = False) -> str:
    if not text:
        return ""
    lines = [f"**{label}**"]
    for line in text.split("\n"):
        if rtl:
            lines.append(f"> <span dir=\"rtl\">{line}</span>  ")
        else:
            lines.append(f"> {line}  ")
    lines.append("")
    return "\n".join(lines) + "\n"


def build(snapshot_path: pathlib.Path, out_path: pathlib.Path) -> dict:
    snap = json.loads(snapshot_path.read_text())

    dhikrs_by_slug = {d["slug"]: d for d in snap["dhikrs"]}
    cd_by_chapter: dict[str, list] = defaultdict(list)
    for cd in snap["chapterDhikrs"]:
        cd_by_chapter[cd["chapter"]].append(cd)
    chapters_by_collection: dict[str, list] = defaultdict(list)
    for ch in snap["chapters"]:
        chapters_by_collection[ch["collection"]].append(ch)

    out: list[str] = []
    push = out.append

    push("# Adhkar — full du'a text (as bundled in the app)\n\n")
    push("Every supplication from `adhkar_app_flutter/assets/content/snapshot.json`\n")
    push("in full: Arabic, transliteration, translation, virtue, reference.\n")
    push("Same collection × chapter grouping as `dua-hisn-urls.md`.\n\n")
    push(f"Snapshot: contentVersion `{snap.get('contentVersion')}` · "
         f"generated at `{snap.get('generatedAt')}`.\n\n")
    push("Regenerate with `python3 docs/dua_references/build_dua_full.py` whenever the "
         "snapshot changes.\n\n")

    push("## Contents\n\n")
    for c in snap["collections"]:
        push(f"* [{c['title']['en']}](#{c['slug']})\n")
    push("\n---\n\n")

    total = 0
    unique_seen: set[str] = set()

    for coll in snap["collections"]:
        push(f"## {coll['title']['en']}\n<a id=\"{coll['slug']}\"></a>\n\n")
        sub = (coll.get("subtitle") or {}).get("en", "")
        if sub:
            push(f"_{sub}._\n\n")

        for ch in sorted(chapters_by_collection[coll["slug"]],
                         key=lambda c: c["order"]):
            entries = sorted(cd_by_chapter[ch["slug"]], key=lambda x: x["order"])
            if not entries:
                continue
            push(f"### {ch['title']['en']}\n\n")
            note = (ch.get("note") or {}).get("en", "")
            if note:
                push(f"<sub>{note}</sub>\n\n")

            for entry in entries:
                d = dhikrs_by_slug.get(entry["dhikr"])
                if not d:
                    continue
                total += 1
                unique_seen.add(d["slug"])

                slug = d["slug"]
                attribution = ATTRIBUTION_LABEL.get(
                    d.get("attributionKind", "prophetic"),
                    d.get("attributionKind", ""))
                repeat = d.get("repeat", 1)
                repeat_label = (d.get("repeatLabel") or {}).get("en") or \
                               (d.get("repeatLabel") or {}).get("ar") or ""
                repeat_str = f"{repeat}×"
                if repeat_label and repeat_label.lower() not in ("once",):
                    repeat_str = f"{repeat}× ({repeat_label})"
                elif repeat_label:
                    repeat_str = repeat_label
                audio = d.get("audio")

                push(f"#### {entry['order']}. `{slug}`\n\n")

                meta = f"**Attribution**: {attribution}  \n" \
                       f"**Repeat**: {repeat_str}"
                if audio:
                    meta += f"  \n**Audio**: [{audio}]({audio})"
                push(meta + "\n\n")

                push(block("Arabic", d.get("arabic", ""), rtl=True))

                tr = d.get("transliteration") or {}
                if tr.get("en"):
                    push(block("Transliteration", tr["en"]))

                tn = d.get("translation") or {}
                if tn.get("en"):
                    push(block("Translation (en)", tn["en"]))
                # Non-English translations, if any.
                for lang, text in sorted(tn.items()):
                    if lang == "en" or not text:
                        continue
                    push(block(f"Translation ({lang})", text,
                               rtl=(lang == "ar")))

                virtue = d.get("virtue") or {}
                if virtue.get("en"):
                    push(block("Virtue", virtue["en"]))
                if virtue.get("ar"):
                    push(block("Virtue (ar)", virtue["ar"], rtl=True))

                ref = d.get("reference") or {}
                if ref.get("en"):
                    push(block("Reference", ref["en"]))
                if ref.get("ar"):
                    push(block("Reference (ar)", ref["ar"], rtl=True))

                push("---\n\n")

        push("\n")

    out_path.write_text("".join(out))
    return {"rows": total, "unique_supplications": len(unique_seen),
            "collections": len(snap["collections"]),
            "chapters": len(snap["chapters"])}


if __name__ == "__main__":
    here = pathlib.Path(__file__).resolve().parent  # docs/dua_references
    project_root = here.parent.parent.parent        # AdhkarApp
    api_root = project_root / "adhkar_api"
    out_path = here / "dua-full.md"
    stats = build(
        snapshot_path=api_root / "content" / "snapshot.json",
        out_path=out_path,
    )
    print("dua-full.md written · " +
          " · ".join(f"{k}: {v}" for k, v in stats.items()))
