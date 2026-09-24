import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';

/// uView `Loading` 加载动画组件（圆环 spinner）。
class ULoading extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;
  final bool show;
  final UViewType? type;

  const ULoading({
    Key? key,
    this.size = 24,
    this.strokeWidth = 2.5,
    this.color,
    this.show = true,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();
    final theme = UView.of(context);
    final resolved = color ??
        (type != null && type != UViewType.def ? theme.colorOf(type!) : theme.primaryColor);
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(resolved),
      ),
    );
  }
}
