// Basic widget test for Student Record App

import 'package:flutter_test/flutter_test.dart';

import 'package:student_record_app/main.dart';

void main() {
  testWidgets('App should display Student App title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('Student App'), findsOneWidget);
  });
}
