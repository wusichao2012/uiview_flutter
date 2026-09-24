import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../components/u_text.dart';

/// uView `Empty` 空状态。
class UEmpty extends StatelessWidget {
  final Widget? icon;
  final String? text;
  final Widget? action;
  final double iconSize;

  const UEmpty({
    Key? key,
    this.icon,
    this.text,
    this.action,
    this.iconSize = 64,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon ?? Icon(Icons.inbox_outlined, size: iconSize, color: theme.lightTextColor),
            if (text != null) ...[
              const SizedBox(height: 12),
              UText(text!, size: 14, color: theme.tipsTextColor),
            ],
            if (action != null) ...[
              const SizedBox(height: 16),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
