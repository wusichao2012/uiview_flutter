import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// uView `ActionSheet` 底部操作菜单。
class UActionSheet {
  const UActionSheet._();

  /// 弹出底部操作菜单。
  /// [actions] 为菜单项文本，点击返回其索引；取消返回 null。
  static Future<int?> show(
    BuildContext context, {
    String? title,
    required List<String> actions,
    String? cancelText = '取消',
    UViewType? type,
  }) {
    final theme = UView.of(context);
    final accent = theme.colorOf(type ?? UViewType.primary);
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: theme.backgroundColor,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                child: UText(title, color: theme.tipsTextColor, size: 13, align: TextAlign.center),
              ),
            ...actions.asMap().entries.map((e) {
              final idx = e.key;
              final label = e.value;
              return Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: theme.borderColor)),
                  color: theme.surfaceColor,
                ),
                child: InkWell(
                  onTap: () => Navigator.pop(context, idx),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: UText(label, size: 16, align: TextAlign.center,
                        color: idx == 0 ? accent : theme.mainTextColor),
                  ),
                ),
              );
            }).toList(),
            if (cancelText != null) ...[
              const SizedBox(height: 8),
              Container(
                color: theme.surfaceColor,
                width: double.infinity,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: UText(cancelText, size: 16, align: TextAlign.center,
                        color: theme.contentTextColor),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
