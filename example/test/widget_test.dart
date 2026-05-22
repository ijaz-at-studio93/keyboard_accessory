import 'package:flutter_test/flutter_test.dart';
import 'package:keyboard_accessory_example/main.dart';

void main() {
  testWidgets('example app smoke test', (tester) async {
    await tester.pumpWidget(const ExampleApp());
    expect(find.text('keyboard_accessory'), findsOneWidget);
  });
}
