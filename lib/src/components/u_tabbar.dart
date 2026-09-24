import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// `Tabbar` 单个底部标签项。
class UTabbarItem {
  final Widget icon;
  final Widget? activeIcon;
  final String label;
  final Color? activeColor;

  const UTabbarItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.activeColor,
  });
}

/// uView `Tabbar` 底部标签栏。
class UTabbar extends StatelessWidget {
  final List<UTabbarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final UViewType? type;
  final Color? backgroundColor;
  final double height;
  final bool safeAreaBottom;

  const UTabbar({
    Key? key,
    required this.items,
    required this.currentIndex,
    this.onTap,
    this.type,
    this.backgroundColor,
    this.height = 56,
    this.safeAreaBottom = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final accent = theme.colorOf(type ?? UViewType.primary);
    final bar = Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.surfaceColor,
        border: Border(top: BorderSide(color: theme.borderColor)),
      ),
      child: Row(
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final it = e.value;
          final active = i == currentIndex;
          final color = it.activeColor ?? accent;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap?.call(i),
              behavior: HitTestBehavior.translucent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  active ? (it.activeIcon ?? it.icon) : it.icon,
                  const SizedBox(height: 4),
                  UText(
                    it.label,
                    size: 11,
                    color: active ? color : theme.tipsTextColor,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
    return safeAreaBottom
        ? SafeArea(top: false, bottom: true, child: bar)
        : bar;
  }
}
