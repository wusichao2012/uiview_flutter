import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// 单选框选项。
class URadioOption<T> {
  final String label;
  final T value;
  const URadioOption(this.label, this.value);
}

/// uView `Radio` 单选框（单个，受控）。
class URadio extends StatelessWidget {
  final bool checked;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final Widget? labelChild;
  final UViewType type;
  final bool disabled;
  final bool circle;

  const URadio({
    Key? key,
    required this.checked,
    this.onChanged,
    this.label,
    this.labelChild,
    this.type = UViewType.primary,
    this.disabled = false,
    this.circle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final accent = theme.colorOf(type == UViewType.def ? UViewType.info : type);
    final canTap = !disabled && onChanged != null;
    const dot = 20.0;

    final box = Container(
      width: dot,
      height: dot,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.surfaceColor,
        border: Border.all(color: checked ? accent : theme.borderColor, width: 1),
      ),
      child: checked
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(shape: BoxShape.circle, color: accent),
              ),
            )
          : null,
    );

    final labelWidget = labelChild ?? (label != null ? UText(label!, size: 14) : null);

    return GestureDetector(
      onTap: canTap ? () => onChanged!(true) : null,
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

/// uView `Radio` 单选框组（单选）。
class URadioGroup<T> extends StatelessWidget {
  final List<URadioOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final UViewType type;
  final bool disabled;
  final Axis direction;

  const URadioGroup({
    Key? key,
    required this.options,
    required this.value,
    this.onChanged,
    this.type = UViewType.primary,
    this.disabled = false,
    this.direction = Axis.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = options
        .map((o) => URadio(
              checked: value == o.value,
              onChanged: (_) => onChanged?.call(o.value),
              label: o.label,
              type: type,
              disabled: disabled,
            ))
        .toList();
    if (direction == Axis.horizontal) {
      return Wrap(spacing: 16, runSpacing: 8, children: children);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}
