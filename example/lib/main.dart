import 'package:flutter/material.dart';
import 'package:uview_flutter/uview_flutter.dart';
import 'pages/home_page.dart';

void main() => runApp(const MyApp());

/// 示例应用：在顶层用 [UView] 注入主题（对标 uView ConfigProvider），
/// 可在运行时调用 [UView.update] 切换主题。
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UView(
      theme: const UViewThemeData(),
      child: Builder(
        builder: (context) {
          final theme = UView.of(context);
          return MaterialApp(
            title: 'uView Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: theme.primaryColor,
              scaffoldBackgroundColor: theme.backgroundColor,
              fontFamily: 'PingFang SC',
            ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
