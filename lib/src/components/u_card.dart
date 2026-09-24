import 'package:flutter/material.dart';
import '../theme/uview.dart';

/// uView `Card` 卡片容器。
class UCard extends StatelessWidget {
  final Widget? title;
  final Widget? extra;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final bool shadow;
  final Color? color;

  const UCard({
    Key? key,
    this.title,
    this.extra,
    this.child,
    this.padding,
    this.radius = 12,
    this.shadow = true,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final header = (title != null || extra != null)
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.borderColor)),
            ),
            child: Row(
              children: [
                Expanded(child: title ?? const SizedBox.shrink()),
                if (extra != null) extra!,
              ],
            ),
          )
        : null;
    return Container(
      decoration: BoxDecoration(
        color: color ?? theme.surfaceColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: theme.maskColor.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) header,
          if (child != null)
            Padding(padding: padding ?? const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}
