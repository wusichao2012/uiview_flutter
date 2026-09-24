import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// uView `Textarea` 文本域。
///
/// 支持 [maxLength] + [showCounter] 计数、[autoHeight] 自动增高。
class UTextarea extends StatefulWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final String? initialValue;
  final bool enabled;
  final int? maxLength;
  final int maxLines;
  final int? minLines;
  final bool autoHeight;
  final bool showCounter;
  final bool border;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final ValueChanged<String>? onChanged;

  const UTextarea({
    Key? key,
    this.placeholder,
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 3,
    this.minLines,
    this.autoHeight = false,
    this.showCounter = false,
    this.border = true,
    this.validator,
    this.onSaved,
    this.onChanged,
  }) : super(key: key);

  @override
  State<UTextarea> createState() => _UTextareaState();
}

class _UTextareaState extends State<UTextarea> {
  late TextEditingController _controller;
  int _len = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _len = _controller.text.length;
    _controller.addListener(() {
      if (_controller.text.length != _len) setState(() => _len = _controller.text.length);
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final border = widget.border
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.radius),
            borderSide: BorderSide(color: theme.borderColor),
          )
        : InputBorder.none;
    final focusedBorder = widget.border
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.radius),
            borderSide: BorderSide(color: theme.primaryColor),
          )
        : InputBorder.none;

    final field = TextFormField(
      controller: _controller,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      minLines: widget.autoHeight ? (widget.minLines ?? 3) : widget.minLines,
      maxLines: widget.autoHeight ? null : widget.maxLines,
      validator: widget.validator,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      style: TextStyle(color: theme.mainTextColor, fontSize: theme.fontSize),
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: TextStyle(color: theme.lightTextColor, fontSize: theme.fontSize),
        isDense: true,
        contentPadding: const EdgeInsets.all(12),
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        disabledBorder: border,
        counterText: '',
        filled: !widget.border,
        fillColor: theme.backgroundColor,
      ),
    );

    if (!widget.showCounter || widget.maxLength == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        field,
        const SizedBox(height: 4),
        UText('$_len/${widget.maxLength}', size: 12, type: UViewType.info, align: TextAlign.right),
      ],
    );
  }
}
