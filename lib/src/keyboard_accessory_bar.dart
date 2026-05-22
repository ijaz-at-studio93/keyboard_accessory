import 'dart:ui';

import 'package:flutter/material.dart';

import 'keyboard_accessory_action.dart';
import 'keyboard_accessory_theme.dart';

class KeyboardAccessoryBar extends StatelessWidget {
  const KeyboardAccessoryBar({
    super.key,
    required this.visible,
    required this.hasPrevious,
    required this.hasNext,
    required this.onPrev,
    required this.onNext,
    required this.onDone,
    this.actions,
    this.theme = const KeyboardAccessoryTheme(),
  });

  final bool visible;
  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onDone;
  final List<KeyboardAccessoryAction>? actions;
  final KeyboardAccessoryTheme theme;

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final isKeyboardOpen = keyboardInset > 0;
    final shouldShow = visible && isKeyboardOpen;
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final glassTint = isDark
        ? (theme.darkGlassTint ?? Colors.white.withValues(alpha: 0.10))
        : (theme.lightGlassTint ?? Colors.white.withValues(alpha: 0.45));
    final borderColor = isDark
        ? (theme.darkBorderColor ?? Colors.white.withValues(alpha: 0.18))
        : (theme.lightBorderColor ?? Colors.white.withValues(alpha: 0.55));
    final highlightColor = isDark
        ? (theme.darkHighlightColor ?? Colors.white.withValues(alpha: 0.06))
        : (theme.lightHighlightColor ?? Colors.white.withValues(alpha: 0.35));
    final iconColor = isDark
        ? (theme.darkIconColor ?? Colors.white)
        : (theme.lightIconColor ?? Colors.black87);
    final disabledColor = iconColor.withValues(alpha: theme.disabledOpacity);
    final radius =
        theme.borderRadius ?? BorderRadius.circular(theme.height / 2);

    return AnimatedPositioned(
      duration: theme.showHideDuration,
      curve: theme.showHideCurve,
      left: theme.horizontalMargin,
      right: theme.horizontalMargin,
      bottom: shouldShow
          ? keyboardInset + theme.bottomGap
          : -(theme.height + theme.horizontalMargin * 2),
      child: IgnorePointer(
        ignoring: !shouldShow,
        child: AnimatedOpacity(
          duration: theme.fadeDuration,
          opacity: shouldShow ? 1 : 0,
          child: Material(
            color: Colors.transparent,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: ClipRRect(
              borderRadius: radius,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: theme.blurSigma,
                  sigmaY: theme.blurSigma,
                ),
                child: Container(
                  height: theme.height,
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    border: Border.all(color: borderColor, width: 0.5),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [highlightColor, glassTint],
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.horizontalPadding,
                  ),
                  child: Row(
                    children: actions != null
                        ? _buildCustomActions(
                            actions!, iconColor, disabledColor)
                        : _buildDefaultActions(iconColor, disabledColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDefaultActions(Color iconColor, Color disabledColor) {
    return [
      _AccessoryIconButton(
        icon: Icons.keyboard_arrow_up_rounded,
        color: hasPrevious ? iconColor : disabledColor,
        onTap: hasPrevious ? onPrev : null,
      ),
      _AccessoryIconButton(
        icon: Icons.keyboard_arrow_down_rounded,
        color: hasNext ? iconColor : disabledColor,
        onTap: hasNext ? onNext : null,
      ),
      const Spacer(),
      _AccessoryIconButton(
        icon: Icons.done_rounded,
        color: iconColor,
        onTap: onDone,
      ),
    ];
  }

  List<Widget> _buildCustomActions(
    List<KeyboardAccessoryAction> actions,
    Color iconColor,
    Color disabledColor,
  ) {
    return actions.map<Widget>((action) {
      if (action.isSpacer) return const Spacer();
      final enabled = action.onPressed != null;
      final button = _AccessoryIconButton(
        icon: action.icon,
        color: enabled ? iconColor : disabledColor,
        onTap: action.onPressed,
      );
      if (action.tooltip != null && action.tooltip!.isNotEmpty) {
        return Tooltip(message: action.tooltip!, child: button);
      }
      return button;
    }).toList();
  }
}

class _AccessoryIconButton extends StatelessWidget {
  const _AccessoryIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Icon(icon, color: color, size: 34),
      ),
    );
  }
}
