import 'package:flutter/material.dart';

/// 颜色工具：在 uView 风格组件里常用于计算 plain（清淡）背景、禁用色等。
class UViewColorUtils {
  UViewColorUtils._();

  /// 将颜色按 [amount] (0~1) 向白色混合，得到浅色（用于 plain 背景）。
  static Color lighten(Color color, double amount) {
    assert(amount >= 0 && amount <= 1, 'amount 需在 0~1 之间');
    final hsl = HSLColor.fromColor(color);
    final lightened = hsl.withLightness((hsl.lightness + (1 - hsl.lightness) * amount).clamp(0.0, 1.0));
    return lightened.toColor();
  }

  /// 将颜色按 [amount] (0~1) 向黑色混合，得到深色（用于按下态）。
  static Color darken(Color color, double amount) {
    assert(amount >= 0 && amount <= 1, 'amount 需在 0~1 之间');
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness((hsl.lightness * (1 - amount)).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  /// 带透明度版本。
  static Color withAlpha(Color color, double opacity) {
    return color.withOpacity(opacity.clamp(0.0, 1.0));
  }
}
