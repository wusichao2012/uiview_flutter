import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';

/// uView `Skeleton` 骨架屏占位块（带闪烁动画）。
class USkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final UViewShape shape;
  final double radius;
  final EdgeInsetsGeometry? margin;
  final bool animate;

  const USkeleton({
    Key? key,
    this.width,
    this.height = 14,
    this.shape = UViewShape.square,
    this.radius = 6,
    this.margin,
    this.animate = true,
  }) : super(key: key);

  @override
  _USkeletonState createState() => _USkeletonState();
}

class _USkeletonState extends State<USkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.animate) _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final sizeForRadius = widget.width ?? widget.height ?? 14;
    final r = widget.shape == UViewShape.circle
        ? BorderRadius.circular(sizeForRadius / 2)
        : BorderRadius.circular(widget.radius);

    if (!widget.animate) {
      return Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        decoration: BoxDecoration(color: theme.backgroundColor, borderRadius: r),
      );
    }

    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final color = Color.lerp(theme.backgroundColor, theme.borderColor, _c.value)!;
        return Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(color: color, borderRadius: r),
        );
      },
    );
  }
}
