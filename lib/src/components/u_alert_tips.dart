import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../utils/uview_color_utils.dart';
import '../components/u_text.dart';

/// uView `AlertTips` 内嵌警告提示条。
class UAlertTips extends StatelessWidget {
  final UViewType type;
  final String? title;
  final String? description;
  final bool showClose;
  final VoidCallback? onClose;

  const UAlertTips({
    Key? key,
    this.type = UViewType.warning,
    this.title,
    this.description,
    this.showClose = false,
    this.onClose,
  }) : super(key: key);

  IconData get _icon {
    switch (type) {
      case UViewType.success:
        return Icons.check_circle;
      case UViewType.error:
        return Icons.cancel;
      case UViewType.warning:
        return Icons.warning;
      case UViewType.info:
        return Icons.info;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final color = theme.colorOf(type);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: UViewColorUtils.lighten(color, 0.86),
        borderRadius: BorderRadius.circular(theme.radiusSm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  UText(title!, color: color, bold: true, size: 14),
                if (description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: UText(description!, color: theme.contentTextColor, size: 13),
                  ),
              ],
            ),
          ),
          if (showClose)
            GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.translucent,
              child: Icon(Icons.close, size: 16, color: theme.tipsTextColor),
            ),
        ],
      ),
    );
  }
}
