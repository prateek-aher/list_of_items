import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_of_items/main.dart';

void main() {
  testWidgets(
    "App Smoke Test",
    (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      // Verify App title is present
      expect(find.text("Item List Manager"), findsOneWidget);
      // Verify search field is present
      expect(find.byIcon(Icons.search), findsOneWidget);
      // Verify Add button is present
      expect(find.byType(FloatingActionButton), findsOneWidget);
    },
  );
}
