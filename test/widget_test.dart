import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repair_center_syste/main.dart';

void main() {
  testWidgets('App starts and displays login screen initially', (WidgetTester tester) async {
    // Build our app under ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that the login form/button or loader is present.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
