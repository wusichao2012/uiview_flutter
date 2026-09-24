import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';

/// uView `Switch` 开关选择器。
class USwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final UViewType type;
  final bool disabled;
  final double size;

  const USwitch({
    Key? key,
    required this.value,
    this.onChanged,
    this.type = UViewType.primary,
    this.disabled = false,
    this.size = 26,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final accent = theme.colorOf(type == UViewType.def ? UViewType.info : type);
    return SizedBox(
      width: size * 1.8,
      height: size,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Switch(
          value: value,
          onChanged: disabled ? null : onChanged,
          activeColor: accent,
          inactiveThumbColor: theme.surfaceColor,
          inactiveTrackColor: theme.borderColor,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
