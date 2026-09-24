import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/uview.dart';
import 'u_input.dart';
import 'u_text.dart';

/// uView `VerificationCode` 验证码输入框 + 倒计时按钮。
///
/// 点击“获取验证码”触发 [onSend]，此后进入 [seconds] 秒倒计时，期间按钮禁用。
class UVerificationCode extends StatefulWidget {
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSend;
  final int seconds;
  final TextEditingController? controller;

  const UVerificationCode({
    Key? key,
    this.placeholder,
    this.onChanged,
    this.onSend,
    this.seconds = 60,
    this.controller,
  }) : super(key: key);

  @override
  State<UVerificationCode> createState() => _UVerificationCodeState();
}

class _UVerificationCodeState extends State<UVerificationCode> {
  late TextEditingController _c;
  int _left = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _c = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (widget.controller == null) _c.dispose();
    super.dispose();
  }

  void _send() {
    if (_left > 0) return;
    widget.onSend?.call();
    setState(() => _left = widget.seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_left <= 1) {
        t.cancel();
        if (mounted) setState(() => _left = 0);
      } else if (mounted) {
        setState(() => _left--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final input = UInput(
      controller: _c,
      placeholder: widget.placeholder ?? '请输入验证码',
      keyboardType: TextInputType.number,
      clearable: true,
      onChanged: widget.onChanged,
    );
    final btn = GestureDetector(
      onTap: _left > 0 ? null : _send,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _left > 0 ? theme.backgroundColor : theme.primaryColor,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: Center(
          child: UText(
            _left > 0 ? '$_left s' : '获取验证码',
            color: _left > 0 ? theme.tipsTextColor : theme.inverseTextColor,
            size: 13,
          ),
        ),
      ),
    );
    return Row(
      children: [
        Expanded(child: input),
        const SizedBox(width: 8),
        btn,
      ],
    );
  }
}
