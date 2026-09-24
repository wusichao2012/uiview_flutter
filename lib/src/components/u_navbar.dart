import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../components/u_text.dart';

/// uView `Navbar` 顶部导航栏。
class UNavbar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double height;
  final bool safeAreaTop;
  final bool border;
  final Color? titleColor;

  const UNavbar({
    Key? key,
    this.title,
    this.titleWidget,
    this.leading,
    this.showBack = false,
    this.onBack,
    this.actions,
    this.backgroundColor,
    this.height = 44,
    this.safeAreaTop = true,
    this.border = true,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final bg = backgroundColor ?? theme.surfaceColor;
    final bar = Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: bg,
        border: border
            ? Border(bottom: BorderSide(color: theme.borderColor))
            : null,
      ),
      child: Row(
        children: [
          if (showBack || leading != null)
            leading ??
                GestureDetector(
                  onTap: onBack ?? () => Navigator.maybePop(context),
                  behavior: HitTestBehavior.translucent,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.arrow_back_ios,
                        size: 18,
                        color: titleColor ?? theme.mainTextColor),
                  ),
                )
          else
            const SizedBox(width: 36),
          Expanded(
            child: Center(
              child: titleWidget ??
                  (title != null
                      ? UText(title!,
                          bold: true,
                          size: 17,
                          color: titleColor ?? theme.mainTextColor)
                      : const SizedBox.shrink()),
            ),
          ),
          if (actions != null)
            Row(children: actions!)
          else
            const SizedBox(width: 36),
        ],
      ),
    );
    return safeAreaTop ? SafeArea(top: true, child: bar) : bar;
  }
}
