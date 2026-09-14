import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/muscles.dart';

/// Front + back anatomical figures with the given muscle groups highlighted.
///
/// The SVG assets paint every muscle region with [Muscles.bodyMapBaseColor];
/// highlighting swaps that fill to [Muscles.bodyMapHighlightColor] on the
/// `id="<slug>"` group before rendering.
class BodyMap extends StatelessWidget {
  final Set<String> highlighted;
  final double height;

  const BodyMap({
    super.key,
    required this.highlighted,
    this.height = 230,
  });

  static const _frontAsset = 'assets/images/body_map_front.svg';
  static const _backAsset = 'assets/images/body_map_back.svg';

  static final Map<String, Future<String>> _svgCache = {};

  static Future<String> _load(String asset) =>
      _svgCache.putIfAbsent(asset, () => rootBundle.loadString(asset));

  String _applyHighlights(String svg) {
    var out = svg;
    for (final slug in highlighted) {
      out = out.replaceAll(
        'id="$slug" fill="${Muscles.bodyMapBaseColor}"',
        'id="$slug" fill="${Muscles.bodyMapHighlightColor}"',
      );
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: Future.wait([_load(_frontAsset), _load(_backAsset)]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(height: height);
        }
        final front = _applyHighlights(snapshot.data![0]);
        final back = _applyHighlights(snapshot.data![1]);
        return SizedBox(
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.string(front, height: height),
              const SizedBox(width: 16),
              SvgPicture.string(back, height: height),
            ],
          ),
        );
      },
    );
  }
}
