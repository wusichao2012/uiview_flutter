import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';

/// uView `Input` 输入框。
///
/// 基于 [TextFormField]，可直接放入 [UForm] 参与校验。
/// 支持 [password] 显隐切换、[clearable] 一键清空、前后缀图标/文字、[type] 边框强调色。
class UInput extends StatefulWidget {
  final String? placeholder;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool password;
  final bool clearable;
  final bool enabled;
  final bool border;
  final UViewType? type;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final int? maxLength;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  const UInput({
    Key? key,
    this.placeholder,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.password = false,
    this.clearable = false,
    this.enabled = true,
    this.border = true,
    this.type,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.maxLines = 1,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
  }) : super(key: key);

  @override
  State<UInput> createState() => _UInputState();
}

class _UInputState extends State<UInput> {
  late TextEditingController _controller;
  bool _hasText = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(() {
      final has = _controller.text.isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
    _obscure = widget.password;
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final accent = widget.type != null && widget.type != UViewType.def
        ? theme.colorOf(widget.type!)
        : theme.primaryColor;

    Widget? suffix;
    if (widget.password) {
      suffix = IconButton(
        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
            color: theme.lightTextColor, size: 18),
        onPressed: () => setState(() => _obscure = !_obscure),
        splashRadius: 18,
      );
    } else if (widget.clearable && _hasText && widget.enabled) {
      suffix = IconButton(
        icon: Icon(Icons.cancel, color: theme.lightTextColor, size: 16),
        splashRadius: 16,
        onPressed: () => _controller.clear(),
      );
    } else if (widget.suffixIcon != null) {
      suffix = widget.suffixIcon;
    }

    final border = widget.border
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.radius),
            borderSide: BorderSide(color: theme.borderColor),
          )
        : InputBorder.none;
    final focusedBorder = widget.border
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.radius),
            borderSide: BorderSide(color: accent),
          )
        : InputBorder.none;

    return TextFormField(
      controller: _controller,
      focusNode: widget.focusNode,
      obscureText: _obscure,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      textAlign: widget.textAlign,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      validator: widget.validator,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
      style: TextStyle(color: theme.mainTextColor, fontSize: theme.fontSizeLg),
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: TextStyle(color: theme.lightTextColor, fontSize: theme.fontSizeLg),
        prefixIcon: widget.prefixIcon,
        suffixIcon: suffix,
        prefixText: widget.prefixText,
        suffixText: widget.suffixText,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        disabledBorder: border,
        counterText: '',
        filled: !widget.border,
        fillColor: theme.backgroundColor,
      ),
    );
  }

  TextEditingController get controller => _controller;
}
