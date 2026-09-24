import 'package:flutter/material.dart';
import '../theme/uview.dart';

/// uView `Popup` 弹出方向。
enum UPopupPosition { top, bottom, center, left, right }

/// uView `Popup` 通用弹出层（带遮罩与淡入动画）。
class UPopup {
  const UPopup._();

  /// 弹出自定义内容。
  /// [position] 控制从哪个方向出现；返回 Future 在关闭时 resolve。
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    UPopupPosition position = UPopupPosition.bottom,
    bool barrierDismissible = true,
    bool round = true,
    Color? backgroundColor,
  }) {
    final theme = UView.of(context);
    final bg = backgroundColor ?? theme.surfaceColor;
    final radius = round ? theme.radiusLg : 0.0;

    late final Alignment align;
    switch (position) {
      case UPopupPosition.top:
        align = Alignment.topCenter;
        break;
      case UPopupPosition.bottom:
        align = Alignment.bottomCenter;
        break;
      case UPopupPosition.center:
        align = Alignment.center;
        break;
      case UPopupPosition.left:
        align = Alignment.centerLeft;
        break;
      case UPopupPosition.right:
        align = Alignment.centerRight;
        break;
    }

    BorderRadius? borderRadius;
    switch (position) {
      case UPopupPosition.top:
        borderRadius = BorderRadius.vertical(bottom: Radius.circular(radius));
        break;
      case UPopupPosition.bottom:
        borderRadius = BorderRadius.vertical(top: Radius.circular(radius));
        break;
      case UPopupPosition.left:
        borderRadius = BorderRadius.horizontal(right: Radius.circular(radius));
        break;
      case UPopupPosition.right:
        borderRadius = BorderRadius.horizontal(left: Radius.circular(radius));
        break;
      case UPopupPosition.center:
        borderRadius = BorderRadius.circular(radius);
        break;
    }

    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        opaque: false,
        barrierDismissible: barrierDismissible,
        barrierColor: theme.maskColor.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (_, anim, __) {
          final panel = Material(
            color: bg,
            borderRadius: borderRadius,
            child: SafeArea(child: child),
          );
          return FadeTransition(
            opacity: anim,
            child: Align(alignment: align, child: panel),
          );
        },
      ),
    );
  }
}
