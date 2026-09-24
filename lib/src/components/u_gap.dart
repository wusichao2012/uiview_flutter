import 'package:flutter/material.dart';

/// uView `Gap` 间隔槽，用于在布局中插入固定间距。
class UGap extends StatelessWidget {
  final double? height;
  final double? width;

  const UGap({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(height: height, width: width);
}
