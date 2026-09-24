import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';

/// uView `Divider` 分割线，支持中间文字与虚线。
class UDivider extends StatelessWidget {
  final String? text;
  final Color? color;
  final double thickness;
  final bool dashed;
  final EdgeInsetsGeometry? margin;
  final double? textSize;
  final UViewType? textType;
  final MainAxisAlignment textAlign;

  const UDivider({
    Key? key,
    this.text,
    this.color,
    this.thickness = 0.5,
    this.dashed = false,
    this.margin,
    this.textSize,
    this.textType,
    this.textAlign = MainAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final lineColor = color ?? theme.borderColor;
    final line = Expanded(
      child: dashed
          ? SizedBox(
              height: thickness,
              child: CustomPaint(
                painter: _DashedPainter(color: lineColor, thickness: thickness),
              ),
            )
          : Container(
              height: thickness,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: lineColor, width: thickness)),
              ),
            ),
    );

    if (text == null || text!.isEmpty) {
      return Container(
        margin: margin ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        child: line,
      );
    }

    final textWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        text!,
        style: TextStyle(
          color: textType != null && textType != UViewType.def
              ? theme.colorOf(textType!)
              : theme.tipsTextColor,
          fontSize: textSize ?? theme.fontSize,
        ),
      ),
    );

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: textAlign == MainAxisAlignment.end
            ? [line, textWidget]
            : textAlign == MainAxisAlignment.start
                ? [textWidget, line]
                : [line, textWidget, line],
      ),
    );
  }
}

class _DashedPainter extends CustomPainter {
  final Color color;
  final double thickness;
  const _DashedPainter({required this.color, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;
    const dash = 5.0;
    const gap = 4.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dash, 0), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedPainter old) => old.color != color;
}
