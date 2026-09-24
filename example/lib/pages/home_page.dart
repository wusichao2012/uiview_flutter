import 'package:flutter/material.dart';
import 'package:uview_flutter/uview_flutter.dart';
import '../demos.dart';
import 'demo_page.dart';

/// Demo 首页：按 uView 分类展示组件入口。
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('uView Flutter'),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.inverseTextColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: demoRegistry.entries.map((entry) {
          final category = entry.key;
          final items = entry.value;
          return UCol(
            crossAxisAlignment: CrossAxisAlignment.start,
            gap: 8,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 8, bottom: 4),
                child: UText(category, bold: true, size: 15, type: UViewType.info),
              ),
              ...items.map((item) => _ComponentCard(item: item, category: category)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ComponentCard extends StatelessWidget {
  final DemoItem item;
  final String category;
  const _ComponentCard({required this.item, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    return Material(
      color: theme.surfaceColor,
      borderRadius: BorderRadius.circular(theme.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(theme.radius),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DemoPage(category: category, item: item),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UText(item.name, bold: true, size: 15),
                    if (item.description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: UText(item.description!, size: 12, type: UViewType.info),
                      ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: theme.lightTextColor),
            ],
          ),
        ),
      ),
    );
  }
}
