import 'package:flutter/material.dart';
import 'package:uview_flutter/uview_flutter.dart';
import '../demos.dart';

/// 单个组件的演示页。
class DemoPage extends StatelessWidget {
  final String category;
  final DemoItem item;

  const DemoPage({Key? key, required this.category, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.inverseTextColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (item.description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: UTag(text: item.description!, plain: true, type: UViewType.info),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.surfaceColor,
              borderRadius: BorderRadius.circular(theme.radius),
            ),
            child: item.demo,
          ),
        ],
      ),
    );
  }
}
