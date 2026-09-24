import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';

/// uView `Text` 文本组件。
///
/// 支持用 [type] 直接取主题强调色；[lines] 指定最大行数并自动省略；
/// [block] 让文本占满整行。
class UText extends StatelessWidget {
  final String text;
  final UViewType? type;
  final Color? color;
  final double? size;
  final bool bold;
  final FontWeight? fontWeight;
  final int? lines;
  final TextAlign? align;
  final bool block;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;

  const UText(
    this.text, {
    Key? key,
    this.type,
    this.color,
    this.size,
    this.bold = false,
    this.fontWeight,
    this.lines,
    this.align,
    this.block = false,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.overflow,
    this.letterSpacing,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final Color resolvedColor = color ??
        (type != null && type != UViewType.def
            ? theme.colorOf(type!)
            : theme.contentTextColor);

    final child = Text(
      text,
      maxLines: lines,
      textAlign: align,
      overflow: lines != null
          ? (overflow ?? TextOverflow.ellipsis)
          : overflow,
      style: TextStyle(
        color: resolvedColor,
        fontSize: size ?? theme.fontSize,
        fontWeight: fontWeight ?? (bold ? FontWeight.bold : FontWeight.normal),
        backgroundColor: backgroundColor,
        letterSpacing: letterSpacing,
        height: height,
      ),
    );

    Widget result = child;
    if (padding != null) {
      result = Padding(padding: padding!, child: result);
    }
    if (block) {
      result = SizedBox(width: double.infinity, child: result);
    }
    if (margin != null) {
      result = Padding(padding: margin!, child: result);
    }
    return result;
  }
}
