import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// uView `Modal` 模态框结果。
class UModalResult {
  final bool confirmed;
  const UModalResult(this.confirmed);
}

/// uView `Modal` 模态对话框。
class UModal {
  const UModal._();

  /// 弹出模态框，[content] 可为字符串或任意 Widget。
  /// 点确认返回 [UModalResult(true)]，取消/点遮罩返回 [UModalResult(false)]。
  static Future<UModalResult> show(
    BuildContext context, {
    String? title,
    dynamic content,
    String confirmText = '确定',
    String cancelText = '取消',
    bool showCancel = true,
    UViewType? type,
    bool barrierDismissible = true,
  }) async {
    final theme = UView.of(context);
    final accent = theme.colorOf(type ?? UViewType.primary);
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme.radiusLg),
        ),
        title: title != null ? UText(title, bold: true, size: 17) : null,
        content: content is Widget
            ? content
            : (content is String ? UText(content, size: 14) : null),
        actionsPadding: const EdgeInsets.only(right: 8, bottom: 8),
        actions: [
          if (showCancel)
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: UText(cancelText, color: theme.tipsTextColor),
            ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: UText(confirmText, color: accent, bold: true),
          ),
        ],
      ),
    );
    return UModalResult(result ?? false);
  }
}
