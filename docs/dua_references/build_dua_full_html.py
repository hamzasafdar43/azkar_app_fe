"""Regenerate `dua-full.html` from the app's content snapshot.

Same grouping and fields as `build_dua_full.py`, but the output is a
single self-contained HTML page. Each supplication is rendered with its
`id_prayer` badge (the dhikr slug) and a feedback area where a reviewer
can paste a reference (or press "Not found") and hit Save. Feedback is
kept in the browser via localStorage under the key `adhkar_feedback_v1`
and can be exported / imported as JSON of the shape
    [{"id_prayer": "adhkar-1", "feedback": "..."}, ...]

Usage:
    python3 docs/dua_references/build_dua_full_html.py

Reads `adhkar_api/content/snapshot.json` and writes
`adhkar_docs/docs/dua_references/dua-full.html`.
"""

from __future__ import annotations

import html
import json
import pathlib
from collections import defaultdict


ATTRIBUTION_LABEL = {
    "quran": "Qur'an",
    "prophetic": "Prophetic (from the Prophet ✊)".replace("✊", "✊"),
    "transmitted": "Transmitted (from a companion or later)",
}
# Use the ﷺ glyph for prophetic like the markdown builder does.
ATTRIBUTION_LABEL["prophetic"] = "Prophetic (from the Prophet ﷺ)"


def esc(text: str) -> str:
    return html.escape(text or "", quote=True)


def block(label: str, text: str, rtl: bool = False) -> str:
    if not text:
        return ""
    dir_attr = ' dir="rtl" lang="ar"' if rtl else ""
    cls = "field-body rtl" if rtl else "field-body"
    lines = "<br>".join(esc(line) for line in text.split("\n"))
    return (
        f'<div class="field">'
        f'<div class="field-label">{esc(label)}</div>'
        f'<div class="{cls}"{dir_attr}>{lines}</div>'
        f'</div>'
    )


def render_dua(entry_order: int, dhikr: dict, is_first_occurrence: bool) -> str:
    slug = dhikr["slug"]
    attribution = ATTRIBUTION_LABEL.get(
        dhikr.get("attributionKind", "prophetic"),
        dhikr.get("attributionKind", ""),
    )
    repeat = dhikr.get("repeat", 1)
    repeat_label = (dhikr.get("repeatLabel") or {}).get("en") or \
                   (dhikr.get("repeatLabel") or {}).get("ar") or ""
    repeat_str = f"{repeat}×"
    if repeat_label and repeat_label.lower() != "once":
        repeat_str = f"{repeat}× ({repeat_label})"
    elif repeat_label:
        repeat_str = repeat_label
    audio = dhikr.get("audio")

    parts: list[str] = []
    anchor_attr = f' id="{esc(slug)}"' if is_first_occurrence else ""
    parts.append(f'<article class="dua"{anchor_attr} data-id-prayer="{esc(slug)}">')
    parts.append(
        f'<header class="dua-head">'
        f'<span class="dua-order">{entry_order}.</span>'
        f'<button type="button" class="id-badge" title="Copy id_prayer" '
        f'data-copy="{esc(slug)}">{esc(slug)}</button>'
        f'<span class="dua-meta"><b>Attribution:</b> {esc(attribution)}</span>'
        f'<span class="dua-meta"><b>Repeat:</b> {esc(repeat_str)}</span>'
    )
    if audio:
        parts.append(
            f'<span class="dua-meta"><b>Audio:</b> '
            f'<a href="{esc(audio)}" target="_blank" rel="noopener">{esc(audio)}</a>'
            f'</span>'
        )
    parts.append("</header>")

    parts.append(block("Arabic", dhikr.get("arabic", ""), rtl=True))

    tr = dhikr.get("transliteration") or {}
    if tr.get("en"):
        parts.append(block("Transliteration", tr["en"]))

    tn = dhikr.get("translation") or {}
    if tn.get("en"):
        parts.append(block("Translation (en)", tn["en"]))
    for lang, text in sorted(tn.items()):
        if lang == "en" or not text:
            continue
        parts.append(block(f"Translation ({lang})", text, rtl=(lang == "ar")))

    virtue = dhikr.get("virtue") or {}
    if virtue.get("en"):
        parts.append(block("Virtue", virtue["en"]))
    if virtue.get("ar"):
        parts.append(block("Virtue (ar)", virtue["ar"], rtl=True))

    ref = dhikr.get("reference") or {}
    if ref.get("en"):
        parts.append(block("Reference", ref["en"]))
    if ref.get("ar"):
        parts.append(block("Reference (ar)", ref["ar"], rtl=True))

    parts.append(
        f'<section class="feedback" data-id-prayer="{esc(slug)}">'
        f'  <div class="feedback-label">'
        f'    <span>Your reference / correction</span>'
        f'    <span class="feedback-status" data-role="status"></span>'
        f'  </div>'
        f'  <textarea data-role="input" rows="3" '
        f'    placeholder="Paste the reference, or press “Not found”.">'
        f'  </textarea>'
        f'  <div class="feedback-actions">'
        f'    <button type="button" data-role="save">Save</button>'
        f'    <button type="button" data-role="not-found">Not found</button>'
        f'    <button type="button" data-role="clear" class="ghost">Clear</button>'
        f'  </div>'
        f'  <div class="feedback-saved" data-role="saved" hidden>'
        f'    <span class="feedback-saved-label">Saved</span>'
        f'    <span class="feedback-saved-when" data-role="when"></span>'
        f'    <div class="feedback-saved-text" data-role="savedText"></div>'
        f'  </div>'
        f'</section>'
    )
    parts.append("</article>")
    return "\n".join(parts)


CSS = r"""
:root {
  --bg: #f7f5ef;
  --panel: #ffffff;
  --panel-2: #fbfaf6;
  --ink: #1f1d1a;
  --ink-soft: #4a463f;
  --ink-muted: #7a746a;
  --line: #e6e1d5;
  --line-strong: #d4cdbb;
  --accent: #6a5b3a;
  --accent-ink: #ffffff;
  --danger: #a3341a;
  --ok: #2f6d3a;
  --code-bg: #efeadd;
  --shadow: 0 1px 2px rgba(0,0,0,0.05), 0 4px 12px rgba(0,0,0,0.04);
  --radius: 10px;
  --mono: ui-monospace, "SF Mono", Menlo, Consolas, monospace;
  --serif: "Iowan Old Style", "Palatino Linotype", Palatino, Georgia, serif;
  --arabic: "SF Arabic", "Noto Naskh Arabic", "Amiri", "Traditional Arabic", serif;
}
@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    --bg: #17140f;
    --panel: #1f1c16;
    --panel-2: #221e17;
    --ink: #efeadd;
    --ink-soft: #cdc6b4;
    --ink-muted: #8f887a;
    --line: #2e2921;
    --line-strong: #3b342a;
    --accent: #d7c48a;
    --accent-ink: #17140f;
    --danger: #f3a291;
    --ok: #9fd0a4;
    --code-bg: #2a251d;
    --shadow: 0 1px 2px rgba(0,0,0,0.4), 0 4px 12px rgba(0,0,0,0.35);
  }
}
:root[data-theme="dark"] {
  --bg: #17140f;
  --panel: #1f1c16;
  --panel-2: #221e17;
  --ink: #efeadd;
  --ink-soft: #cdc6b4;
  --ink-muted: #8f887a;
  --line: #2e2921;
  --line-strong: #3b342a;
  --accent: #d7c48a;
  --accent-ink: #17140f;
  --danger: #f3a291;
  --ok: #9fd0a4;
  --code-bg: #2a251d;
  --shadow: 0 1px 2px rgba(0,0,0,0.4), 0 4px 12px rgba(0,0,0,0.35);
}

body {
  background: var(--bg);
  color: var(--ink);
  font: 15px/1.55 var(--serif);
  margin: 0;
}
.wrap {
  max-width: 880px;
  margin: 0 auto;
  padding: 20px 20px 120px;
}
h1 { font-size: 26px; margin: 8px 0 4px; }
h2 {
  font-size: 22px;
  margin: 36px 0 8px;
  padding-bottom: 6px;
  border-bottom: 1px solid var(--line-strong);
}
h3 { font-size: 18px; margin: 24px 0 6px; color: var(--ink-soft); }
.subtle { color: var(--ink-muted); }
.chapter-note { color: var(--ink-muted); font-style: italic; margin: -2px 0 10px; }

.toolbar {
  position: sticky;
  top: 0;
  z-index: 10;
  background: color-mix(in oklab, var(--bg) 92%, transparent);
  backdrop-filter: saturate(140%) blur(6px);
  -webkit-backdrop-filter: saturate(140%) blur(6px);
  border-bottom: 1px solid var(--line);
  padding: 10px 20px;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  align-items: center;
}
.toolbar .spacer { flex: 1; }
.toolbar .progress { color: var(--ink-muted); font: 13px var(--serif); }
.toolbar .progress b { color: var(--ink); }

button, .btn {
  font: inherit;
  color: var(--ink);
  background: var(--panel);
  border: 1px solid var(--line-strong);
  border-radius: 8px;
  padding: 6px 12px;
  cursor: pointer;
  box-shadow: var(--shadow);
}
button:hover { border-color: var(--accent); }
button.primary {
  background: var(--accent);
  color: var(--accent-ink);
  border-color: var(--accent);
}
button.ghost {
  background: transparent;
  border-color: transparent;
  box-shadow: none;
  color: var(--ink-muted);
}
button.ghost:hover { color: var(--ink); border-color: var(--line); }

.toc {
  columns: 2;
  column-gap: 24px;
  margin: 8px 0 12px;
  padding: 12px 16px;
  background: var(--panel-2);
  border: 1px solid var(--line);
  border-radius: var(--radius);
}
.toc a { color: var(--ink-soft); text-decoration: none; }
.toc a:hover { color: var(--ink); text-decoration: underline; }

.dua {
  position: relative;
  background: var(--panel);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  padding: 14px 16px 12px;
  margin: 12px 0 18px;
  box-shadow: var(--shadow);
  scroll-margin-top: 72px;
}
.dua-head {
  display: flex;
  flex-wrap: wrap;
  gap: 8px 12px;
  align-items: center;
  padding-bottom: 8px;
  border-bottom: 1px dashed var(--line);
  margin-bottom: 10px;
}
.dua-order {
  color: var(--ink-muted);
  font: 600 14px var(--serif);
  min-width: 24px;
}
.id-badge {
  font: 12px/1 var(--mono);
  background: var(--code-bg);
  color: var(--ink);
  border: 1px solid var(--line-strong);
  border-radius: 999px;
  padding: 5px 10px;
  cursor: copy;
  box-shadow: none;
}
.id-badge:hover { border-color: var(--accent); }
.id-badge.copied { color: var(--ok); border-color: var(--ok); }
.dua-meta { color: var(--ink-soft); font-size: 13px; }
.dua-meta b { color: var(--ink); font-weight: 600; }
.dua-meta a { color: var(--accent); text-decoration: none; }
.dua-meta a:hover { text-decoration: underline; }

.field { margin: 8px 0; }
.field-label {
  font: 600 12px/1 var(--serif);
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--ink-muted);
  margin-bottom: 4px;
}
.field-body {
  border-left: 2px solid var(--line-strong);
  padding: 2px 0 2px 10px;
  color: var(--ink);
}
.field-body.rtl {
  direction: rtl;
  text-align: right;
  border-left: 0;
  border-right: 2px solid var(--line-strong);
  padding: 2px 10px 2px 0;
  font-family: var(--arabic);
  font-size: 20px;
  line-height: 1.9;
}

.feedback {
  margin-top: 12px;
  padding: 10px 12px;
  background: var(--panel-2);
  border: 1px solid var(--line);
  border-radius: 8px;
}
.feedback.has-value { border-color: var(--accent); }
.feedback-label {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font: 600 12px/1 var(--serif);
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--ink-muted);
  margin-bottom: 6px;
}
.feedback-status { font-weight: 500; letter-spacing: 0; text-transform: none; }
.feedback-status.ok { color: var(--ok); }
.feedback-status.miss { color: var(--danger); }
.feedback textarea {
  width: 100%;
  box-sizing: border-box;
  font: 14px/1.5 var(--serif);
  color: var(--ink);
  background: var(--panel);
  border: 1px solid var(--line-strong);
  border-radius: 8px;
  padding: 8px 10px;
  resize: vertical;
  min-height: 68px;
}
.feedback textarea:focus {
  outline: 2px solid color-mix(in oklab, var(--accent) 60%, transparent);
  outline-offset: 2px;
  border-color: var(--accent);
}
.feedback-actions {
  display: flex;
  gap: 8px;
  margin-top: 8px;
}
.feedback-actions button[data-role="save"] {
  background: var(--accent);
  color: var(--accent-ink);
  border-color: var(--accent);
}
.feedback-saved {
  margin-top: 8px;
  padding: 8px 10px;
  border: 1px solid var(--line);
  border-radius: 8px;
  background: color-mix(in oklab, var(--panel) 80%, var(--bg));
  font-size: 13px;
}
.feedback-saved-label {
  color: var(--ok);
  font-weight: 600;
  margin-right: 6px;
}
.feedback-saved-when { color: var(--ink-muted); font-size: 12px; }
.feedback-saved-text {
  white-space: pre-wrap;
  margin-top: 4px;
  color: var(--ink);
}
.feedback-saved-text.miss { color: var(--danger); font-style: italic; }

/* Import/export overlay */
dialog {
  border: 1px solid var(--line-strong);
  border-radius: var(--radius);
  background: var(--panel);
  color: var(--ink);
  padding: 0;
  box-shadow: var(--shadow);
  max-width: 640px;
  width: min(92vw, 640px);
}
dialog::backdrop { background: rgba(0,0,0,0.35); }
dialog .dlg-body { padding: 14px 16px; }
dialog .dlg-body h3 { margin-top: 0; }
dialog textarea {
  width: 100%;
  box-sizing: border-box;
  min-height: 200px;
  font: 12px/1.4 var(--mono);
  background: var(--panel-2);
  color: var(--ink);
  border: 1px solid var(--line-strong);
  border-radius: 8px;
  padding: 8px 10px;
}
dialog .dlg-actions {
  display: flex;
  gap: 8px;
  justify-content: flex-end;
  padding: 10px 16px 14px;
  border-top: 1px solid var(--line);
}

/* Filter toggle */
.filter {
  display: inline-flex;
  gap: 4px;
  padding: 3px;
  background: var(--panel-2);
  border: 1px solid var(--line);
  border-radius: 999px;
}
.filter button {
  padding: 4px 10px;
  font-size: 12px;
  border-radius: 999px;
  box-shadow: none;
  border-color: transparent;
  background: transparent;
  color: var(--ink-muted);
}
.filter button[aria-pressed="true"] {
  background: var(--panel);
  border-color: var(--line-strong);
  color: var(--ink);
}

@media (max-width: 600px) {
  .toc { columns: 1; }
  .wrap { padding: 16px 12px 100px; }
  h1 { font-size: 22px; }
}
"""


JS = r"""
(function () {
  const STORAGE_KEY = 'adhkar_feedback_v1';
  const NOT_FOUND = '__not_found__';

  const loadStore = () => {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      return raw ? JSON.parse(raw) : {};
    } catch (_) {
      return {};
    }
  };
  const saveStore = (store) => {
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(store));
    } catch (e) {
      alert('Could not save to localStorage: ' + (e && e.message || e));
    }
  };
  const nowStamp = () => new Date().toISOString();
  const fmtWhen = (iso) => {
    if (!iso) return '';
    try {
      const d = new Date(iso);
      return d.toLocaleString(undefined, {
        year: 'numeric', month: 'short', day: 'numeric',
        hour: '2-digit', minute: '2-digit'
      });
    } catch (_) { return iso; }
  };

  let store = loadStore();

  const cards = Array.from(document.querySelectorAll('.dua'));
  const cardsById = cards.reduce((acc, c) => {
    (acc[c.dataset.idPrayer] ||= []).push(c);
    return acc;
  }, {});
  const uniqueIds = Object.keys(cardsById);
  const total = uniqueIds.length;
  const paintAllForId = (id) => (cardsById[id] || []).forEach(paintCard);

  const paintCard = (card) => {
    const id = card.dataset.idPrayer;
    const rec = store[id];
    const feedbackEl = card.querySelector('.feedback');
    const input = feedbackEl.querySelector('[data-role="input"]');
    const status = feedbackEl.querySelector('[data-role="status"]');
    const savedBox = feedbackEl.querySelector('[data-role="saved"]');
    const savedText = feedbackEl.querySelector('[data-role="savedText"]');
    const when = feedbackEl.querySelector('[data-role="when"]');

    if (rec && (rec.feedback || rec.feedback === NOT_FOUND)) {
      feedbackEl.classList.add('has-value');
      savedBox.hidden = false;
      const isMiss = rec.feedback === NOT_FOUND;
      savedText.classList.toggle('miss', isMiss);
      savedText.textContent = isMiss ? 'Not found.' : rec.feedback;
      when.textContent = rec.updatedAt ? '· ' + fmtWhen(rec.updatedAt) : '';
      status.textContent = isMiss ? 'Marked not found' : 'Saved';
      status.className = 'feedback-status ' + (isMiss ? 'miss' : 'ok');
      if (input.value === '' && !isMiss) input.value = rec.feedback;
    } else {
      feedbackEl.classList.remove('has-value');
      savedBox.hidden = true;
      savedText.textContent = '';
      when.textContent = '';
      status.textContent = '';
      status.className = 'feedback-status';
    }
  };

  const updateProgress = () => {
    let withRef = 0, notFound = 0;
    uniqueIds.forEach((id) => {
      const r = store[id];
      if (!r) return;
      if (r.feedback === NOT_FOUND) notFound++;
      else if (r.feedback) withRef++;
    });
    document.getElementById('progress').innerHTML =
      '<b>' + withRef + '</b> with reference · ' +
      '<b>' + notFound + '</b> not found · ' +
      '<b>' + (total - withRef - notFound) + '</b> pending / ' + total;
    applyFilter();
  };

  let currentFilter = 'all';
  const applyFilter = () => {
    cards.forEach((card) => {
      const rec = store[card.dataset.idPrayer];
      const hasRef = rec && rec.feedback && rec.feedback !== NOT_FOUND;
      const miss = rec && rec.feedback === NOT_FOUND;
      const pending = !hasRef && !miss;
      let show = true;
      if (currentFilter === 'pending') show = pending;
      else if (currentFilter === 'saved') show = hasRef;
      else if (currentFilter === 'missing') show = miss;
      card.hidden = !show;
    });
  };

  cards.forEach((card) => {
    const id = card.dataset.idPrayer;
    const feedbackEl = card.querySelector('.feedback');
    const input = feedbackEl.querySelector('[data-role="input"]');
    const saveBtn = feedbackEl.querySelector('[data-role="save"]');
    const notFoundBtn = feedbackEl.querySelector('[data-role="not-found"]');
    const clearBtn = feedbackEl.querySelector('[data-role="clear"]');

    saveBtn.addEventListener('click', () => {
      const value = input.value.trim();
      if (!value) {
        input.focus();
        return;
      }
      store[id] = { feedback: value, updatedAt: nowStamp() };
      saveStore(store);
      paintAllForId(id);
      updateProgress();
    });

    notFoundBtn.addEventListener('click', () => {
      store[id] = { feedback: NOT_FOUND, updatedAt: nowStamp() };
      saveStore(store);
      input.value = '';
      paintAllForId(id);
      updateProgress();
    });

    clearBtn.addEventListener('click', () => {
      delete store[id];
      saveStore(store);
      input.value = '';
      paintAllForId(id);
      updateProgress();
    });

    input.addEventListener('keydown', (e) => {
      if ((e.metaKey || e.ctrlKey) && e.key === 'Enter') {
        e.preventDefault();
        saveBtn.click();
      }
    });

    paintCard(card);
  });

  document.querySelectorAll('.id-badge').forEach((b) => {
    b.addEventListener('click', async () => {
      const v = b.dataset.copy || b.textContent;
      try {
        await navigator.clipboard.writeText(v);
        b.classList.add('copied');
        setTimeout(() => b.classList.remove('copied'), 900);
      } catch (_) {
        const r = document.createRange();
        r.selectNodeContents(b);
        const sel = window.getSelection();
        sel.removeAllRanges();
        sel.addRange(r);
      }
    });
  });

  const exportPayload = () => {
    return uniqueIds.map((id) => {
      const r = store[id];
      return {
        id_prayer: id,
        feedback: r ? (r.feedback === NOT_FOUND ? 'not found' : r.feedback) : '',
        status: r ? (r.feedback === NOT_FOUND ? 'not_found' : 'has_reference') : 'pending',
        updated_at: r && r.updatedAt || null
      };
    });
  };

  document.getElementById('btn-export').addEventListener('click', () => {
    const payload = exportPayload();
    const blob = new Blob([JSON.stringify(payload, null, 2)],
                         { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'adhkar-feedback.json';
    document.body.appendChild(a);
    a.click();
    a.remove();
    setTimeout(() => URL.revokeObjectURL(url), 5000);
  });

  document.getElementById('btn-export-visible').addEventListener('click', () => {
    const dlg = document.getElementById('dlg-view');
    dlg.querySelector('textarea').value =
      JSON.stringify(exportPayload(), null, 2);
    dlg.showModal();
  });

  const importDlg = document.getElementById('dlg-import');
  document.getElementById('btn-import').addEventListener('click', () => {
    importDlg.querySelector('textarea').value = '';
    importDlg.showModal();
  });
  document.getElementById('btn-import-apply').addEventListener('click', () => {
    const raw = importDlg.querySelector('textarea').value.trim();
    if (!raw) { importDlg.close(); return; }
    let parsed;
    try {
      parsed = JSON.parse(raw);
    } catch (e) {
      alert('Not valid JSON: ' + e.message);
      return;
    }
    if (!Array.isArray(parsed)) {
      alert('Expected an array of {id_prayer, feedback} objects.');
      return;
    }
    const merge = document.getElementById('imp-merge').checked;
    if (!merge) store = {};
    for (const row of parsed) {
      if (!row || typeof row !== 'object') continue;
      const id = row.id_prayer;
      if (!id) continue;
      let fb = row.feedback;
      if (fb === undefined || fb === null || fb === '') continue;
      if (typeof fb === 'string' && fb.trim().toLowerCase() === 'not found') {
        fb = NOT_FOUND;
      }
      store[id] = { feedback: fb, updatedAt: row.updated_at || nowStamp() };
    }
    saveStore(store);
    cards.forEach(paintCard);
    updateProgress();
    importDlg.close();
  });

  document.getElementById('btn-clear-all').addEventListener('click', () => {
    if (!confirm('Clear ALL saved feedback in this browser? This cannot be undone.')) return;
    store = {};
    saveStore(store);
    cards.forEach(paintCard);
    updateProgress();
  });

  document.querySelectorAll('.filter button').forEach((b) => {
    b.addEventListener('click', () => {
      currentFilter = b.dataset.filter;
      document.querySelectorAll('.filter button').forEach((x) =>
        x.setAttribute('aria-pressed', x === b ? 'true' : 'false'));
      applyFilter();
    });
  });

  document.querySelectorAll('dialog [data-close]').forEach((el) => {
    el.addEventListener('click', () => el.closest('dialog').close());
  });

  updateProgress();
})();
"""


def build(snapshot_path: pathlib.Path, out_path: pathlib.Path) -> dict:
    snap = json.loads(snapshot_path.read_text())

    dhikrs_by_slug = {d["slug"]: d for d in snap["dhikrs"]}
    cd_by_chapter: dict[str, list] = defaultdict(list)
    for cd in snap["chapterDhikrs"]:
        cd_by_chapter[cd["chapter"]].append(cd)
    chapters_by_collection: dict[str, list] = defaultdict(list)
    for ch in snap["chapters"]:
        chapters_by_collection[ch["collection"]].append(ch)

    body: list[str] = []

    body.append(
        '<div class="toolbar">'
        '  <div class="filter" role="tablist" aria-label="Filter">'
        '    <button data-filter="all" aria-pressed="true">All</button>'
        '    <button data-filter="pending" aria-pressed="false">Pending</button>'
        '    <button data-filter="saved" aria-pressed="false">Saved</button>'
        '    <button data-filter="missing" aria-pressed="false">Not found</button>'
        '  </div>'
        '  <span id="progress" class="progress"></span>'
        '  <span class="spacer"></span>'
        '  <button id="btn-export-visible" title="Show JSON in a dialog">View JSON</button>'
        '  <button id="btn-export" class="primary">Download JSON</button>'
        '  <button id="btn-import">Import…</button>'
        '  <button id="btn-clear-all" class="ghost">Clear all</button>'
        '</div>'
    )

    body.append('<div class="wrap">')
    body.append("<h1>Adhkar — full du’a text (as bundled in the app)</h1>")
    body.append(
        f'<p class="subtle">Snapshot: contentVersion '
        f'<code>{esc(str(snap.get("contentVersion")))}</code> · '
        f'generated at <code>{esc(str(snap.get("generatedAt")))}</code>.</p>'
    )
    body.append(
        '<p class="subtle">Every supplication has its <code>id_prayer</code> '
        '(click the badge to copy). Add a reference or press '
        '<b>Not found</b>, then <b>Save</b>. Everything is stored locally in '
        'your browser; use <b>Download JSON</b> to export.</p>'
    )

    body.append('<nav class="toc">')
    for c in snap["collections"]:
        body.append(
            f'<div><a href="#{esc(c["slug"])}">{esc(c["title"]["en"])}</a></div>'
        )
    body.append("</nav>")

    total = 0
    unique_seen: set[str] = set()

    for coll in snap["collections"]:
        body.append(f'<section class="collection">')
        body.append(f'<h2 id="{esc(coll["slug"])}">{esc(coll["title"]["en"])}</h2>')
        sub = (coll.get("subtitle") or {}).get("en", "")
        if sub:
            body.append(f'<p class="subtle"><em>{esc(sub)}.</em></p>')

        for ch in sorted(chapters_by_collection[coll["slug"]],
                         key=lambda c: c["order"]):
            entries = sorted(cd_by_chapter[ch["slug"]], key=lambda x: x["order"])
            if not entries:
                continue
            body.append(f'<h3>{esc(ch["title"]["en"])}</h3>')
            note = (ch.get("note") or {}).get("en", "")
            if note:
                body.append(f'<p class="chapter-note">{esc(note)}</p>')

            for entry in entries:
                d = dhikrs_by_slug.get(entry["dhikr"])
                if not d:
                    continue
                total += 1
                is_first = d["slug"] not in unique_seen
                unique_seen.add(d["slug"])
                body.append(render_dua(entry["order"], d, is_first))

        body.append("</section>")

    body.append("</div>")

    body.append(
        '<dialog id="dlg-import">'
        '  <div class="dlg-body">'
        '    <h3>Import feedback JSON</h3>'
        '    <p class="subtle">Paste an array of '
        '      <code>{id_prayer, feedback}</code> rows. Use '
        '      <code>"not found"</code> as the feedback value to mark a '
        '      supplication as unresolved.</p>'
        '    <textarea placeholder=\'[{"id_prayer":"adhkar-1","feedback":"..."}]\'></textarea>'
        '    <label style="display:block; margin-top:8px;">'
        '      <input type="checkbox" id="imp-merge" checked> '
        '      Merge with existing (uncheck to replace)'
        '    </label>'
        '  </div>'
        '  <div class="dlg-actions">'
        '    <button type="button" data-close>Cancel</button>'
        '    <button type="button" id="btn-import-apply" class="primary">Import</button>'
        '  </div>'
        '</dialog>'
    )
    body.append(
        '<dialog id="dlg-view">'
        '  <div class="dlg-body">'
        '    <h3>Feedback JSON</h3>'
        '    <p class="subtle">Read-only view of the current export payload.</p>'
        '    <textarea readonly></textarea>'
        '  </div>'
        '  <div class="dlg-actions">'
        '    <button type="button" data-close class="primary">Close</button>'
        '  </div>'
        '</dialog>'
    )

    html_doc = (
        '<!doctype html>\n'
        '<html lang="en">\n'
        '<head>\n'
        '  <meta charset="utf-8">\n'
        '  <meta name="viewport" content="width=device-width, initial-scale=1">\n'
        '  <title>Adhkar — full du’a text</title>\n'
        f'  <style>{CSS}</style>\n'
        '</head>\n'
        '<body>\n'
        + "\n".join(body) + "\n"
        f'  <script>{JS}</script>\n'
        '</body>\n'
        '</html>\n'
    )

    out_path.write_text(html_doc)
    return {
        "rows": total,
        "unique_supplications": len(unique_seen),
        "collections": len(snap["collections"]),
        "chapters": len(snap["chapters"]),
    }


if __name__ == "__main__":
    here = pathlib.Path(__file__).resolve().parent  # docs/dua_references
    project_root = here.parent.parent.parent        # AdhkarApp
    api_root = project_root / "adhkar_api"
    out_path = here / "dua-full.html"
    stats = build(
        snapshot_path=api_root / "content" / "snapshot.json",
        out_path=out_path,
    )
    print("dua-full.html written · " +
          " · ".join(f"{k}: {v}" for k, v in stats.items()))
