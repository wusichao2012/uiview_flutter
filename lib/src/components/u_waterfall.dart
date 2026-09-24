import 'package:flutter/material.dart';

/// uView `Waterfall` 瀑布流：多列不等高布局。
///
/// 采用「按列分组」的纯框架实现（无第三方依赖）：
/// 将 [children] 按索引取模分配到 [columnCount] 个 `Column`，外层用
/// `Row` 平铺。组件本身不滚动，请放在可滚动容器内使用。
class UWaterfall extends StatelessWidget {
  final List<Widget> children;
  final int columnCount;
  final double spacing;
  final Widget? header;
  final EdgeInsetsGeometry? padding;

  const UWaterfall({
    Key? key,
    required this.children,
    this.columnCount = 2,
    this.spacing = 8,
    this.header,
    this.padding,
  })  : assert(columnCount > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final columns = List.generate(columnCount, (_) => <Widget>[]);
    for (int i = 0; i < children.length; i++) {
      columns[i % columnCount].add(children[i]);
    }

    final colWidgets = columns.map((items) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int j = 0; j < items.length; j++) ...[
              if (j > 0) SizedBox(height: spacing),
              items[j],
            ],
          ],
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null) header!,
        if (header != null) SizedBox(height: spacing),
        Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int c = 0; c < colWidgets.length; c++) ...[
                if (c > 0) SizedBox(width: spacing),
                colWidgets[c],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
