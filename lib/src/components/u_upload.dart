import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';

/// uView `Upload` 上传项（由调用方提供缩略图与业务值）。
class UUploadItem {
  final Widget thumb;
  final dynamic value;
  final String? name;

  const UUploadItem({required this.thumb, this.value, this.name});
}

/// uView `Upload` 上传格子（UI 壳，上传逻辑由调用方通过 [onAdd] 接入）。
class UUpload extends StatelessWidget {
  final List<UUploadItem> files;
  final int maxCount;
  final ValueChanged<int>? onRemove;
  final VoidCallback? onAdd;
  final double size;
  final double gap;
  final bool showAdd;

  const UUpload({
    Key? key,
    this.files = const [],
    this.maxCount = 9,
    this.onRemove,
    this.onAdd,
    this.size = 80,
    this.gap = 10,
    this.showAdd = true,
  }) : super(key: key);

  Widget _cell(UViewThemeData theme, Widget thumb,
      {bool showClose = false, VoidCallback? onClose}) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: BorderRadius.circular(theme.radiusSm),
              border: Border.all(color: theme.borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: thumb,
          ),
          if (showClose)
            Positioned(
              top: -6,
              right: -6,
              child: GestureDetector(
                onTap: onClose,
                behavior: HitTestBehavior.translucent,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final cells = <Widget>[];
    for (int i = 0; i < files.length; i++) {
      cells.add(_cell(
        theme,
        files[i].thumb,
        showClose: true,
        onClose: () => onRemove?.call(i),
      ));
    }
    if (showAdd && files.length < maxCount) {
      cells.add(
        GestureDetector(
          onTap: onAdd,
          behavior: HitTestBehavior.translucent,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: BorderRadius.circular(theme.radiusSm),
              border: Border.all(color: theme.borderColor),
            ),
            child: Center(
              child: Icon(Icons.add, size: 28, color: theme.lightTextColor),
            ),
          ),
        ),
      );
    }
    return Wrap(spacing: gap, runSpacing: gap, children: cells);
  }
}
