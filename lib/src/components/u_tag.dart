import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../utils/uview_color_utils.dart';

class _TagMetrics {
  final double height;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double borderWidth;
  const _TagMetrics(this.height, this.fontSize, this.padding, this.borderWidth);
}

/// uView `Tag` 标签组件。
///
/// 支持 [type] 强调色、[plain] 幽灵、[round] 胶囊、[closable] 可关闭、[icon]。
class UTag extends StatelessWidget {
  final String? text;
  final Widget? child;
  final UViewType type;
  final bool plain;
  final bool round;
  final UViewSize size;
  final bool closable;
  final IconData? icon;
  final Color? bgColor;
  final Color? textColor;
  final VoidCallback? onClose;
  final EdgeInsetsGeometry? padding;

  const UTag({
    Key? key,
    this.text,
    this.child,
    this.type = UViewType.primary,
    this.plain = false,
    this.round = false,
    this.size = UViewSize.medium,
    this.closable = false,
    this.icon,
    this.bgColor,
    this.textColor,
    this.onClose,
    this.padding,
  }) : super(key: key);

  _TagMetrics _metrics() {
    switch (size) {
      case UViewSize.mini:
        return const _TagMetrics(18, 10, EdgeInsets.symmetric(horizontal: 6), 0.5);
      case UViewSize.small:
        return const _TagMetrics(22, 11, EdgeInsets.symmetric(horizontal: 8), 0.5);
      case UViewSize.large:
        return const _TagMetrics(32, 15, EdgeInsets.symmetric(horizontal: 14), 1.0);
      case UViewSize.medium:
        return const _TagMetrics(26, 13, EdgeInsets.symmetric(horizontal: 10), 0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final m = _metrics();
    final accent = theme.colorOf(type == UViewType.def ? UViewType.info : type);

    late Color bg;
    late Color fg;
    Color? border;

    if (bgColor != null) {
      bg = bgColor!;
      fg = textColor ?? theme.inverseTextColor;
    } else if (plain) {
      bg = UViewColorUtils.lighten(accent, 0.88);
      fg = textColor ?? accent;
      border = accent;
    } else {
      bg = accent;
      fg = textColor ?? theme.inverseTextColor;
    }

    final radius = round ? 999.0 : (theme.radiusSm + 2);
    final children = <Widget>[];
    if (icon != null) {
      children.add(Icon(icon, size: m.fontSize + 2, color: fg));
      children.add(const SizedBox(width: 3));
    }
    if (text != null) {
      children.add(Text(text!, style: TextStyle(fontSize: m.fontSize, color: fg)));
    } else if (child != null) {
      children.add(child!);
    }
    if (closable) {
      children.add(const SizedBox(width: 3));
      children.add(GestureDetector(
        onTap: onClose,
        child: Icon(Icons.close, size: m.fontSize + 1, color: fg.withOpacity(0.8)),
      ));
    }

    return Container(
      height: m.height,
      padding: padding ?? m.padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: border != null
            ? Border.all(color: border, width: m.borderWidth)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}
