import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../components/u_text.dart';

/// uView `Dropdown` 下拉菜单（点击展开浮层选项列表，覆盖下方内容）。
class UDropdown extends StatefulWidget {
  final List<String> options;
  final int? value;
  final ValueChanged<int>? onChanged;
  final String? placeholder;
  final Widget? leading;

  const UDropdown({
    Key? key,
    required this.options,
    this.value,
    this.onChanged,
    this.placeholder,
    this.leading,
  }) : super(key: key);

  @override
  _UDropdownState createState() => _UDropdownState();
}

class _UDropdownState extends State<UDropdown> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final label = (widget.value != null && widget.value! < widget.options.length)
        ? widget.options[widget.value!]
        : (widget.placeholder ?? '请选择');
    final isPlaceholder = widget.value == null;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: theme.surfaceColor,
            border: Border(bottom: BorderSide(color: theme.borderColor)),
          ),
          child: GestureDetector(
            onTap: () => setState(() => _open = !_open),
            behavior: HitTestBehavior.translucent,
            child: Row(
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: UText(
                    label,
                    color: isPlaceholder
                        ? theme.lightTextColor
                        : theme.mainTextColor,
                  ),
                ),
                Icon(
                  _open ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: theme.lightTextColor,
                ),
              ],
            ),
          ),
        ),
        if (_open)
          Positioned(
            top: 44,
            left: 0,
            right: 0,
            child: Material(
              elevation: 4,
              color: theme.surfaceColor,
              child: Column(
                children: widget.options.asMap().entries.map((e) {
                  final selected = widget.value == e.key;
                  return InkWell(
                    onTap: () {
                      setState(() => _open = false);
                      widget.onChanged?.call(e.key);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: theme.borderColor),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: UText(
                              e.value,
                              color: selected
                                  ? theme.primaryColor
                                  : theme.mainTextColor,
                            ),
                          ),
                          if (selected)
                            Icon(Icons.check,
                                color: theme.primaryColor, size: 16),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}
