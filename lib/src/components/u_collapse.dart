import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../components/u_text.dart';

/// uView `Collapse` 单个折叠面板项。
class UCollapseItem {
  final String title;
  final Widget content;
  final bool disabled;

  const UCollapseItem({
    required this.title,
    required this.content,
    this.disabled = false,
  });
}

/// uView `Collapse` 折叠面板。
class UCollapse extends StatefulWidget {
  final List<UCollapseItem> children;
  final bool accordion; // 手风琴模式（同时只展开一项）
  final List<int> defaultExpanded;

  const UCollapse({
    Key? key,
    required this.children,
    this.accordion = false,
    this.defaultExpanded = const [],
  }) : super(key: key);

  @override
  _UCollapseState createState() => _UCollapseState();
}

class _UCollapseState extends State<UCollapse> {
  late Set<int> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = {...widget.defaultExpanded};
  }

  void _toggle(int i) {
    setState(() {
      if (widget.accordion) {
        _expanded = _expanded.contains(i) ? <int>{} : {i};
      } else {
        if (_expanded.contains(i)) {
          _expanded.remove(i);
        } else {
          _expanded.add(i);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    return Column(
      children: List.generate(widget.children.length, (i) {
        final item = widget.children[i];
        final open = _expanded.contains(i);
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.borderColor),
              top: i == 0 ? BorderSide(color: theme.borderColor) : BorderSide.none,
            ),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: item.disabled ? null : () => _toggle(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: UText(
                          item.title,
                          bold: true,
                          size: 15,
                          color: item.disabled
                              ? theme.lightTextColor
                              : theme.mainTextColor,
                        ),
                      ),
                      RotationTransition(
                        turns: AlwaysStoppedAnimation(open ? 0.5 : 0.0),
                        child: Icon(Icons.chevron_right,
                            color: theme.lightTextColor),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: item.content,
                ),
                crossFadeState:
                    open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 220),
              ),
            ],
          ),
        );
      }),
    );
  }
}
