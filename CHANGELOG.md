## 0.1.0

* Initial release.
* `KeyboardAccessoryHost` — wraps a form, tracks focus nodes, manages overlay lifecycle.
* `KeyboardAccessoryBar` — floating glassmorphic pill bar with adaptive light/dark colours.
* `KeyboardAccessoryTheme` — immutable value class for full visual customisation.
* `KeyboardAccessoryAction` — typed toolbar button with `spacer` sentinel.
* `KeyboardAccessoryScope` — `InheritedWidget` for app-level theme defaults.
* Three customisation tiers: custom actions → custom theme → full `barBuilder` replacement.
