import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// 悬浮球子操作项。
class UFloatingAction {
  final Widget child;
  final String? label;
  final VoidCallback? onTap;

  const UFloatingAction({required this.child, this.label, this.onTap});
}

/// uView `FloatingBall` 悬浮球：可拖拽，点击主按钮向上展开子操作菜单。
///
/// 需放置在有明确尺寸的父容器内（如 `Container` / `Stack` / 页面 Stack）。
class UFloatingBall extends StatefulWidget {
  final Widget? child;
  final List<UFloatingAction> actions;
  final double size;
  final UViewType type;
  final Color? backgroundColor;
  final double elevation;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  const UFloatingBall({
    Key? key,
    this.child,
    this.actions = const [],
    this.size = 56,
    this.type = UViewType.primary,
    this.backgroundColor,
    this.elevation = 6,
    this.left,
    this.top,
    this.right = 16,
    this.bottom = 16,
  }) : super(key: key);

  @override
  _UFloatingBallState createState() => _UFloatingBallState();
}

class _UFloatingBallState extends State<UFloatingBall> {
  double? _left;
  double? _top;
  bool _expand = false;

  @override
  void didUpdateWidget(covariant UFloatingBall oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.left != widget.left) _left = widget.left;
    if (oldWidget.top != widget.top) _top = widget.top;
  }

  void _toggle() => setState(() => _expand = !_expand);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final bg = widget.backgroundColor ?? theme.colorOf(widget.type);
    final mainChild =
        widget.child ?? Icon(Icons.add, color: theme.inverseTextColor, size: widget.size * 0.55);

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;
        final curLeft =
            _left ?? (maxW - (widget.right ?? 16) - widget.size);
        final curTop =
            _top ?? (maxH - (widget.bottom ?? 16) - widget.size);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            if (_expand)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _toggle,
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox.expand(),
                ),
              ),
            Positioned(
              left: curLeft,
              top: curTop,
              child: GestureDetector(
                onPanUpdate: (d) {
                  setState(() {
                    _left = (curLeft + d.delta.dx)
                        .clamp(0.0, maxW - widget.size);
                    _top = (curTop + d.delta.dy)
                        .clamp(0.0, maxH - widget.size);
                  });
                },
                onTap: widget.actions.isEmpty ? null : _toggle,
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ...widget.actions.asMap().entries.map((e) {
                        final idx = e.key;
                        final a = e.value;
                        final offset = (idx + 1) * (widget.size * 0.62 + 12);
                        return AnimatedOpacity(
                          opacity: _expand ? 1 : 0,
                          duration: const Duration(milliseconds: 180),
                          child: AnimatedPositioned(
                            duration: const Duration(milliseconds: 180),
                            bottom: _expand ? offset : 0,
                            child: GestureDetector(
                              onTap: () {
                                a.onTap?.call();
                                setState(() => _expand = false);
                              },
                              child: _buildAction(a, theme),
                            ),
                          ),
                        );
                      }).toList(),
                      Container(
                        width: widget.size,
                        height: widget.size,
                        decoration: BoxDecoration(
                          color: bg,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: widget.elevation,
                              offset: Offset(0, widget.elevation / 2),
                            )
                          ],
                        ),
                        child: Center(child: mainChild),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAction(UFloatingAction a, UViewThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        borderRadius: BorderRadius.circular(widget.size),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          a.child,
          if (a.label != null) ...[
            const SizedBox(width: 6),
            UText(a.label!, size: 13),
          ],
        ],
      ),
    );
  }
}
