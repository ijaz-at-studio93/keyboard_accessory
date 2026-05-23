## 0.1.1

* **Fix:** `barBuilder` now receives a `BuildContext` as its first argument —
  `barBuilder: (context, ctx)` — so `MediaQuery.viewInsetsOf(context)` reads
  the live overlay context instead of a stale outer widget context.
* **Fix:** Custom bar in example tab 3 no longer stays hidden behind the keyboard.
* **Docs:** Added demo GIF to README; updated `barBuilder` code snippet to match
  the corrected signature.

## 0.1.0

* Initial release.
* `KeyboardAccessoryHost` — wraps a form, tracks focus nodes, manages overlay lifecycle.
* `KeyboardAccessoryBar` — floating glassmorphic pill bar with adaptive light/dark colours.
* `KeyboardAccessoryTheme` — immutable value class for full visual customisation.
* `KeyboardAccessoryAction` — typed toolbar button with `spacer` sentinel.
* `KeyboardAccessoryScope` — `InheritedWidget` for app-level theme defaults.
* Three customisation tiers: custom actions → custom theme → full `barBuilder` replacement.
