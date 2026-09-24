import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../utils/uview_color_utils.dart';

class _ButtonStyle {
  final Color bg;
  final Color fg;
  final Color? border;
  final double borderWidth;
  const _ButtonStyle(this.bg, this.fg, this.border, this.borderWidth);
}

class _ButtonMetrics {
  final double height;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  const _ButtonMetrics(this.height, this.fontSize, this.padding);
}

/// uView `Button` 按钮组件。
///
/// 支持 [type] 强调色、[plain] 幽灵按钮、[round] 胶囊、[hairline] 细边、
/// [disabled] 禁用、[loading] 加载态、[block] 通栏、[icon] 前置图标。
class UButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final UViewType type;
  final UViewSize size;
  final bool plain;
  final bool round;
  final bool disabled;
  final bool loading;
  final bool block;
  final bool hairline;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const UButton({
    Key? key,
    this.text,
    this.child,
    this.type = UViewType.primary,
    this.size = UViewSize.medium,
    this.plain = false,
    this.round = false,
    this.disabled = false,
    this.loading = false,
    this.block = false,
    this.hairline = false,
    this.icon,
    this.iconColor,
    this.onPressed,
    this.padding,
    this.width,
    this.height,
  }) : super(key: key);

  bool get _interactive => !disabled && !loading && onPressed != null;

  _ButtonStyle _resolveStyle(UViewThemeData theme) {
    final Color accent = theme.colorOf(type == UViewType.def ? UViewType.info : type);
    final double borderWidth = hairline ? 0.5 : 1.0;

    late Color bg;
    late Color fg;
    Color? border;

    if (type == UViewType.def && !plain) {
      // uView 默认按钮：白底灰边。
      bg = theme.surfaceColor;
      fg = theme.contentTextColor;
      border = theme.borderColor;
    } else if (plain) {
      bg = UViewColorUtils.lighten(accent, 0.88);
      fg = accent;
      border = accent;
    } else {
      bg = accent;
      fg = theme.inverseTextColor;
    }

    if (disabled) {
      if (plain) {
        bg = theme.backgroundColor;
        fg = theme.lightTextColor;
        border = theme.borderColor;
      } else {
        bg = theme.disabledBgColor;
        fg = theme.inverseTextColor.withOpacity(0.85);
        border = null;
      }
    }
    return _ButtonStyle(bg, fg, border, borderWidth);
  }

  _ButtonMetrics _resolveMetrics(UViewThemeData theme) {
    switch (size) {
      case UViewSize.mini:
        return const _ButtonMetrics(28, 12, EdgeInsets.symmetric(horizontal: 10));
      case UViewSize.small:
        return const _ButtonMetrics(34, 13, EdgeInsets.symmetric(horizontal: 14));
      case UViewSize.large:
        return const _ButtonMetrics(48, 16, EdgeInsets.symmetric(horizontal: 22));
      case UViewSize.medium:
        return const _ButtonMetrics(40, 15, EdgeInsets.symmetric(horizontal: 18));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final style = _resolveStyle(theme);
    final metrics = _resolveMetrics(theme);
    final radius = round ? 999.0 : theme.radius;

    final List<Widget> children = [];
    if (loading) {
      children.add(SizedBox(
        width: metrics.fontSize + 2,
        height: metrics.fontSize + 2,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(style.fg),
        ),
      ));
    } else if (icon != null) {
      children.add(Icon(icon, size: metrics.fontSize + 2, color: iconColor ?? style.fg));
    }
    if (children.isNotEmpty && (text != null || child != null)) {
      children.add(const SizedBox(width: 6));
    }
    if (text != null) {
      children.add(Text(text!, style: TextStyle(fontSize: metrics.fontSize, color: style.fg)));
    } else if (child != null) {
      children.add(child!);
    }

    final btnHeight = height ?? metrics.height;
    final btnPadding = padding ?? metrics.padding;

    Widget inner = Container(
      height: btnHeight,
      padding: btnPadding,
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(radius),
        border: style.border != null
            ? Border.all(color: style.border!, width: style.borderWidth)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );

    Widget result = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _interactive ? onPressed : null,
        borderRadius: BorderRadius.circular(radius),
        child: inner,
      ),
    );

    if (block || width != null) {
      result = SizedBox(width: width ?? double.infinity, child: result);
    }
    return result;
  }
}
