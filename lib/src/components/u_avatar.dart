import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';

/// uView `Avatar` 头像（圆形 / 方形，支持图片或文字/图标占位）。
class UAvatar extends StatelessWidget {
  final String? src;
  final Widget? child;
  final double size;
  final UViewShape shape;
  final double radius;
  final BoxFit fit;
  final Color? backgroundColor;

  const UAvatar({
    Key? key,
    this.src,
    this.child,
    this.size = 48,
    this.shape = UViewShape.circle,
    this.radius = 8,
    this.fit = BoxFit.cover,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final r = shape == UViewShape.circle
        ? BorderRadius.circular(size / 2)
        : BorderRadius.circular(radius);
    final bg = backgroundColor ?? theme.backgroundColor;

    final inner = src != null
        ? Image.network(
            src!,
            fit: fit,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.person, size: size * 0.5, color: theme.lightTextColor),
          )
        : (child ??
            Icon(Icons.person, size: size * 0.5, color: theme.lightTextColor));

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: r,
        border: Border.all(color: theme.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: inner,
    );
  }
}
