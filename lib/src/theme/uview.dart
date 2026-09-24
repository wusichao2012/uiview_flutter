import 'package:flutter/material.dart';
import 'uview_theme_data.dart';

/// 全局配置根组件，对标 uView 的 `ConfigProvider`。
///
/// 用法：
/// ```dart
/// UView(
///   theme: UViewThemeData(primaryColor: Colors.deepPurple),
///   child: MaterialApp(home: MyHome()),
/// )
/// ```
///
/// 任意后代组件通过 [UView.of] 读取主题；子组件也可调用
/// [UView.update] 在运行时切换主题。
class UView extends StatefulWidget {
  final UViewThemeData? theme;
  final Widget child;

  const UView({Key? key, this.theme, required this.child}) : super(key: key);

  /// 读取最近的 [UView] 主题；未找到时回退到 [UViewThemeData.fallback]。
  static UViewThemeData of(BuildContext context) {
    final _UViewInherited? inherited =
        context.dependOnInheritedWidgetOfExactType<_UViewInherited>();
    return inherited?.theme ?? UViewThemeData.fallback();
  }

  /// 运行时更新主题（需在 [UView] 子树内调用）。
  static void update(BuildContext context, UViewThemeData theme) {
    final _UViewState? state =
        context.findAncestorStateOfType<_UViewState>();
    state?._applyTheme(theme);
  }

  @override
  State<UView> createState() => _UViewState();
}

class _UViewState extends State<UView> {
  late UViewThemeData _theme;

  @override
  void initState() {
    super.initState();
    _theme = widget.theme ?? UViewThemeData.fallback();
  }

  @override
  void didUpdateWidget(UView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.theme != null && widget.theme != oldWidget.theme) {
      _theme = widget.theme!;
    }
  }

  void _applyTheme(UViewThemeData theme) {
    if (theme != _theme) {
      setState(() => _theme = theme);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _UViewInherited(theme: _theme, child: widget.child);
  }
}

class _UViewInherited extends InheritedWidget {
  final UViewThemeData theme;

  const _UViewInherited({
    Key? key,
    required this.theme,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_UViewInherited old) => old.theme != theme;
}
