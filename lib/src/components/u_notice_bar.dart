import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// uView `NoticeBar` 右侧模式。
enum UNoticeBarMode { none, closeable, link }

/// uView `NoticeBar` 滚动通知条。
class UNoticeBar extends StatefulWidget {
  final String text;
  final Widget? icon;
  final UNoticeBarMode mode;
  final bool scrollable;
  final VoidCallback? onClose;
  final VoidCallback? onTap;
  final UViewType? type;

  const UNoticeBar({
    Key? key,
    required this.text,
    this.icon,
    this.mode = UNoticeBarMode.none,
    this.scrollable = true,
    this.onClose,
    this.onTap,
    this.type,
  }) : super(key: key);

  @override
  _UNoticeBarState createState() => _UNoticeBarState();
}

class _UNoticeBarState extends State<UNoticeBar> {
  bool _closed = false;

  @override
  Widget build(BuildContext context) {
    if (_closed) return const SizedBox.shrink();
    final theme = UView.of(context);
    final color = theme.colorOf(widget.type ?? UViewType.warning);

    List<Widget> trailing = [];
    if (widget.mode == UNoticeBarMode.closeable) {
      trailing.add(GestureDetector(
        onTap: () {
          setState(() => _closed = true);
          widget.onClose?.call();
        },
        behavior: HitTestBehavior.translucent,
        child: Icon(Icons.close, size: 16, color: theme.tipsTextColor),
      ));
    } else if (widget.mode == UNoticeBarMode.link) {
      trailing.add(GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.translucent,
        child: Icon(Icons.chevron_right, size: 18, color: theme.tipsTextColor),
      ));
    }

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        color: theme.colorOf(widget.type ?? UViewType.warning)
            .withOpacity(0.12),
        child: Row(
          children: [
            if (widget.icon != null) ...[
              widget.icon!,
              const SizedBox(width: 6),
            ] else
              Icon(Icons.volume_up, size: 16, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: widget.scrollable
                  ? _Marquee(
                      text: widget.text,
                      color: theme.contentTextColor,
                      size: theme.fontSize,
                    )
                  : UText(
                      widget.text,
                      color: theme.contentTextColor,
                      size: theme.fontSize,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            ...trailing,
          ],
        ),
      ),
    );
  }
}

class _Marquee extends StatefulWidget {
  final String text;
  final Color color;
  final double size;
  const _Marquee({required this.text, required this.color, required this.size});

  @override
  _MarqueeState createState() => _MarqueeState();
}

class _MarqueeState extends State<_Marquee> {
  final ScrollController _c = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loop());
  }

  Future<void> _loop() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!mounted || !_c.hasClients) break;
      final max = _c.position.maxScrollExtent;
      if (max <= 0) continue;
      await _c.animateTo(max,
          duration: Duration(milliseconds: (max * 18).round()),
          curve: Curves.linear);
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) break;
      _c.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _c,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        widget.text,
        style: TextStyle(color: widget.color, fontSize: widget.size),
      ),
    );
  }
}
