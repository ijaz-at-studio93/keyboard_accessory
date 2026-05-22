import 'package:flutter/widgets.dart';

import 'keyboard_accessory_theme.dart';

class KeyboardAccessoryScope extends InheritedWidget {
  const KeyboardAccessoryScope({
    super.key,
    required this.theme,
    required super.child,
  });

  final KeyboardAccessoryTheme theme;

  static KeyboardAccessoryTheme? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<KeyboardAccessoryScope>()
        ?.theme;
  }

  @override
  bool updateShouldNotify(KeyboardAccessoryScope oldWidget) =>
      theme != oldWidget.theme;
}
