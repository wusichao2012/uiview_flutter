#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""根据示例应用源码与自动截图生成组件库使用说明文档。

数据来源：
  - docs/screenshots/manifest.txt   （截图脚本产物：slug|分类|名称|说明）
  - docs/screenshots/cXX.png        （组件默认效果截图）
  - docs/screenshots/cXX_open.png   （交互类组件的展开效果截图，可能不存在）
  - example/lib/demos.dart          （组件用法示例源码）

输出：
  - docs/components.md
"""
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SHOTS = os.path.join(ROOT, 'docs', 'screenshots')
MANIFEST = os.path.join(SHOTS, 'manifest.txt')
DEMOS = os.path.join(ROOT, 'example', 'lib', 'demos.dart')
OUT = os.path.join(ROOT, 'docs', 'components.md')

CATEGORY_ORDER = ['基础组件', '表单组件', '反馈组件', '导航组件', '布局组件', '数据/其他', '其他组件']


def read(path):
    with open(path, encoding='utf-8') as f:
        return f.read()


def extract_class(src, class_name):
    """提取某个类的完整源码（含花括号块）。"""
    m = re.search(r'^class\s+' + re.escape(class_name) + r'\b', src, re.M)
    if not m:
        return None
    start = m.start()
    i = src.index('{', m.end() - 1 if m.end() else start)
    depth = 0
    j = i
    while j < len(src):
        c = src[j]
        if c == '{':
            depth += 1
        elif c == '}':
            depth -= 1
            if depth == 0:
                j += 1
                break
        j += 1
    return src[start:j]


def main():
    src = read(DEMOS)

    # name -> demo 类名（从注册表解析：DemoItem('名称', const XxxDemo())）
    name_to_class = dict(re.findall(r"DemoItem\(\s*'([^']+)'\s*,\s*const\s+(\w+)\(\)", src))

    entries = []
    for line in read(MANIFEST).splitlines():
        if not line.strip():
            continue
        slug, category, name, desc = line.split('|', 3)
        entries.append((slug, category, name, desc))

    lines = []
    add = lines.append

    add('# uView Flutter 组件库使用说明')
    add('')
    add('> 本文档由示例应用自动截图生成，截图来自 Android 模拟器（API 36）。')
    add('> 每个组件包含**效果截图**与**用法示例**；带“交互效果”的组件需点击后才会出现对应界面。')
    add('')
    add('## 快速开始')
    add('')
    add('在应用顶层用 `UView` 注入主题后即可使用全部组件：')
    add('')
    add('```dart')
    add("import 'package:flutter/material.dart';")
    add("import 'package:uview_flutter/uview_flutter.dart';")
    add('')
    add('void main() => runApp(const MyApp());')
    add('')
    add('class MyApp extends StatelessWidget {')
    add('  const MyApp({Key? key}) : super(key: key);')
    add('')
    add('  @override')
    add('  Widget build(BuildContext context) {')
    add('    return UView(')
    add('      theme: const UViewThemeData(),')
    add('      child: MaterialApp(home: const HomePage()),')
    add('    );')
    add('  }')
    add('}')
    add('```')
    add('')
    add('运行时可通过 `UView.update(context, ...)` 切换主题。')
    add('')

    # 目录
    add('## 组件总览')
    add('')
    by_cat = {}
    for slug, category, name, desc in entries:
        by_cat.setdefault(category, []).append((slug, name, desc))
    for category in CATEGORY_ORDER:
        if category not in by_cat:
            continue
        add(f'**{category}**')
        add('')
        for slug, name, desc in by_cat[category]:
            add(f'- [{name}](#{name.lower().replace(" ", "-")}) — {desc}')
        add('')

    # 各分类详情
    for category in CATEGORY_ORDER:
        if category not in by_cat:
            continue
        add(f'## {category}')
        add('')
        for slug, name, desc in by_cat[category]:
            add(f'### {name}')
            add('')
            add(f'**说明**：{desc}')
            add('')
            add(f'![{name} 效果](screenshots/{slug}.png)')
            add('')
            open_png = os.path.join(SHOTS, f'{slug}_open.png')
            if os.path.exists(open_png):
                add(f'交互效果：')
                add('')
                add(f'![{name} 交互效果](screenshots/{slug}_open.png)')
                add('')
            cls = name_to_class.get(name)
            snippet = None
            if cls:
                parts = [extract_class(src, cls)]
                # StatefulWidget 的构建逻辑在对应的 State 类中，一并展示。
                state_cls = extract_class(src, '_' + cls + 'State')
                if state_cls:
                    parts.append(state_cls)
                snippet = '\n\n'.join(p for p in parts if p)
            if snippet:
                add('<details>')
                add('<summary>用法示例（点击展开）</summary>')
                add('')
                add('```dart')
                add(snippet.rstrip())
                add('```')
                add('')
                add('</details>')
                add('')

    with open(OUT, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines).rstrip() + '\n')

    print(f'written {OUT} ({len(entries)} components)')


if __name__ == '__main__':
    main()
