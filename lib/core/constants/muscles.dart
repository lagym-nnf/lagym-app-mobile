/// Canonical muscle-group slugs stored in exercises.target_muscles by the
/// admin app. Each slug maps 1:1 to a highlightable region in
/// assets/images/body_map_front.svg / body_map_back.svg.
class Muscles {
  Muscles._();

  /// Fill color of un-highlighted muscle regions in the body map SVGs.
  /// Must match the fill attribute written in the SVG files exactly.
  static const String bodyMapBaseColor = '#C7CDEB';

  /// Fill color applied to highlighted (worked) muscle regions.
  static const String bodyMapHighlightColor = '#F08A76';

  static const Map<String, String> labels = {
    'chest': 'Chest',
    'shoulders': 'Shoulders',
    'traps': 'Traps',
    'lats': 'Lats',
    'lower_back': 'Lower Back',
    'biceps': 'Biceps',
    'triceps': 'Triceps',
    'forearms': 'Forearms',
    'abs': 'Abs',
    'glutes': 'Glutes',
    'quads': 'Quads',
    'hamstrings': 'Hamstrings',
    'calves': 'Calves',
  };

  static String label(String slug) => labels[slug] ?? slug;
}
