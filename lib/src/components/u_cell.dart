import 'package:flutter/material.dart';
import '../theme/uview.dart';

/// uView `Cell` 单元格组件，常用于列表项。
///
/// 支持 [title]/[value]/[label]、前置 [icon]、[isLink] 右箭头、[required] 必填星、
/// [border] 底分割线、[onTap] 点击。
class UCell extends StatelessWidget {
  final String? title;
  final String? value;
  final String? label;
  final Widget? icon;
  final Widget? rightIcon;
  final bool isLink;
  final bool required;
  final bool border;
  final bool center;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Widget? titleChild;
  final Widget? valueChild;
  final Color? backgroundColor;

  const UCell({
    Key? key,
    this.title,
    this.value,
    this.label,
    this.icon,
    this.rightIcon,
    this.isLink = false,
    this.required = false,
    this.border = true,
    this.center = false,
    this.padding,
    this.onTap,
    this.titleChild,
    this.valueChild,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final content = Row(
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (required)
                    Text('*', style: TextStyle(color: theme.errorColor, fontSize: theme.fontSizeLg)),
                  if (titleChild != null)
                    titleChild!
                  else if (title != null)
                    Text(title!,
                        style: TextStyle(color: theme.mainTextColor, fontSize: theme.fontSizeLg)),
                ],
              ),
              if (label != null) ...[
                const SizedBox(height: 4),
                Text(label!,
                    style: TextStyle(color: theme.tipsTextColor, fontSize: theme.fontSizeSm)),
              ],
            ],
          ),
        ),
        if (valueChild != null)
          valueChild!
        else if (value != null)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(value!,
                style: TextStyle(color: theme.tipsTextColor, fontSize: theme.fontSize)),
          ),
        if (isLink) ...[
          const SizedBox(width: 4),
          rightIcon ??
              Icon(Icons.chevron_right, color: theme.lightTextColor, size: 18),
        ],
      ],
    );

    final box = Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.surfaceColor,
        border: border
            ? Border(bottom: BorderSide(color: theme.borderColor, width: 0.5))
            : null,
      ),
      child: content,
    );

    if (onTap == null) return box;
    return InkWell(onTap: onTap, child: box);
  }
}

/// `CellGroup` 单元格分组，提供统一背景与可选标题。
class UCellGroup extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final EdgeInsetsGeometry? margin;

  const UCellGroup({Key? key, required this.children, this.title, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(title!, style: TextStyle(color: theme.tipsTextColor, fontSize: theme.fontSize)),
            ),
          ...children,
        ],
      ),
    );
  }
}
