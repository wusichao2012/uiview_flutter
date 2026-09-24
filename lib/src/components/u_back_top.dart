import 'package:flutter/material.dart';
import '../theme/uview.dart';

/// uView `BackTop` 返回顶部（监听滚动，超过阈值显示浮动按钮）。
class UBackTop extends StatefulWidget {
  final ScrollController controller;
  final double visibilityHeight;
  final VoidCallback? onTap;
  final Widget? child;

  const UBackTop({
    Key? key,
    required this.controller,
    this.visibilityHeight = 200,
    this.onTap,
    this.child,
  }) : super(key: key);

  @override
  _UBackTopState createState() => _UBackTopState();
}

class _UBackTopState extends State<UBackTop> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!widget.controller.hasClients) return;
    final show = widget.controller.position.pixels > widget.visibilityHeight;
    if (show != _show) setState(() => _show = show);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_show) return const SizedBox.shrink();
    final theme = UView.of(context);
    return GestureDetector(
      onTap: widget.onTap ??
          () {
            widget.controller.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
      behavior: HitTestBehavior.translucent,
      child: widget.child ??
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.surfaceColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.maskColor.withOpacity(0.15),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Icon(Icons.vertical_align_top, color: theme.contentTextColor),
          ),
    );
  }
}
