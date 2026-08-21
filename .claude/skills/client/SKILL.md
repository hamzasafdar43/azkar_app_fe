---
name: client
description: The Sakinah Flutter client — the design system, the serenity constraints, how the book is loaded and searched, how counting works, and how to run it on a simulator. Load before touching anything in adhkar_app_flutter/.
---

# The Flutter client

```
lib/main.dart                  the launch path; nothing blocks the first screen
lib/src/data/content.dart      the book in memory — models + snapshot loader
lib/src/data/local_store.dart  everything personal, on the device
lib/src/state/app_state.dart   ChangeNotifier; the only mutable thing
lib/src/core/day_part.dart     which sitting is due
lib/src/ui/design.dart         spacing, type, corners, faces — the system
lib/src/ui/theme.dart          colour; assembled from design.dart
lib/src/ui/home/               the front door
lib/src/ui/collection/         a collection's chapters
lib/src/ui/dhikr/              the reader and the counter
lib/src/ui/search/             offline search
lib/src/ui/settings/
lib/src/ui/widgets/            ArabicText, scaffolding
```

Three dependencies, one of them Flutter. `shared_preferences` is the only
package. There is **no `http`** — the app makes no network request at all today
(TODO 5), and adding the dependency before the feature would be a privacy
question answered early and for nothing.

## The design system

`design.dart` holds every spacing, size and weight a screen may use. A screen
that needs a value the system lacks should change the system, not hand-pick one.

Ported from the Hifz app with two differences, both from the brief's one word,
*serenity*:

* **The scale is one step looser** everywhere. Air is the cheapest way to buy
  the feeling.
* **There is a fifth type size above the other four** — `TypeScale.arabic`. The
  Arabic *is* the content (F7.1), not a label on it, and it is the one thing on
  a screen allowed to be large.

`theme.dart` makes three colour choices that carry the whole feel:

* **Paper, not white.** `surface` is a warm off-white; the dark equivalent is a
  green-black, not black. Material's generated scheme gets the *relationships*
  right and the neutrals wrong for this app, so its tonal work is kept and four
  surfaces are overridden.
* **One accent, used rarely** — deep desaturated teal, marking what can be acted
  on and nothing else.
* **No second saturated colour.** No red, no amber, no green-for-success.
  Nothing here needs to be alarming and X4 rules out congratulating.

`primaryContainer` is overridden too: Material's generated mint for this seed
reads as a highlighter pen. `SakinahColors.dueLight/dueDark` are the same hue
pulled most of the way back to the paper.

## ArabicText — always use it

Never render Arabic with a bare `Text`. `ui/widgets/arabic_text.dart` gets four
things right that a `Text` does not:

* **The face.** Qur'anic text uses `AmiriQuran` (mushaf orthography and mark
  placement); everything else uses `Amiri`. Keyed off `Attribution.quran`.
* **The direction.** Always RTL regardless of interface language (F7.5).
* **The size.** `TypeScale.arabic` × the reader's multiplier (F7.1) × the system
  text scale (X5.2). Two independent settings, both must apply.
* **The screen reader.** A `LocaleStringAttribute` on the label, or VoiceOver
  attempts Arabic script with an English voice (X5.4).

Line height is the other reason it is a widget: vowelled Arabic needs 1.9 (Amiri)
to 2.1 (Amiri Quran), not the 1.5 Latin text wants. At 1.5 the harakat touch the
line above.

## The reader and the counter

`ui/dhikr/reader_screen.dart`. **One supplication per page**, not a long scroll:
a scroll puts the next thing in the corner of the eye of someone meant to be
saying *this* thing, and makes losing your place the default.

**The counter is a bar pinned to the bottom, not the whole page.** X5.5 wants a
target hit one-handed without looking, which argues for making everything
tappable — but a translation can run to a screenful and someone scrolling to
read must not count by accident.

**Counting is down** (F4.4): what is left to say is the useful number.

**Progress is written to disk on every tap** (F4.3), not on leaving the screen.
A dhikr half said must be finished, not restarted. `SharedPreferences` writes
are batched by the platform, which is what makes per-tap affordable.

Reopening a chapter **resumes at the first unfinished supplication**, not at
page one.

Hierarchy in the bottom bar: filled teal when counting, quiet bordered when the
action is just "Next". The counter is the loud thing and the only loud thing.

## Loading and searching

The whole book is parsed once at launch, on a background isolate (`compute`), and
held resident. 590 KB is less than one photograph, and holding it buys instant
search and an app that works on a plane.

Search is a substring test against a **pre-folded** corpus built by
`build_content.py`. The client's `foldQuery` is the query half and must agree
with the builder's `fold`/`fold_latin`. Dart has no Unicode normalisation in
core, so pre-composed Latin letters (`ḥ`, `ā`) are handled by an explicit table.

## Running it

Homebrew's Flutter is broken for this user — the cache under
`/opt/homebrew/share/flutter` is owned by another macOS account. Use:

```bash
~/flutter/bin/flutter run -d "iPhone 17"
```

`--release` is not supported on an iOS simulator; use debug.

For hot reload from a script, drive stdin through a fifo held open by a sleeper,
then `echo r > /tmp/sakinah.fifo`. Piping `flutter run` into `tail` buffers
everything and shows nothing — redirect to a file instead.

## What not to add

X4 rules out badges, streaks, confetti and anything that reads as a score. The
one permitted celebratory-adjacent thing is the quiet completion sheet at the
end of a sitting, which states a fact and stops.

U4 is the reason: someone opens "When You Need It" bereaved. Nothing on that
path may be cheerful — including the empty-search state.
