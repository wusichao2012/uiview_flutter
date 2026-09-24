import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';

/// uView `Image` 图片组件。
///
/// 支持 [shape]（square/circle）、[radius] 圆角、[fit]、加载占位与失败占位。
/// [src] 可为网络地址或本地 asset（以 `asset://` 前缀区分）。
class UImage extends StatelessWidget {
  final String? src;
  final double? width;
  final double? height;
  final UViewShape shape;
  final double? radius;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const UImage({
    Key? key,
    this.src,
    this.width,
    this.height,
    this.shape = UViewShape.square,
    this.radius,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
    this.onTap,
  }) : super(key: key);

  Widget _placeholder(BuildContext context) {
    final theme = UView.of(context);
    return placeholder ??
        Container(
          color: theme.backgroundColor,
          child: Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: theme.lightTextColor),
            ),
          ),
        );
  }

  Widget _error(BuildContext context) {
    final theme = UView.of(context);
    return errorWidget ??
        Container(
          color: theme.backgroundColor,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.broken_image_outlined, color: theme.lightTextColor, size: 22),
                const SizedBox(height: 4),
                Text('加载失败', style: TextStyle(color: theme.lightTextColor, fontSize: 10)),
              ],
            ),
          ),
        );
  }

  ImageProvider? _resolveProvider() {
    if (src == null) return null;
    if (src!.startsWith('asset://')) {
      return AssetImage(src!.replaceFirst('asset://', ''));
    }
    return NetworkImage(src!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final r = shape == UViewShape.circle ? 999.0 : (radius ?? theme.radius);
    final provider = _resolveProvider();

    Widget img = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.backgroundColor,
        borderRadius: BorderRadius.circular(r),
      ),
      clipBehavior: Clip.antiAlias,
      child: provider == null
          ? _placeholder(context)
          : Image(
              image: provider,
              width: width,
              height: height,
              fit: fit,
              loadingBuilder: (c, child, progress) {
                if (progress == null) return child;
                return _placeholder(c);
              },
              errorBuilder: (c, _, __) => _error(c),
            ),
    );

    if (onTap != null) {
      img = GestureDetector(onTap: onTap, child: img);
    }
    return img;
  }
}
