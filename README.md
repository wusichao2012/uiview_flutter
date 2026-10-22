# uview_flutter

uView UI 组件库的 **Flutter 社区复刻版**，对标 [uView Pro](https://uviewpro.cn) 的组件体系与默认视觉。
组件在线文档:[docs](https://wusichao2012.github.io/uiview_flutter/site/components.html)

> 顶层用 `UView` 注入主题（对标 uView 的 `ConfigProvider`），组件内部通过 `UView.of(context)` 读取主题 token；全量组件贴近 uView 默认蓝色风格、走主题色 `type`。

## 特性

- **主题系统**：`UViewThemeData` 提供 uView 默认蓝/成功/警告/错误/信息色、圆角、字号、间距 token；支持运行时 `UView.update` 切换主题。
- **零额外依赖**：仅依赖 Flutter 框架与 `cupertino_icons`，所有组件纯框架实现。
- **Dart 2.17 兼容**：未使用 records / pattern 等 Dart 3 特性，对老项目友好。
- **配套 Demo**：`example/` 工程按 uView 分类提供可交互预览页。

## 安装

```yaml
dependencies:
  uview_flutter:
    git:
      url: https://github.com/your-org/uview_flutter
      ref: main
```

或本地 `path` 依赖：

```yaml
dependencies:
  uview_flutter:
    path: ../uview_flutter
```

## 快速开始

```dart
import 'package:flutter/material.dart';
import 'package:uview_flutter/uview_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return UView(
      theme: const UViewThemeData(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('uView Flutter')),
          body: UCol(
            gap: 12,
            children: [
              const UText('欢迎使用 uview_flutter', bold: true, size: 18),
              const UButton(text: '主要按钮', type: UViewType.primary),
              const UButton(text: '成功', type: UViewType.success),
              UCell(title: '地址', value: '杭州', isLink: true),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 主题定制

```dart
UView(
  theme: const UViewThemeData(primaryColor: Colors.deepPurple),
  child: ...,
);

// 运行时切换
UView.update(context, const UViewThemeData(primaryColor: Colors.teal));
```

## 组件总览

共 **55** 个组件类（含组合组件），覆盖 uView 8 大类。

| 分类 | 组件 |
| --- | --- |
| **主题/全局** | `UView` / `UViewThemeData` / `UViewType` / `UViewSize` / `UViewShape` |
| **基础组件 (11)** | `UText` `UButton` `UTag` `UBadge` `UCell`(+`UCellGroup`) `UIcon` `UImage` `ULoading` `UGap` `URow`/`UCol` `UDivider` |
| **表单组件 (17)** | `UInput` `UTextarea` `USearch` `UVerificationCode` `UForm`(+`UFormItem`/`UFormController`) `UCheckbox`(+`Group`/`Option`) `URadio`(+`Group`/`Option`) `USwitch` `USelect`(+`Option`) `UNumberBox` `USlider` `URate` `UPicker`(+`PickerField`) `UCalendar` `UUpload`(+`Item`) `UKeyboard` |
| **反馈组件 (8)** | `UToast` `UAlertTips` `UModal` `UPopup` `UActionSheet` `UNoticeBar` `UCollapse`(+`Item`) `USwipeAction`(+`Action`) |
| **导航组件 (6)** | `UNavbar` `UTabbar`(+`Item`) `UTabs` `USteps` `UDropdown` `UBackTop` |
| **布局组件 (7)** | `UGrid`(+`Item`) `USwiper` `UAvatar` `UEmpty` `USkeleton` `USticky` `UWaterfall` |
| **数据/其他 (5)** | `UProgress` `UCountDown` `UCountTo` `UCard` `ULoadMore` |
| **其他组件 (1)** | `UFloatingBall`(+`Action`) |

## 目录结构

```
uview_flutter/
├── lib/
│   ├── uview_flutter.dart        # 统一 barrel 导出
│   └── src/
│       ├── theme/                # 主题与全局配置
│       ├── utils/                # 颜色等工具
│       └── components/           # 全部组件
└── example/                      # 可运行 Demo（分类预览）
```

## 运行 Demo

```bash
cd uview_flutter/example
flutter pub get
flutter run
```

> 注：若所在网络无法访问 `storage.googleapis.com` 的默认 pub 源，可改用国内镜像：
> `PUB_HOSTED_URL=https://mirrors.tuna.tsinghua.edu.cn/dart-pub/ flutter pub get`

## 许可证

Apache License
