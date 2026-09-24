import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// uView `Keyboard` 自定义数字键盘（用于金额 / 密码等输入场景）。
class UKeyboard extends StatelessWidget {
  final ValueChanged<String>? onKey;
  final VoidCallback? onDelete;
  final VoidCallback? onConfirm;
  final String confirmText;
  final bool showConfirm;
  final UViewType? type;

  const UKeyboard({
    Key? key,
    this.onKey,
    this.onDelete,
    this.onConfirm,
    this.confirmText = '完成',
    this.showConfirm = true,
    this.type,
  }) : super(key: key);

  /// 底部弹出数字键盘。
  static Future<void> show(
    BuildContext context, {
    ValueChanged<String>? onKey,
    VoidCallback? onDelete,
    VoidCallback? onConfirm,
    String confirmText = '完成',
    bool showConfirm = true,
    UViewType? type,
  }) {
    final theme = UView.of(context);
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.backgroundColor,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: UKeyboard(
          onKey: onKey,
          onDelete: onDelete,
          onConfirm: onConfirm,
          confirmText: confirmText,
          showConfirm: showConfirm,
          type: type,
        ),
      ),
    );
  }

  Widget _tile(UViewThemeData theme, String label, {bool isAction = false}) {
    final accent = theme.colorOf(type ?? UViewType.primary);
    return Expanded(
      child: InkWell(
        onTap: () {
          if (label == 'del') {
            onDelete?.call();
          } else if (label == '.') {
            onKey?.call('.');
          } else {
            onKey?.call(label);
          }
        },
        child: Container(
          height: 52,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isAction ? accent : theme.surfaceColor,
            borderRadius: BorderRadius.circular(theme.radiusSm),
          ),
          child: Center(
            child: label == 'del'
                ? Icon(Icons.backspace_outlined, color: theme.contentTextColor)
                : UText(
                    label,
                    size: 20,
                    bold: true,
                    color: isAction ? theme.inverseTextColor : theme.mainTextColor,
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'del', '0', '.'];
    return Material(
      color: theme.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: keys.map((k) => _tile(theme, k)).toList(),
          ),
          if (showConfirm)
            SizedBox(
              width: double.infinity,
              child: InkWell(
                onTap: onConfirm,
                child: Container(
                  height: 50,
                  color: theme.colorOf(type ?? UViewType.primary),
                  child: Center(
                    child: UText(confirmText, color: theme.inverseTextColor, bold: true),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
