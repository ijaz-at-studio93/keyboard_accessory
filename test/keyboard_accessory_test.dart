import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyboard_accessory/keyboard_accessory.dart';

Widget _wrap({
  required List<FocusNode> focusNodes,
  VoidCallback? onDone,
  List<KeyboardAccessoryAction>? actions,
  KeyboardAccessoryTheme? theme,
  Widget Function(KeyboardAccessoryBarContext)? barBuilder,
}) {
  return MaterialApp(
    home: Scaffold(
      body: KeyboardAccessoryHost(
        focusNodes: focusNodes,
        onDone: onDone,
        actions: actions,
        theme: theme,
        barBuilder: barBuilder,
        child: Column(
          children: focusNodes
              .map((fn) => TextField(focusNode: fn))
              .toList(),
        ),
      ),
    ),
  );
}

void main() {
  group('KeyboardAccessoryTheme', () {
    test('defaultHeight is 44', () {
      expect(KeyboardAccessoryTheme.defaultHeight, 44.0);
    });

    test('equality holds for identical params', () {
      const a = KeyboardAccessoryTheme(height: 50, blurSigma: 16);
      const b = KeyboardAccessoryTheme(height: 50, blurSigma: 16);
      expect(a, equals(b));
    });

    test('copyWith overrides single field', () {
      const base = KeyboardAccessoryTheme(height: 44);
      final copy = base.copyWith(height: 52);
      expect(copy.height, 52);
      expect(copy.blurSigma, base.blurSigma);
    });
  });

  group('KeyboardAccessoryAction', () {
    test('spacer.isSpacer is true', () {
      expect(KeyboardAccessoryAction.spacer.isSpacer, isTrue);
    });

    test('regular action.isSpacer is false', () {
      const action = KeyboardAccessoryAction(
        icon: Icons.search,
        onPressed: null,
      );
      expect(action.isSpacer, isFalse);
    });
  });

  group('KeyboardAccessoryHost', () {
    testWidgets('bar hidden when no keyboard inset', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(_wrap(focusNodes: [node]));

      // Simulate focus without keyboard
      await tester.tap(find.byType(TextField).first);
      await tester.pump();

      final bar = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity).last,
      );
      expect(bar.opacity, 0.0);
    });

    testWidgets('bar visible when keyboard inset is present', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);

      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);

      await tester.pumpWidget(_wrap(focusNodes: [node]));

      await tester.tap(find.byType(TextField).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      final bar = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity).last,
      );
      expect(bar.opacity, 1.0);
    });

    testWidgets('default row shows prev/next/done icons', (tester) async {
      final a = FocusNode();
      final b = FocusNode();
      addTearDown(a.dispose);
      addTearDown(b.dispose);

      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);

      await tester.pumpWidget(_wrap(focusNodes: [a, b]));
      await tester.tap(find.byType(TextField).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
      expect(find.byIcon(Icons.done_rounded), findsOneWidget);
    });

    testWidgets('onDone callback fires on dismiss', (tester) async {
      var called = false;
      final node = FocusNode();
      addTearDown(node.dispose);

      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);

      await tester.pumpWidget(_wrap(
        focusNodes: [node],
        onDone: () => called = true,
      ));
      await tester.tap(find.byType(TextField).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.byIcon(Icons.done_rounded));
      expect(called, isTrue);
    });

    testWidgets('custom actions replace default row', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      var searchTapped = false;

      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);

      await tester.pumpWidget(_wrap(
        focusNodes: [node],
        actions: [
          KeyboardAccessoryAction.spacer,
          KeyboardAccessoryAction(
            icon: Icons.search,
            onPressed: () => searchTapped = true,
          ),
        ],
      ));
      await tester.tap(find.byType(TextField).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsNothing);
      expect(find.byIcon(Icons.search), findsOneWidget);
      await tester.tap(find.byIcon(Icons.search));
      expect(searchTapped, isTrue);
    });

    testWidgets('didUpdateWidget re-subscribes on focusNodes change',
        (tester) async {
      final a = FocusNode();
      final b = FocusNode();
      addTearDown(a.dispose);
      addTearDown(b.dispose);

      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);

      final notifier = ValueNotifier(true);
      addTearDown(notifier.dispose);

      await tester.pumpWidget(
        ValueListenableBuilder<bool>(
          valueListenable: notifier,
          builder: (_, useA, __) => _wrap(focusNodes: useA ? [a] : [b]),
        ),
      );

      await tester.tap(find.byType(TextField).first);
      await tester.pump();

      // Switch focus node list to [b].
      notifier.value = false;
      await tester.pump();

      // Tapping the (now only) TextField focuses b.
      await tester.tap(find.byType(TextField).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      final bar = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity).last,
      );
      expect(bar.opacity, 1.0);
    });

    testWidgets('barBuilder receives correct context', (tester) async {
      final a = FocusNode();
      final b = FocusNode();
      addTearDown(a.dispose);
      addTearDown(b.dispose);

      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);

      KeyboardAccessoryBarContext? capturedCtx;

      await tester.pumpWidget(_wrap(
        focusNodes: [a, b],
        barBuilder: (ctx) {
          capturedCtx = ctx;
          return const SizedBox.shrink();
        },
      ));

      await tester.tap(find.byType(TextField).first);
      await tester.pump();

      expect(capturedCtx, isNotNull);
      expect(capturedCtx!.focusedIndex, 0);
      expect(capturedCtx!.hasPrevious, isFalse);
      expect(capturedCtx!.hasNext, isTrue);
    });
  });

  group('KeyboardAccessoryScope', () {
    testWidgets('maybeOf returns null when no scope', (tester) async {
      late KeyboardAccessoryTheme? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = KeyboardAccessoryScope.maybeOf(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(result, isNull);
    });

    testWidgets('maybeOf returns theme when scope present', (tester) async {
      const theme = KeyboardAccessoryTheme(height: 55);
      late KeyboardAccessoryTheme? result;

      await tester.pumpWidget(
        KeyboardAccessoryScope(
          theme: theme,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = KeyboardAccessoryScope.maybeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(result, equals(theme));
    });
  });
}
