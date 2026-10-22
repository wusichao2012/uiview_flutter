// 自动遍历 uview_flutter 全部 demo 并截图，用于生成组件文档。
// 运行：flutter test integration_test/screenshot_all.dart -d emulator-5554
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uview_flutter/uview_flutter.dart';

import '../lib/demos.dart';
import '../lib/pages/demo_page.dart';

late final String _outDir;

// 需要交互触发才能看到完整效果的组件：name -> 触发动作。
typedef Trigger = Future<void> Function(WidgetTester t);

final Map<String, Trigger> _triggers = {
  'Toast 轻提示': (t) async => t.tap(find.text('普通')),
  'Modal 模态框': (t) async => t.tap(find.text('打开模态框')),
  'Popup 弹出层': (t) async => t.tap(find.text('底部')),
  'ActionSheet 操作菜单': (t) async => t.tap(find.text('打开操作菜单')),
  'Picker 滚轮选择器': (t) async => t.tap(find.text('直接弹出')),
  'Calendar 日历': (t) async => t.tap(find.text('弹窗选择')),
  'Keyboard 键盘': (t) async => t.tap(find.text('唤起键盘')),
  'Select 选择器': (t) async => t.tap(find.text('请选择城市')),
  'Dropdown 下拉菜单': (t) async => t.tap(_byRuntimeType('UDropdown')),
  'Tabs 标签页': (t) async => t.tap(find.text('标签二')),
  'Collapse 折叠面板': (t) async => t.tap(find.text('面板二')),
  'SwipeAction 滑动': (t) async => t.fling(
      _byRuntimeType('USwipeActionCell'), const Offset(-300, 0), 1000),
  'FloatingBall 悬浮球': (t) async => t.tap(_byRuntimeType('UFloatingBall')),
  'Upload 上传': (t) async => t.tap(find.byIcon(Icons.add)),
  'Form 表单': (t) async => t.tap(find.text('校验提交')),
};

// 按运行时类型匹配控件。
Finder _byRuntimeType(String typeName) =>
    find.byElementPredicate((e) => '${e.widget.runtimeType}' == typeName);

Future<void> _frame(WidgetTester t) async {
  // 部分 demo 含持续动画（Swiper/CountDown/CountTo），pumpAndSettle 会超时，
  // 这里统一只 pump 一帧 + 等待 500ms 让布局稳定。
  await t.pump();
  await t.pump(const Duration(milliseconds: 500));
}

Future<void> _save(IntegrationTestWidgetsFlutterBinding binding, String file) async {
  final Uint8List bytes = Uint8List.fromList(await binding.takeScreenshot(file));
  final f = File('$_outDir/$file');
  await f.writeAsBytes(bytes);
  // ignore: avoid_print
  print('SHOT $file (${bytes.length} bytes)');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture all demos', (WidgetTester tester) async {
    final binding =
        tester.binding as IntegrationTestWidgetsFlutterBinding;

    // Android 上截图前需把 Flutter Surface 转为 ImageView。
    await binding.convertFlutterSurfaceToImage();

    // 每次运行用独立时间戳目录，避免被上次安装残留（不同 UID 拥有）的目录阻塞写入。
    _outDir =
        '/sdcard/Download/uview_shots_${DateTime.now().millisecondsSinceEpoch}';
    Directory(_outDir).createSync(recursive: true);
    // ignore: avoid_print
    print('OUTDIR $_outDir');
    final manifest = <String>[];

    var index = 0;
    for (final entry in demoRegistry.entries) {
      final category = entry.key;
      for (final item in entry.value) {
        index++;
        final slug = 'c${index.toString().padLeft(2, '0')}';
        manifest.add('$slug|$category|${item.name}|${item.description ?? ''}');

        final page = UView(
          theme: const UViewThemeData(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: DemoPage(category: category, item: item),
          ),
        );

        // 基础截图（默认渲染效果）。
        await tester.pumpWidget(page);
        await _frame(tester);
        await _save(binding, '$slug.png');

        // 交互触发后二次截图。
        final trigger = _triggers[item.name];
        if (trigger != null) {
          try {
            await trigger(tester);
            await _frame(tester);
            await _save(binding, '${slug}_open.png');
          } catch (e) {
            // ignore: avoid_print
            print('TRIGGER_FAIL ${item.name}: $e');
          }
        }

        // 复位，避免 overlay 残留影响下一个 demo。
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      }
    }

    await File('$_outDir/manifest.txt')
        .writeAsString(manifest.join('\n'));
    // ignore: avoid_print
    print('MANIFEST ${manifest.length} entries');
  });
}
