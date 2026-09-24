import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../components/u_text.dart';

/// 选择器选项。
class USelectOption<T> {
  final String label;
  final T value;
  const USelectOption(this.label, this.value);
}

/// uView `Select` 列选择器（底部弹窗列表选择）。
class USelect<T> extends StatelessWidget {
  final T? value;
  final List<USelectOption<T>> options;
  final ValueChanged<T>? onChanged;
  final String? placeholder;
  final String? title;

  const USelect({
    Key? key,
    this.value,
    required this.options,
    this.onChanged,
    this.placeholder,
    this.title,
  }) : super(key: key);

  void _open(BuildContext context) {
    final theme = UView.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(theme.radiusLg)),
      ),
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: UText(title!, bold: true, size: 16),
              ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: options
                    .map(
                      (o) => ListTile(
                        title: UText(o.label, size: 15),
                        trailing: value == o.value
                            ? Icon(Icons.check, color: theme.primaryColor)
                            : null,
                        onTap: () {
                          Navigator.pop(c);
                          onChanged?.call(o.value);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    String? matchedLabel;
    for (final o in options) {
      if (o.value == value) {
        matchedLabel = o.label;
        break;
      }
    }
    final text = matchedLabel ?? placeholder ?? '请选择';
    final isPlaceholder = matchedLabel == null;

    return GestureDetector(
      onTap: () => _open(context),
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          Expanded(
            child: UText(
              text,
              color: isPlaceholder ? theme.lightTextColor : theme.mainTextColor,
            ),
          ),
          Icon(Icons.arrow_drop_down, color: theme.lightTextColor),
        ],
      ),
    );
  }
}
