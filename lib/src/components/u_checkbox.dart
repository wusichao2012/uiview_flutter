import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// 复选框选项。
class UCheckboxOption<T> {
  final String label;
  final T value;
  const UCheckboxOption(this.label, this.value);
}

/// uView `Checkbox` 复选框（单个，受控）。
class UCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final Widget? labelChild;
  final UViewType type;
  final bool disabled;
  final bool circle;

  const UCheckbox({
    Key? key,
    required this.value,
    this.onChanged,
    this.label,
    this.labelChild,
    this.type = UViewType.primary,
    this.disabled = false,
    this.circle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final accent = theme.colorOf(type == UViewType.def ? UViewType.info : type);
    final canTap = !disabled && onChanged != null;
    final boxSize = 20.0;

    final box = Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: value ? accent : theme.surfaceColor,
        borderRadius: BorderRadius.circular(circle ? boxSize / 2 : 4),
        border: Border.all(color: value ? accent : theme.borderColor, width: 1),
      ),
      child: value
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );

    final labelWidget = labelChild ?? (label != null ? UText(label!, size: 14) : null);

    return GestureDetector(
      onTap: canTap ? () => onChanged!(!value) : null,
      behavior: HitTestBehavior.translucent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          box,
          if (labelWidget != null) ...[
            const SizedBox(width: 6),
            labelWidget,
          ],
        ],
      ),
    );
  }
}

/// uView `Checkbox` 复选框组（多选）。
class UCheckboxGroup<T> extends StatelessWidget {
  final List<UCheckboxOption<T>> options;
  final List<T> value;
  final ValueChanged<List<T>>? onChanged;
  final UViewType type;
  final bool disabled;
  final bool circle;
  final Axis direction;

  const UCheckboxGroup({
    Key? key,
    required this.options,
    required this.value,
    this.onChanged,
    this.type = UViewType.primary,
    this.disabled = false,
    this.circle = false,
    this.direction = Axis.vertical,
  }) : super(key: key);

  void _toggle(T v) {
    if (disabled || onChanged == null) return;
    final next = List<T>.from(value);
    if (next.contains(v)) {
      next.remove(v);
    } else {
      next.add(v);
    }
    onChanged!(next);
  }

  @override
  Widget build(BuildContext context) {
    final children = options
        .map((o) => UCheckbox(
              value: value.contains(o.value),
              onChanged: (_) => _toggle(o.value),
              label: o.label,
              type: type,
              disabled: disabled,
              circle: circle,
            ))
        .toList();
    if (direction == Axis.horizontal) {
      return Wrap(spacing: 16, runSpacing: 8, children: children);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}
