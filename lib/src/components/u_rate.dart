import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';

/// uView `Rate` 评分。
class URate extends StatelessWidget {
  final int count;
  final int value;
  final double size;
  final double gap;
  final UViewType type;
  final bool disabled;
  final ValueChanged<int>? onChanged;

  const URate({
    Key? key,
    this.count = 5,
    this.value = 0,
    this.size = 24,
    this.gap = 4,
    this.type = UViewType.warning,
    this.disabled = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final accent = theme.colorOf(type == UViewType.def ? UViewType.warning : type);
    final stars = <Widget>[];
    for (var i = 0; i < count; i++) {
      final filled = i < value;
      final star = GestureDetector(
        onTap: disabled || onChanged == null ? null : () => onChanged!(i + 1),
        child: Icon(
          filled ? Icons.star : Icons.star_border,
          size: size,
          color: filled ? accent : theme.lightTextColor,
        ),
      );
      stars.add(star);
      if (i < count - 1) stars.add(SizedBox(width: gap));
    }
    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}
