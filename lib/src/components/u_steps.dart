import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// uView `Steps` 步骤条（横向）。
class USteps extends StatelessWidget {
  final List<String> steps;
  final int current; // 当前步骤（0-based）；索引 < current 视为已完成
  final UViewType? type;
  final double? circleSize;

  const USteps({
    Key? key,
    required this.steps,
    this.current = 0,
    this.type,
    this.circleSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final accent = theme.colorOf(type ?? UViewType.primary);
    final size = circleSize ?? 24.0;

    return Row(
      children: steps.asMap().entries.map((e) {
        final i = e.key;
        final done = i < current;
        final active = i == current;
        final lineColor = i < current ? accent : theme.borderColor;
        final color = done || active ? accent : theme.borderColor;
        final textColor =
            active ? accent : (done ? theme.mainTextColor : theme.tipsTextColor);
        final isLast = i == steps.length - 1;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? accent : theme.surfaceColor,
                      border: Border.all(color: color, width: 2),
                    ),
                    child: Center(
                      child: done
                          ? Icon(Icons.check,
                              size: 14, color: theme.inverseTextColor)
                          : UText('${i + 1}',
                              size: 12, color: active ? accent : theme.tipsTextColor),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(height: 2, color: lineColor),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              UText(e.value, size: 12, color: textColor, align: TextAlign.center),
            ],
          ),
        );
      }).toList(),
    );
  }
}
