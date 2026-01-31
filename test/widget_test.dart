import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyr/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We use a simple test that just ensures the app can build its initial widget.
    await tester.pumpWidget(const TYR());

    // Since the initial route is Splash which returns a Placeholder
    expect(find.byType(Placeholder), findsOneWidget);
  });
}
