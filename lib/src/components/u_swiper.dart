import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/uview.dart';

/// uView `Swiper` 轮播图。
class USwiper extends StatefulWidget {
  final List<Widget> children;
  final double height;
  final bool indicator;
  final bool autoplay;
  final Duration autoplayInterval;
  final ValueChanged<int>? onChanged;
  final Color? indicatorColor;

  const USwiper({
    Key? key,
    required this.children,
    this.height = 160,
    this.indicator = true,
    this.autoplay = false,
    this.autoplayInterval = const Duration(seconds: 3),
    this.onChanged,
    this.indicatorColor,
  }) : super(key: key);

  @override
  _USwiperState createState() => _USwiperState();
}

class _USwiperState extends State<USwiper> {
  late PageController _pc;
  int _idx = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pc = PageController();
    if (widget.autoplay && widget.children.length > 1) _start();
  }

  void _start() {
    _timer = Timer.periodic(widget.autoplayInterval, (_) {
      if (_idx < widget.children.length - 1) {
        _pc.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      } else {
        _pc.animateToPage(0,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final color = widget.indicatorColor ?? theme.primaryColor;
    return Container(
      height: widget.height,
      child: Stack(
        children: [
          PageView(
            children: widget.children,
            controller: _pc,
            onPageChanged: (i) {
              setState(() => _idx = i);
              widget.onChanged?.call(i);
            },
          ),
          if (widget.indicator && widget.children.length > 1)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.children.length, (i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _idx == i ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _idx == i
                          ? color
                          : theme.lightTextColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
