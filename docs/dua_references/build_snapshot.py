"""Regenerate a review copy of the content snapshot under `docs/dua_references/`.

Thin wrapper — the *builder* is `adhkar_api/scripts/build_content.py`, and it is
the only path that turns the authentic sources under `adhkar_api/content/` into
a snapshot. This script invokes it, then copies its output next to the other
review artefacts (`dua-full.md`, `dua-full.html`, `dua-hisn-urls.md`) so it
can be inspected alongside them.

The Flutter asset at `adhkar_app_flutter/assets/content/snapshot.json` is left
untouched — bumping the bundled snapshot is a separate step (copy the API's
snapshot over by hand, and bump `CONTENT_VERSION` first if the change should
reach existing installs — PRD F1.5).

Usage:
    python3 docs/dua_references/build_snapshot.py
"""

from __future__ import annotations
import pathlib
import shutil
import subprocess
import sys


def main() -> int:
    here = pathlib.Path(__file__).resolve().parent  # docs/dua_references
    docs_root = here.parent.parent                  # adhkar_docs
    project_root = docs_root.parent                 # AdhkarApp
    api_root = project_root / "adhkar_api"
    builder = api_root / "scripts" / "build_content.py"
    snapshot_src = api_root / "content" / "snapshot.json"
    snapshot_dst = here / "snapshot.json"

    if not builder.exists():
        sys.exit(f"builder not found: {builder}")

    # Prefer the api's venv — that's where the builder is developed.
    venv_py = api_root / ".venv" / "bin" / "python"
    py = str(venv_py) if venv_py.exists() else sys.executable

    print(f"running {builder.relative_to(project_root)}")
    subprocess.run([py, str(builder)], check=True, cwd=api_root)

    if not snapshot_src.exists():
        sys.exit(f"builder ran but did not produce {snapshot_src}")

    shutil.copyfile(snapshot_src, snapshot_dst)
    size_kb = snapshot_dst.stat().st_size / 1024
    print(f"copied → {snapshot_dst.relative_to(project_root)} ({size_kb:.0f} KB)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
