import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:la_gym_app/core/constants/muscles.dart';
import 'package:la_gym_app/presentation/widgets/workouts/body_map.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every muscle slug has a highlightable region in the SVG assets', () async {
    final front =
        await rootBundle.loadString('assets/images/body_map_front.svg');
    final back = await rootBundle.loadString('assets/images/body_map_back.svg');
    final combined = front + back;

    for (final slug in Muscles.labels.keys) {
      expect(
        combined.contains('id="$slug" fill="${Muscles.bodyMapBaseColor}"'),
        isTrue,
        reason: 'slug $slug missing from body map SVGs',
      );
    }
  });

  testWidgets('BodyMap renders both figures with highlights', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BodyMap(highlighted: {'chest', 'biceps', 'glutes'}),
          ),
        ),
      );
      // Let the asset futures and SVG parsing complete on the real event loop
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await tester.pump();
    });

    expect(find.byType(SvgPicture), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
