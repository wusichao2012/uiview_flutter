import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// uView `Tabs` 标签页（顶部标签栏 + 内容切换）。
class UTabs extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> children;
  final int initialIndex;
  final ValueChanged<int>? onChanged;
  final UViewType? type;
  final double height;
  final bool scrollable;

  const UTabs({
    Key? key,
    required this.tabs,
    required this.children,
    this.initialIndex = 0,
    this.onChanged,
    this.type,
    this.height = 44,
    this.scrollable = false,
  })  : assert(tabs.length == children.length),
        super(key: key);

  @override
  _UTabsState createState() => _UTabsState();
}

class _UTabsState extends State<UTabs> {
  late int _index;

  @override
  void initState() {
    super.initState();
    final max = widget.tabs.isEmpty ? 0 : widget.tabs.length - 1;
    _index = widget.initialIndex.clamp(0, max);
  }

  void _select(int i) {
    if (i != _index) {
      setState(() => _index = i);
      widget.onChanged?.call(i);
    }
  }

  List<Widget> _tabItems(UViewThemeData theme, Color accent) {
    return widget.tabs.asMap().entries.map((e) {
      final i = e.key;
      final active = i == _index;
      return GestureDetector(
        onTap: () => _select(i),
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: widget.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UText(
                e.value,
                size: 15,
                bold: active,
                color: active ? accent : theme.contentTextColor,
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 3,
                width: active ? 20 : 0,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final accent = theme.colorOf(widget.type ?? UViewType.primary);
    final tabBar = Container(
      height: widget.height,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.borderColor)),
      ),
      child: widget.scrollable
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: _tabItems(theme, accent)),
            )
          : Row(children: _tabItems(theme, accent)),
    );
    return Column(
      children: [
        tabBar,
        Expanded(
          child: IndexedStack(
            index: _index,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}
