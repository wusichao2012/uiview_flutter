import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';

/// uView `Badge` 徽标数组件。
///
/// 既可包裹子组件（[child] + [absolute] 右上角角标），也可独立展示。
/// 支持数字 [count]、[isDot] 圆点、[overflowCount] 溢出（如 99+）、[type] 强调色。
class UBadge extends StatelessWidget {
  final Widget? child;
  final String? text;
  final int? count;
  final bool isDot;
  final bool showZero;
  final bool show;
  final int overflowCount;
  final bool absolute;
  final UViewType type;
  final Color? bgColor;
  final Offset? offset;
  final double? dotSize;

  const UBadge({
    Key? key,
    this.child,
    this.text,
    this.count,
    this.isDot = false,
    this.showZero = false,
    this.show = true,
    this.overflowCount = 99,
    this.absolute = true,
    this.type = UViewType.error,
    this.bgColor,
    this.offset,
    this.dotSize = 8,
  }) : super(key: key);

  String? _resolveText(UViewThemeData theme) {
    if (text != null) return text;
    if (count == null) return null;
    if (count == 0 && !showZero) return null;
    if (count! > overflowCount) return '$overflowCount+';
    return count.toString();
  }

  Widget _buildBadge(UViewThemeData theme) {
    final Color color = bgColor ?? theme.colorOf(type);
    if (isDot) {
      return Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
    }
    final label = _resolveText(theme);
    if (label == null) return const SizedBox.shrink();
    return Container(
      constraints: const BoxConstraints(minWidth: 16),
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 10, height: 1.1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    if (!show) return child ?? const SizedBox.shrink();

    final badge = _buildBadge(theme);
    if (child == null) return badge;

    if (!absolute) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [child!, const SizedBox(width: 4), badge],
      );
    }

    final dx = offset?.dx ?? 0.0;
    final dy = offset?.dy ?? 0.0;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(
          top: -4 + dy,
          right: -4 - dx,
          child: badge,
        ),
      ],
    );
  }
}
