import 'package:flutter/material.dart';

import 'keyboard_accessory_action.dart';
import 'keyboard_accessory_bar.dart';
import 'keyboard_accessory_scope.dart';
import 'keyboard_accessory_theme.dart';

@immutable
class KeyboardAccessoryBarContext {
  const KeyboardAccessoryBarContext({
    required this.focusedIndex,
    required this.totalCount,
    required this.onPrev,
    required this.onNext,
    required this.onDone,
  });

  final int focusedIndex;
  final int totalCount;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onDone;

  bool get hasPrevious => focusedIndex > 0;
  bool get hasNext => focusedIndex >= 0 && focusedIndex < totalCount - 1;
  bool get isVisible => focusedIndex >= 0;
}

class KeyboardAccessoryHost extends StatefulWidget {
  const KeyboardAccessoryHost({
    super.key,
    required this.focusNodes,
    required this.child,
    this.onDone,
    this.actions,
    this.theme,
    this.barBuilder,
  });

  final List<FocusNode> focusNodes;
  final Widget child;
  final VoidCallback? onDone;

  final List<KeyboardAccessoryAction>? actions;
  final KeyboardAccessoryTheme? theme;
  final Widget Function(BuildContext context, KeyboardAccessoryBarContext ctx)?
      barBuilder;

  @override
  State<KeyboardAccessoryHost> createState() => _KeyboardAccessoryHostState();
}

class _KeyboardAccessoryHostState extends State<KeyboardAccessoryHost> {
  int _focusedIndex = -1;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    for (final node in widget.focusNodes) {
      node.addListener(_onFocusChanged);
    }
  }

  @override
  void didUpdateWidget(covariant KeyboardAccessoryHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_listEquals(oldWidget.focusNodes, widget.focusNodes)) {
      for (final node in oldWidget.focusNodes) {
        node.removeListener(_onFocusChanged);
      }
      for (final node in widget.focusNodes) {
        node.addListener(_onFocusChanged);
      }
      _onFocusChanged();
    }
    // Rebuild the overlay whenever any prop that affects the bar changes.
    // focusNodes are already handled above via _onFocusChanged.
    // Deferred to post-frame because didUpdateWidget fires during a build.
    if (_overlayEntry != null &&
        (oldWidget.actions != widget.actions ||
            oldWidget.theme != widget.theme ||
            oldWidget.barBuilder != widget.barBuilder ||
            oldWidget.onDone != widget.onDone)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    }
  }

  @override
  void dispose() {
    for (final node in widget.focusNodes) {
      node.removeListener(_onFocusChanged);
    }
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    final newIndex = widget.focusNodes.indexWhere((node) => node.hasFocus);
    if (newIndex == _focusedIndex) return;
    _focusedIndex = newIndex;
    _updateOverlay();
  }

  void _focusPrev() {
    if (_focusedIndex <= 0) return;
    widget.focusNodes[_focusedIndex - 1].requestFocus();
  }

  void _focusNext() {
    if (_focusedIndex < 0 || _focusedIndex >= widget.focusNodes.length - 1) {
      return;
    }
    widget.focusNodes[_focusedIndex + 1].requestFocus();
  }

  void _dismiss() {
    widget.onDone?.call();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  KeyboardAccessoryBarContext _buildBarContext() {
    return KeyboardAccessoryBarContext(
      focusedIndex: _focusedIndex,
      totalCount: widget.focusNodes.length,
      onPrev: _focusPrev,
      onNext: _focusNext,
      onDone: _dismiss,
    );
  }

  void _updateOverlay() {
    final visible = _focusedIndex >= 0;
    if (!visible) {
      _removeOverlay();
      return;
    }
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: _buildOverlay);
      Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    } else {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildOverlay(BuildContext context) {
    if (widget.barBuilder != null) {
      return Stack(children: [widget.barBuilder!(context, _buildBarContext())]);
    }

    final resolvedTheme = widget.theme ??
        KeyboardAccessoryScope.maybeOf(context) ??
        const KeyboardAccessoryTheme();

    return Stack(
      children: [
        KeyboardAccessoryBar(
          visible: _focusedIndex >= 0,
          hasPrevious: _focusedIndex > 0,
          hasNext: _focusedIndex >= 0 &&
              _focusedIndex < widget.focusNodes.length - 1,
          onPrev: _focusPrev,
          onNext: _focusNext,
          onDone: _dismiss,
          actions: widget.actions,
          theme: resolvedTheme,
        ),
      ],
    );
  }

  bool _listEquals(List<FocusNode> a, List<FocusNode> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!identical(a[i], b[i])) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
