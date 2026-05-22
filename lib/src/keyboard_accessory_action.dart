import 'package:flutter/material.dart';

@immutable
class KeyboardAccessoryAction {
  const KeyboardAccessoryAction({
    required this.icon,
    this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  bool get isSpacer => this is _SpacerAction;

  static const spacer = _SpacerAction();
}

class _SpacerAction extends KeyboardAccessoryAction {
  const _SpacerAction() : super(icon: Icons.abc, onPressed: null);
}
