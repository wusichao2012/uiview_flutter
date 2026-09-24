import 'package:flutter/material.dart';
import '../components/u_text.dart';
import '../theme/uview_theme_data.dart';

/// `Grid` 单个宫格项。
class UGridItem {
  final Widget icon;
  final String? label;
  final VoidCallback? onTap;

  const UGridItem({required this.icon, this.label, this.onTap});
}

/// uView `Grid` 宫格。
class UGrid extends StatelessWidget {
  final List<UGridItem> items;
  final int crossAxisCount;
  final double? childAspectRatio;
  final double spacing;

  const UGrid({
    Key? key,
    required this.items,
    this.crossAxisCount = 4,
    this.childAspectRatio,
    this.spacing = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: childAspectRatio ?? 1,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      children: items.map((it) {
        final cell = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            it.icon,
            if (it.label != null) ...[
              const SizedBox(height: 8),
              UText(it.label!, size: 12, type: UViewType.info),
            ],
          ],
        );
        return it.onTap != null
            ? InkWell(onTap: it.onTap, child: cell)
            : cell;
      }).toList(),
    );
  }
}
