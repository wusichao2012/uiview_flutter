import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// Toast 显示位置。
enum UToastPosition { top, center, bottom }

/// uView `Toast` 轻提示（基于 Overlay 的全局提示）。
///
/// 用法（需能拿到 [OverlayState]，即处于 [MaterialApp] 子树内）：
/// ```dart
/// UToast.show(context, '操作成功', type: UViewType.success);
/// final h = UToast.loading(context, message: '加载中');
/// UToast.hide(context);
/// ```
class UToast {
  const UToast._();

  static OverlayEntry? _loadingEntry;

  static OverlayState? _overlay(BuildContext context) => Overlay.of(context);

  /// 普通轻提示。默认 2 秒后自动消失。
  static void show(
    BuildContext context,
    String message, {
    UViewType? type,
    UToastPosition position = UToastPosition.center,
    Duration duration = const Duration(seconds: 2),
    bool mask = false,
  }) {
    final overlay = _overlay(context);
    if (overlay == null) return;
    final theme = UView.of(context);
    final entry = OverlayEntry(
      builder: (_) => _ToastWidget(
        message: message,
        type: type,
        position: position,
        mask: mask,
        theme: theme,
      ),
    );
    overlay.insert(entry);
    Future.delayed(duration, () {
      if (entry.mounted) entry.remove();
    });
  }

  static void success(BuildContext context, String message,
          {UToastPosition position = UToastPosition.center}) =>
      show(context, message, type: UViewType.success, position: position);

  static void error(BuildContext context, String message,
          {UToastPosition position = UToastPosition.center}) =>
      show(context, message, type: UViewType.error, position: position);

  static void warning(BuildContext context, String message,
          {UToastPosition position = UToastPosition.center}) =>
      show(context, message, type: UViewType.warning, position: position);

  static void info(BuildContext context, String message,
          {UToastPosition position = UToastPosition.center}) =>
      show(context, message, type: UViewType.info, position: position);

  /// 持续显示的加载 Toast（带 spinner）。需调用 [hide] 关闭。
  static void loading(BuildContext context, {String? message, bool mask = true}) {
    hide(context);
    final overlay = _overlay(context);
    if (overlay == null) return;
    final theme = UView.of(context);
    _loadingEntry = OverlayEntry(
      builder: (_) => _ToastWidget(
        message: message ?? '加载中...',
        loading: true,
        position: UToastPosition.center,
        mask: mask,
        theme: theme,
      ),
    );
    overlay.insert(_loadingEntry!);
  }

  /// 关闭加载 Toast。
  static void hide(BuildContext context) {
    _loadingEntry?.remove();
    _loadingEntry = null;
  }
}

class _ToastWidget extends StatelessWidget {
  final String message;
  final UViewType? type;
  final UToastPosition position;
  final bool mask;
  final bool loading;
  final UViewThemeData theme;

  const _ToastWidget({
    required this.message,
    this.type,
    this.position = UToastPosition.center,
    this.mask = false,
    this.loading = false,
    required this.theme,
  });

  IconData? get _icon {
    if (loading) return null;
    switch (type) {
      case UViewType.success:
        return Icons.check_circle;
      case UViewType.error:
        return Icons.cancel;
      case UViewType.warning:
        return Icons.error;
      case UViewType.info:
        return Icons.info;
      default:
        return null;
    }
  }

  Color? get _iconColor {
    if (type == null) return null;
    return theme.colorOf(type!);
  }

  @override
  Widget build(BuildContext context) {
    final align = position == UToastPosition.top
        ? Alignment.topCenter
        : (position == UToastPosition.bottom
            ? Alignment.bottomCenter
            : Alignment.center);
    final pad = position == UToastPosition.top
        ? const EdgeInsets.only(top: 80)
        : (position == UToastPosition.bottom
            ? const EdgeInsets.only(bottom: 80)
            : EdgeInsets.zero);

    final card = Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xE6000000),
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          else if (_icon != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Icon(_icon, color: _iconColor ?? Colors.white, size: 36),
            ),
          UText(
            message,
            color: Colors.white,
            size: 14,
            align: TextAlign.center,
          ),
        ],
      ),
    );

    return Material(
      color: mask ? theme.maskColor.withOpacity(0.3) : Colors.transparent,
      child: Align(
        alignment: align,
        child: Padding(padding: pad, child: card),
      ),
    );
  }
}
