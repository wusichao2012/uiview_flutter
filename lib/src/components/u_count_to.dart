import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// uView `CountTo` 数字滚动（动画从 [begin] 增长到 [end]）。
class UCountTo extends StatefulWidget {
  final num end;
  final num begin;
  final Duration duration;
  final int decimals;
  final String? prefix;
  final String? suffix;
  final double? size;
  final UViewType? type;
  final VoidCallback? onFinish;
  final bool autoStart;

  const UCountTo({
    Key? key,
    required this.end,
    this.begin = 0,
    this.duration = const Duration(milliseconds: 800),
    this.decimals = 0,
    this.prefix,
    this.suffix,
    this.size,
    this.type,
    this.onFinish,
    this.autoStart = true,
  }) : super(key: key);

  @override
  _UCountToState createState() => _UCountToState();
}

class _UCountToState extends State<UCountTo> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _a = Tween<double>(
      begin: widget.begin.toDouble(),
      end: widget.end.toDouble(),
    ).animate(_c);
    if (widget.autoStart) _c.forward();
    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onFinish?.call();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  String _fmt(double v) =>
      '${widget.prefix ?? ''}${v.toStringAsFixed(widget.decimals)}${widget.suffix ?? ''}';

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    return AnimatedBuilder(
      animation: _a,
      builder: (_, __) => UText(
        _fmt(_a.value),
        size: widget.size ?? theme.fontSizeXl,
        type: widget.type,
        bold: true,
      ),
    );
  }
}
