import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camaroo/main.dart';

void main() {
  testWidgets('App should launch without errors', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const CamarooApp());
    
    // Verify that the app initializes
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Bottom navigation should have three tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const CamarooApp());
    await tester.pumpAndSettle();
    
    // Verify bottom navigation items
    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
