import 'package:flutter/material.dart';
import '../theme/uview.dart';

/// uView `Sticky` 吸顶容器。
///
/// 用法：把需要吸顶的 [header] 与 [body]（列表内容）传入，
/// 页面滚动至 header 滚出视口时，header 会固定在顶部。
class USticky extends StatefulWidget {
  final Widget header;
  final List<Widget> body;
  final double headerHeight;
  final Color? backgroundColor;

  const USticky({
    Key? key,
    required this.header,
    required this.body,
    this.headerHeight = 48,
    this.backgroundColor,
  }) : super(key: key);

  @override
  _UStickyState createState() => _UStickyState();
}

class _UStickyState extends State<USticky> {
  bool _stuck = false;

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final bg = widget.backgroundColor ?? theme.surfaceColor;
    return Stack(
      children: [
        Positioned.fill(
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              final stuck = n.metrics.pixels > widget.headerHeight - 1;
              if (stuck != _stuck) setState(() => _stuck = stuck);
              return false;
            },
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: widget.headerHeight, child: widget.header),
                ...widget.body,
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Offstage(
            offstage: !_stuck,
            child: Container(
              height: widget.headerHeight,
              decoration: BoxDecoration(
                color: bg,
                border: Border(bottom: BorderSide(color: theme.borderColor)),
              ),
              child: widget.header,
            ),
          ),
        ),
      ],
    );
  }
}
