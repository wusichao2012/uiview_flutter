import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// uView `Progress` 进度条（线性，带百分比）。
class UProgress extends StatelessWidget {
  final double percent; // 0..1
  final UViewType? type;
  final double height;
  final bool showText;
  final String? text;
  final double? width;

  const UProgress({
    Key? key,
    required this.percent,
    this.type,
    this.height = 10,
    this.showText = false,
    this.text,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final accent = theme.colorOf(type ?? UViewType.primary);
    final p = percent < 0 ? 0.0 : (percent > 1 ? 1.0 : percent);

    final bar = Container(
      height: height,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: p,
        child: Container(
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );

    final sized = width != null ? SizedBox(width: width, child: bar) : bar;
    if (!showText) return sized;
    return Row(
      children: [
        Expanded(child: sized),
        const SizedBox(width: 8),
        UText(text ?? '${(p * 100).round()}%',
            size: 12, color: theme.contentTextColor),
      ],
    );
  }
}
