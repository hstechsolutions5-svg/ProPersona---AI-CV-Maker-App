import 'package:flutter/widgets.dart';

import 'bento_span.dart';

class BentoTile {
  const BentoTile({
    required this.child,
    required this.span,
    this.heightUnits = 1,
  });

  final Widget child;

  final BentoSpan span;

  final int heightUnits;
}
