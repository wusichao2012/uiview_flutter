import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../components/u_text.dart';

/// uView `CountDown` 倒计时。
class UCountDown extends StatefulWidget {
  final Duration duration;
  final ValueChanged<Duration>? onTick;
  final VoidCallback? onFinish;
  final String Function(Duration)? formatter;
  final bool autoStart;
  final double? textSize;

  const UCountDown({
    Key? key,
    required this.duration,
    this.onTick,
    this.onFinish,
    this.formatter,
    this.autoStart = true,
    this.textSize,
  }) : super(key: key);

  @override
  _UCountDownState createState() => _UCountDownState();
}

class _UCountDownState extends State<UCountDown> {
  late Duration _remain;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remain = widget.duration;
    if (widget.autoStart) _start();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remain.inSeconds <= 1) {
        setState(() => _remain = Duration.zero);
        _timer?.cancel();
        widget.onTick?.call(Duration.zero);
        widget.onFinish?.call();
      } else {
        setState(() => _remain = _remain - const Duration(seconds: 1));
        widget.onTick?.call(_remain);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt() {
    if (widget.formatter != null) return widget.formatter!(_remain);
    final pad = (int n) => n.toString().padLeft(2, '0');
    final d = _remain.inDays;
    final h = _remain.inHours % 24;
    final m = _remain.inMinutes % 60;
    final s = _remain.inSeconds % 60;
    if (d > 0) return '$d天 ${pad(h)}:${pad(m)}:${pad(s)}';
    return '${pad(h)}:${pad(m)}:${pad(s)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    return UText(_fmt(), size: widget.textSize ?? theme.fontSize, color: theme.contentTextColor);
  }
}
