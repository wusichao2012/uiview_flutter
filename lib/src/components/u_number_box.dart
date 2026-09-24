import 'package:flutter/material.dart';
import '../theme/uview.dart';

/// uView `NumberBox` 步进器。
///
/// 支持 [min]/[max]/[step]、[integer] 整数模式、可手动输入。
class UNumberBox extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final double step;
  final bool integer;
  final bool disabled;
  final ValueChanged<double>? onChanged;

  const UNumberBox({
    Key? key,
    this.value = 0,
    this.min = 0,
    this.max = 99999,
    this.step = 1,
    this.integer = true,
    this.disabled = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<UNumberBox> createState() => _UNumberBoxState();
}

class _UNumberBoxState extends State<UNumberBox> {
  late double _v;
  late TextEditingController _c;

  @override
  void initState() {
    super.initState();
    _v = widget.value.clamp(widget.min, widget.max);
    _c = TextEditingController(text: _fmt(_v));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  String _fmt(double v) => widget.integer ? v.toInt().toString() : v.toStringAsFixed(1);

  void _commit(double nv) {
    nv = nv.clamp(widget.min, widget.max);
    if (widget.integer) nv = nv.roundToDouble();
    _v = nv;
    _c.text = _fmt(nv);
    widget.onChanged?.call(nv);
  }

  void _onInput(String s) {
    final d = double.tryParse(s);
    if (d != null) _commit(d);
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    Widget stepBtn(IconData icon, VoidCallback? onTap) => Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: BorderRadius.circular(theme.radiusSm),
          ),
          child: IconButton(
            icon: Icon(icon, size: 16,
                color: widget.disabled ? theme.lightTextColor : theme.mainTextColor),
            onPressed: widget.disabled ? null : onTap,
            splashRadius: 16,
            padding: EdgeInsets.zero,
          ),
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        stepBtn(Icons.remove, () => _commit(_v - widget.step)),
        const SizedBox(width: 6),
        SizedBox(
          width: 46,
          height: 32,
          child: TextField(
            controller: _c,
            enabled: !widget.disabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: theme.fontSize, color: theme.mainTextColor),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            onChanged: _onInput,
          ),
        ),
        const SizedBox(width: 6),
        stepBtn(Icons.add, () => _commit(_v + widget.step)),
      ],
    );
  }
}
