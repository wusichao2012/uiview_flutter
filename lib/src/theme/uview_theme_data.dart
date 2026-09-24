import 'package:flutter/material.dart';

/// uView 主题色类型，与组件 `type` 参数一一对应。
enum UViewType {
  primary,
  success,
  warning,
  error,
  info,
  /// 默认（灰）/ 无强调色
  def,
}

/// 组件尺寸档位。
enum UViewSize {
  mini,
  small,
  medium,
  large,
}

/// 形状。
enum UViewShape {
  square,
  circle,
}

/// uView Flutter 主题数据。
///
/// 默认值尽量还原 uView 官网默认视觉（蓝色主色、轻圆角、克制阴影）。
/// 可通过 [UView] 在应用顶层注入，组件内部用 [UView.of] 读取。
class UViewThemeData {
  // ---- 强调色 ----
  final Color primaryColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;
  final Color infoColor;

  // ---- 文字色 ----
  final Color mainTextColor; // 主要文字 #303133
  final Color contentTextColor; // 常规文字 #606266
  final Color tipsTextColor; // 次要文字 #909399
  final Color lightTextColor; // 占位/禁用文字 #c0c4cc
  final Color inverseTextColor; // 反色文字（用在有色背景上）#ffffff

  // ---- 背景/边框 ----
  final Color backgroundColor; // 页面/容器背景 #f3f4f6
  final Color surfaceColor; // 卡片/表面背景 #ffffff
  final Color borderColor; // 分割线/边框 #e4e7ed
  final Color disabledBgColor; // 禁用背景 #c8c9cc
  final Color maskColor; // 遮罩 #000000 (带透明度由组件控制)

  // ---- 圆角 ----
  final double radiusSm;
  final double radius;
  final double radiusLg;
  final double radiusXl;

  // ---- 字号 ----
  final double fontSizeSm; // 22rpx 约 11sp
  final double fontSize; // 28rpx 约 14sp
  final double fontSizeLg; // 30rpx 约 15sp
  final double fontSizeXl; // 36rpx 约 18sp
  final double fontSizeXxl; // 44rpx 约 22sp

  // ---- 间距 ----
  final double gapSm;
  final double gap;
  final double gapLg;

  const UViewThemeData({
    this.primaryColor = const Color(0xFF3C9CFF),
    this.successColor = const Color(0xFF5AC725),
    this.warningColor = const Color(0xFFF9AE3D),
    this.errorColor = const Color(0xFFF56C6C),
    this.infoColor = const Color(0xFF909399),
    this.mainTextColor = const Color(0xFF303133),
    this.contentTextColor = const Color(0xFF606266),
    this.tipsTextColor = const Color(0xFF909399),
    this.lightTextColor = const Color(0xFFC0C4CC),
    this.inverseTextColor = const Color(0xFFFFFFFF),
    this.backgroundColor = const Color(0xFFF3F4F6),
    this.surfaceColor = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFFE4E7ED),
    this.disabledBgColor = const Color(0xFFC8C9CC),
    this.maskColor = const Color(0xFF000000),
    this.radiusSm = 4.0,
    this.radius = 8.0,
    this.radiusLg = 12.0,
    this.radiusXl = 16.0,
    this.fontSizeSm = 11.0,
    this.fontSize = 14.0,
    this.fontSizeLg = 15.0,
    this.fontSizeXl = 18.0,
    this.fontSizeXxl = 22.0,
    this.gapSm = 8.0,
    this.gap = 12.0,
    this.gapLg = 16.0,
  });

  /// 默认主题（与构造默认值一致，便于无 Context 场景使用）。
  factory UViewThemeData.fallback() => const UViewThemeData();

  /// 取强调色（供组件 type 使用）。
  Color colorOf(UViewType type) {
    switch (type) {
      case UViewType.primary:
        return primaryColor;
      case UViewType.success:
        return successColor;
      case UViewType.warning:
        return warningColor;
      case UViewType.error:
        return errorColor;
      case UViewType.info:
        return infoColor;
      case UViewType.def:
        return infoColor;
    }
  }

  UViewThemeData copyWith({
    Color? primaryColor,
    Color? successColor,
    Color? warningColor,
    Color? errorColor,
    Color? infoColor,
    Color? mainTextColor,
    Color? contentTextColor,
    Color? tipsTextColor,
    Color? lightTextColor,
    Color? inverseTextColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? borderColor,
    Color? disabledBgColor,
    Color? maskColor,
    double? radiusSm,
    double? radius,
    double? radiusLg,
    double? radiusXl,
    double? fontSizeSm,
    double? fontSize,
    double? fontSizeLg,
    double? fontSizeXl,
    double? fontSizeXxl,
    double? gapSm,
    double? gap,
    double? gapLg,
  }) {
    return UViewThemeData(
      primaryColor: primaryColor ?? this.primaryColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      errorColor: errorColor ?? this.errorColor,
      infoColor: infoColor ?? this.infoColor,
      mainTextColor: mainTextColor ?? this.mainTextColor,
      contentTextColor: contentTextColor ?? this.contentTextColor,
      tipsTextColor: tipsTextColor ?? this.tipsTextColor,
      lightTextColor: lightTextColor ?? this.lightTextColor,
      inverseTextColor: inverseTextColor ?? this.inverseTextColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      borderColor: borderColor ?? this.borderColor,
      disabledBgColor: disabledBgColor ?? this.disabledBgColor,
      maskColor: maskColor ?? this.maskColor,
      radiusSm: radiusSm ?? this.radiusSm,
      radius: radius ?? this.radius,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusXl: radiusXl ?? this.radiusXl,
      fontSizeSm: fontSizeSm ?? this.fontSizeSm,
      fontSize: fontSize ?? this.fontSize,
      fontSizeLg: fontSizeLg ?? this.fontSizeLg,
      fontSizeXl: fontSizeXl ?? this.fontSizeXl,
      fontSizeXxl: fontSizeXxl ?? this.fontSizeXxl,
      gapSm: gapSm ?? this.gapSm,
      gap: gap ?? this.gap,
      gapLg: gapLg ?? this.gapLg,
    );
  }
}
