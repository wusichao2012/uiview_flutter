import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import 'u_input.dart';
import 'u_button.dart';

/// uView `Search` 搜索框。
///
/// 内置搜索图标与清空；[showAction] 时右侧出现“搜索”按钮，点击或回车触发 [onSearch]。
class USearch extends StatefulWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSearch;
  final bool showAction;
  final String actionText;

  const USearch({
    Key? key,
    this.placeholder,
    this.controller,
    this.onChanged,
    this.onSearch,
    this.showAction = true,
    this.actionText = '搜索',
  }) : super(key: key);

  @override
  State<USearch> createState() => _USearchState();
}

class _USearchState extends State<USearch> {
  late TextEditingController _c;

  @override
  void initState() {
    super.initState();
    _c = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final input = UInput(
      controller: _c,
      placeholder: widget.placeholder ?? '搜索',
      prefixIcon: Icon(Icons.search, color: theme.lightTextColor, size: 18),
      clearable: true,
      onChanged: widget.onChanged,
      textInputAction: widget.showAction ? TextInputAction.search : TextInputAction.done,
      onSubmitted: (v) => widget.onSearch?.call(v),
    );

    if (!widget.showAction) return input;
    return Row(
      children: [
        Expanded(child: input),
        const SizedBox(width: 8),
        UButton(
          text: widget.actionText,
          size: UViewSize.small,
          onPressed: () => widget.onSearch?.call(_c.text),
        ),
      ],
    );
  }
}
