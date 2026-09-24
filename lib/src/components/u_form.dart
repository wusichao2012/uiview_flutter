import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// 表单控制器：聚合 [UForm] 内所有 [TextFormField] 的校验/保存/重置。
class UFormController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validate() => formKey.currentState?.validate() ?? false;
  void save() => formKey.currentState?.save();
  void reset() => formKey.currentState?.reset();
}

/// uView `Form` 表单容器。包裹 Flutter 原生 [Form]，用 [UFormController] 统一校验。
class UForm extends StatefulWidget {
  final Widget child;
  final UFormController? controller;

  const UForm({Key? key, this.controller, required this.child}) : super(key: key);

  @override
  State<UForm> createState() => _UFormState();
}

class _UFormState extends State<UForm> {
  late UFormController _c;

  @override
  void initState() {
    super.initState();
    _c = widget.controller ?? UFormController();
  }

  UFormController get controller => _c;

  @override
  Widget build(BuildContext context) =>
      Form(key: _c.formKey, child: widget.child);
}

/// uView `Form` 表单项：统一的 [label] + 必填星 + [child] 布局。
class UFormItem extends StatelessWidget {
  final String? label;
  final bool required;
  final Widget child;
  final String? description;

  const UFormItem({
    Key? key,
    this.label,
    this.required = false,
    required this.child,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Row(
            children: [
              if (required)
                UText('*', color: theme.errorColor, size: 15),
              UText(label!, bold: true, size: 15),
            ],
          ),
        if (label != null) const SizedBox(height: 8),
        if (description != null) ...[
          UText(description!, size: 12, type: UViewType.info),
          const SizedBox(height: 6),
        ],
        child,
      ],
    );
  }
}
