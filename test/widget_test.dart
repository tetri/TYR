import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyr/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(const TYR());

    // Verify that TYR is present.
    expect(find.byType(TYR), findsOneWidget);
  });
}
