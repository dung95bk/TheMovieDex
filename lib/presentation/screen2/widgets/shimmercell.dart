import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';

class ShimmerCell extends StatelessWidget {
  const ShimmerCell(this.width, this.height, this.borderRadius,
      {Key key,
      this.margin = EdgeInsets.zero,
      this.baseColor,
      this.highlightColor})
      : super(key: key);

  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry margin;
  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);

    return Shimmer.fromColors(
      baseColor: AppTheme.bottomNavigationBarBackground_light,
      highlightColor: AppTheme.bottomNavigationBarBackgroundt,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.grey[200],
        ),
      ),
    );
  }
}
