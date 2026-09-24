import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../theme/uview.dart';
import '../components/u_text.dart';

/// uView `Picker` 滚轮选择器（底部弹窗，多列非联动）。
class UPicker {
  const UPicker._();

  /// 弹出多列滚轮选择器。
  ///
  /// [columns] 每列的可选项文本；[initialIndexes] 每列初始选中索引。
  /// 返回各列选中索引 [List<int>]，用户取消时返回 null。
  static Future<List<int>?> show(
    BuildContext context, {
    required List<List<String>> columns,
    List<int>? initialIndexes,
    String? title,
    String confirmText = '确定',
    String cancelText = '取消',
  }) {
    if (columns.isEmpty) return Future.value(null);
    final theme = UView.of(context);
    return showModalBottomSheet<List<int>>(
      context: context,
      backgroundColor: theme.surfaceColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(theme.radiusLg)),
      ),
      builder: (_) => _PickerSheet(
        columns: columns,
        initialIndexes: initialIndexes,
        title: title,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }
}

class _PickerSheet extends StatefulWidget {
  final List<List<String>> columns;
  final List<int>? initialIndexes;
  final String? title;
  final String confirmText;
  final String cancelText;

  const _PickerSheet({
    required this.columns,
    this.initialIndexes,
    this.title,
    this.confirmText = '确定',
    this.cancelText = '取消',
  });

  @override
  _PickerSheetState createState() => _PickerSheetState();
}

class _PickerSheetState extends State<_PickerSheet> {
  late List<int> _selected;
  late List<FixedExtentScrollController> _controllers;

  @override
  void initState() {
    super.initState();
    _selected = List<int>.generate(widget.columns.length, (i) {
      final init = (widget.initialIndexes != null && i < widget.initialIndexes!.length)
          ? widget.initialIndexes![i]
          : 0;
      final max = widget.columns[i].length - 1;
      if (init < 0) return 0;
      if (init > max) return max;
      return init;
    });
    _controllers = List.generate(
      widget.columns.length,
      (i) => FixedExtentScrollController(initialItem: _selected[i]),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.borderColor)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.translucent,
                  child: UText(widget.cancelText, color: theme.tipsTextColor),
                ),
                Expanded(
                  child: Center(
                    child: widget.title != null
                        ? UText(widget.title!, bold: true, size: 16)
                        : const SizedBox.shrink(),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context, List<int>.from(_selected)),
                  behavior: HitTestBehavior.translucent,
                  child: UText(widget.confirmText, color: theme.primaryColor, bold: true),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: Row(
              children: List.generate(widget.columns.length, (col) {
                return Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: _controllers[col],
                    onSelectedItemChanged: (i) => setState(() => _selected[col] = i),
                    children: widget.columns[col]
                        .map((e) => Center(child: UText(e, size: 16)))
                        .toList(),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// uView `Picker` 的表单触发组件：点击弹出滚轮选择器，显示已选文本。
class UPickerField extends StatefulWidget {
  final List<List<String>> columns;
  final List<int>? valueIndexes;
  final ValueChanged<List<int>?>? onChanged;
  final String? title;
  final String placeholder;
  final String Function(List<int> indexes)? formatter;

  const UPickerField({
    Key? key,
    required this.columns,
    this.valueIndexes,
    this.onChanged,
    this.title,
    this.placeholder = '请选择',
    this.formatter,
  }) : super(key: key);

  @override
  _UPickerFieldState createState() => _UPickerFieldState();
}

class _UPickerFieldState extends State<UPickerField> {
  List<int>? _idx;

  @override
  void initState() {
    super.initState();
    _idx = widget.valueIndexes;
  }

  String _display() {
    if (_idx == null) return widget.placeholder;
    if (widget.formatter != null) return widget.formatter!(_idx!);
    final sb = <String>[];
    for (int i = 0; i < widget.columns.length; i++) {
      final ix = (i < _idx!.length) ? _idx![i] : 0;
      if (ix >= 0 && ix < widget.columns[i].length) {
        sb.add(widget.columns[i][ix]);
      }
    }
    return sb.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final isPlaceholder = _idx == null;
    return GestureDetector(
      onTap: () async {
        final r = await UPicker.show(
          context,
          columns: widget.columns,
          initialIndexes: _idx,
          title: widget.title,
        );
        if (r != null) {
          setState(() => _idx = r);
          widget.onChanged?.call(r);
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          Expanded(
            child: UText(
              _display(),
              color: isPlaceholder ? theme.lightTextColor : theme.mainTextColor,
            ),
          ),
          Icon(Icons.arrow_drop_down, color: theme.lightTextColor),
        ],
      ),
    );
  }
}
