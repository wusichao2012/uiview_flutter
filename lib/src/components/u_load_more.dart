import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../components/u_text.dart';

/// `LoadMore` 状态。
enum ULoadMoreStatus { normal, loading, noMore }

/// uView `LoadMore` 加载更多指示器。
class ULoadMore extends StatelessWidget {
  final ULoadMoreStatus status;
  final VoidCallback? onLoad;
  final String loadingText;
  final String noMoreText;
  final String normalText;

  const ULoadMore({
    Key? key,
    this.status = ULoadMoreStatus.normal,
    this.onLoad,
    this.loadingText = '加载中...',
    this.noMoreText = '没有更多了',
    this.normalText = '点击加载更多',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    Widget content;
    if (status == ULoadMoreStatus.loading) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(theme.tipsTextColor),
            ),
          ),
          const SizedBox(width: 8),
          UText(loadingText, size: 13, color: theme.tipsTextColor),
        ],
      );
    } else if (status == ULoadMoreStatus.noMore) {
      content = UText(noMoreText, size: 13, color: theme.tipsTextColor);
    } else {
      content = GestureDetector(
        onTap: onLoad,
        behavior: HitTestBehavior.translucent,
        child: UText(normalText, size: 13, color: theme.tipsTextColor),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(child: content),
    );
  }
}
