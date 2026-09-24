import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// uView `SwipeAction` 单元格滑出的操作按钮。
class USwipeAction {
  final String text;
  final UViewType? type;
  final Color? backgroundColor;
  final VoidCallback onTap;

  const USwipeAction({
    required this.text,
    this.type,
    this.backgroundColor,
    required this.onTap,
  });
}

/// uView `SwipeAction` 滑动单元格。
///
/// [actions] 位于右侧（向左滑动露出）；[leftActions] 位于左侧（向右滑动露出）。
class USwipeActionCell extends StatefulWidget {
  final Widget child;
  final List<USwipeAction> actions;
  final List<USwipeAction>? leftActions;
  final double actionWidth;

  const USwipeActionCell({
    Key? key,
    required this.child,
    this.actions = const [],
    this.leftActions,
    this.actionWidth = 72,
  }) : super(key: key);

  @override
  _USwipeActionCellState createState() => _USwipeActionCellState();
}

class _USwipeActionCellState extends State<USwipeActionCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  double _dragStart = 0;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, value: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  double get _rightW => widget.actions.length * widget.actionWidth;
  double get _leftW => (widget.leftActions?.length ?? 0) * widget.actionWidth;

  void _onStart(_) => _dragStart = _c.value;

  void _onUpdate(DragUpdateDetails d) {
    final next = (_dragStart + d.delta.dx).clamp(-_rightW, _leftW);
    if (next != _c.value) setState(() => _c.value = next);
  }

  void _onEnd(_) {
    final v = _c.value;
    double target = 0;
    if (v < -_rightW / 2) {
      target = -_rightW;
    } else if (v > _leftW / 2) {
      target = _leftW;
    }
    _c.animateTo(target, duration: const Duration(milliseconds: 200));
  }

  Widget _tile(USwipeAction a, UViewThemeData theme) {
    final color = a.backgroundColor ?? theme.colorOf(a.type ?? UViewType.error);
    return GestureDetector(
      onTap: a.onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: widget.actionWidth,
        color: color,
        child: Center(
          child: UText(a.text, color: theme.inverseTextColor, bold: true, size: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    return Stack(
      children: [
        if (widget.actions.isNotEmpty)
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: widget.actions.map((a) => _tile(a, theme)).toList(),
            ),
          ),
        if (widget.leftActions != null && widget.leftActions!.isNotEmpty)
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: widget.leftActions!.map((a) => _tile(a, theme)).toList(),
            ),
          ),
        AnimatedBuilder(
          animation: _c,
          builder: (_, __) => Transform.translate(
            offset: Offset(_c.value, 0),
            child: GestureDetector(
              onHorizontalDragStart: _onStart,
              onHorizontalDragUpdate: _onUpdate,
              onHorizontalDragEnd: _onEnd,
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}
