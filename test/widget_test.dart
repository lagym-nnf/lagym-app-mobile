// Basic Flutter widget test for LA GYM App

import 'package:flutter_test/flutter_test.dart';
import 'package:la_gym_app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App launches without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: LaGymApp(),
      ),
    );

    // Verify that the app loads
    expect(find.byType(LaGymApp), findsOneWidget);
  });
}
