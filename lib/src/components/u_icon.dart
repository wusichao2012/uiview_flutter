import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';

/// uView 风格 `Icon`，统一使用主题色，并支持按名称取图标。
///
/// [name] 会从 [UViewIcons] 映射表中查找常用 uView 图标名（已对齐到 Material 图标），
/// 找不到时回退到 [icon] 或问号图标。
class UIcon extends StatelessWidget {
  final IconData? icon;
  final String? name;
  final UViewType? type;
  final Color? color;
  final double? size;
  final VoidCallback? onTap;

  const UIcon({
    Key? key,
    this.icon,
    this.name,
    this.type,
    this.color,
    this.size,
    this.onTap,
  }) : super(key: key);

  static const Map<String, IconData> UViewIcons = {
    'photo': Icons.photo_outlined,
    'photo-fill': Icons.photo,
    'setting': Icons.settings_outlined,
    'setting-fill': Icons.settings,
    'star': Icons.star_border,
    'star-fill': Icons.star,
    'heart': Icons.favorite_border,
    'heart-fill': Icons.favorite,
    'search': Icons.search,
    'close': Icons.close,
    'check': Icons.check,
    'check-circle': Icons.check_circle_outline,
    'check-circle-fill': Icons.check_circle,
    'info-circle': Icons.info_outline,
    'info-circle-fill': Icons.info,
    'warning': Icons.warning_amber_outlined,
    'warning-fill': Icons.warning,
    'error-circle': Icons.error_outline,
    'error-circle-fill': Icons.error,
    'question': Icons.help_outline,
    'plus': Icons.add,
    'minus': Icons.remove,
    'arrow-right': Icons.chevron_right,
    'arrow-left': Icons.chevron_left,
    'arrow-up': Icons.keyboard_arrow_up,
    'arrow-down': Icons.keyboard_arrow_down,
    'phone': Icons.phone,
    'email': Icons.email_outlined,
    'location': Icons.location_on_outlined,
    'user': Icons.person_outline,
    'lock': Icons.lock_outline,
    'eye': Icons.visibility_outlined,
    'eye-off': Icons.visibility_off_outlined,
    'edit': Icons.edit_outlined,
    'trash': Icons.delete_outline,
    'thumb-up': Icons.thumb_up_alt_outlined,
    'thumb-down': Icons.thumb_down_alt_outlined,
    'share': Icons.share_outlined,
    'more': Icons.more_horiz,
    'home': Icons.home_outlined,
    'home-fill': Icons.home,
    'bell': Icons.notifications_none,
    'camera': Icons.camera_alt_outlined,
    'scan': Icons.qr_code_scanner_outlined,
  };

  IconData _resolveIcon() {
    if (icon != null) return icon!;
    if (name != null && UViewIcons.containsKey(name)) return UViewIcons[name]!;
    return Icons.help_outline;
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final Color resolved = color ??
        (type != null && type != UViewType.def ? theme.colorOf(type!) : theme.contentTextColor);
    final Widget ic = Icon(_resolveIcon(), color: resolved, size: size ?? theme.fontSizeXl);
    if (onTap == null) return ic;
    return GestureDetector(onTap: onTap, child: ic);
  }
}
