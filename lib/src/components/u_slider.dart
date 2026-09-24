import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';

/// uView `Slider` 滑动选择器。
class USlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final UViewType type;
  final ValueChanged<double>? onChanged;

  const USlider({
    Key? key,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.label,
    this.type = UViewType.primary,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final accent = theme.colorOf(type == UViewType.def ? UViewType.info : type);
    return Slider(
      value: value,
      min: min,
      max: max,
      divisions: divisions,
      label: label,
      activeColor: accent,
      inactiveColor: theme.borderColor,
      onChanged: onChanged,
    );
  }
}
