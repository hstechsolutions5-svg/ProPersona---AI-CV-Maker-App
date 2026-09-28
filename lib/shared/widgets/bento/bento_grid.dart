import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/responsive/responsive_builder.dart';
import '../../../core/responsive/responsive_value.dart';
import 'bento_tile.dart';

class BentoGrid extends StatelessWidget {
  const BentoGrid({
    required this.tiles,
    super.key,
    this.spacing = 16,
    this.padding = EdgeInsets.zero,
  });

  final List<BentoTile> tiles;

  final double spacing;

  final EdgeInsetsGeometry padding;

  static const ResponsiveValue<int> _columns = ResponsiveValue<int>(
    mobile: 1,
    tablet: 2,
    desktop: 4,
  );

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        final columnCount = _columns.resolve(deviceType);

        return Padding(
          padding: padding,
          child: StaggeredGrid.count(
            crossAxisCount: columnCount,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            children: tiles.map((tile) {
              final span = tile.span.resolve(deviceType).clamp(1, columnCount);

              return StaggeredGridTile.count(
                crossAxisCellCount: span,
                mainAxisCellCount: tile.heightUnits,
                child: tile.child,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
