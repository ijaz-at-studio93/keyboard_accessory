# keyboard_accessory

A floating glassmorphic keyboard accessory toolbar for Flutter. Wraps a form, tracks focus nodes, and shows a pill-shaped bar just above the keyboard with prev/next field navigation and a done button. Fully customisable — swap out the buttons, restyle the glass, or replace the entire bar.

## Features

- Floating glassmorphic pill bar that slides up/down with the keyboard
- Automatic prev / next / done navigation across a list of `FocusNode`s
- Handles dynamic `focusNodes` lists (e.g. switching between unit systems)
- Three customisation tiers: swap actions → restyle glass → replace entire bar
- App-level theme via `KeyboardAccessoryScope`
- No external dependencies — pure Flutter

## Installation

```yaml
dependencies:
  keyboard_accessory: ^0.1.0
```

## Usage

### Default — prev / next / done bar

Wrap your form with `KeyboardAccessoryHost` and pass the focus nodes in tab order:

```dart
KeyboardAccessoryHost(
  focusNodes: [nameFocus, emailFocus, bioFocus],
  onDone: () => formKey.currentState?.save(),
  child: MyForm(),
)
```

Add `KeyboardAccessoryTheme.defaultHeight` (44 px) of bottom padding inside scrollable content so the bar never covers the last field.

### Custom actions — keep glass bar, swap buttons

```dart
KeyboardAccessoryHost(
  focusNodes: [searchFocus],
  actions: [
    KeyboardAccessoryAction(
      icon: Icons.clear_rounded,
      tooltip: 'Clear',
      onPressed: _controller.text.isNotEmpty ? _controller.clear : null,
    ),
    KeyboardAccessoryAction.spacer,   // expands to fill space
    KeyboardAccessoryAction(
      icon: Icons.search_rounded,
      tooltip: 'Search',
      onPressed: _handleSearch,
    ),
  ],
  child: SearchField(focusNode: searchFocus),
)
```

### Themed glass bar — keep default actions, change appearance

Set an app-wide default with `KeyboardAccessoryScope` and override locally:

```dart
// App root
KeyboardAccessoryScope(
  theme: const KeyboardAccessoryTheme(
    blurSigma: 16,
    bottomGap: 8,
    lightGlassTint: Color(0x40FF9000),
  ),
  child: MaterialApp(home: MyApp()),
)

// One screen override
KeyboardAccessoryHost(
  focusNodes: [firstFocus, lastFocus],
  theme: const KeyboardAccessoryTheme(height: 52),
  child: ProfileForm(),
)
```

### Custom bar via `barBuilder` — replace the entire bar widget

When you need a completely different look (solid colour, brand bar, etc.):

```dart
KeyboardAccessoryHost(
  focusNodes: [firstFocus, lastFocus],
  barBuilder: (ctx) {
    if (!ctx.isVisible) return const SizedBox.shrink();
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 150),
      left: 0, right: 0,
      bottom: MediaQuery.viewInsetsOf(context).bottom,
      child: Material(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_upward_rounded),
              onPressed: ctx.hasPrevious ? ctx.onPrev : null,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_downward_rounded),
              onPressed: ctx.hasNext ? ctx.onNext : null,
            ),
            const Spacer(),
            TextButton(onPressed: ctx.onDone, child: const Text('Done')),
          ],
        ),
      ),
    );
  },
  child: MyForm(),
)
```

`KeyboardAccessoryBarContext` gives you `focusedIndex`, `totalCount`, `hasPrevious`, `hasNext`, `isVisible`, and the `onPrev` / `onNext` / `onDone` callbacks — no need to manage your own focus listeners.

### Dynamic focus node lists

If the set of fields changes at runtime (e.g. ft/in vs cm), just pass the updated list. `KeyboardAccessoryHost` migrates listeners automatically in `didUpdateWidget`:

```dart
KeyboardAccessoryHost(
  focusNodes: isFeet ? [ftFocus, inFocus] : [cmFocus],
  onDone: widget.onDone,
  child: HeightInputRow(),
)
```

## API reference

| Class | Role |
|---|---|
| `KeyboardAccessoryHost` | Main widget — wrap your form with this |
| `KeyboardAccessoryBarContext` | Focus state passed to `barBuilder` |
| `KeyboardAccessoryTheme` | Visual configuration (glass, colours, sizing) |
| `KeyboardAccessoryAction` | A single toolbar button; `KeyboardAccessoryAction.spacer` for gaps |
| `KeyboardAccessoryScope` | `InheritedWidget` for app-level theme defaults |

`KeyboardAccessoryTheme.defaultHeight` (44.0) is the static constant to use for bottom padding inside scrollable content.
