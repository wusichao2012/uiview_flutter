#!/usr/bin/env python3
"""生成 uview_flutter 组件库静态文档站点。

读取 docs/components.md，输出：
  docs/site/index.html       落地页（特性 / 安装 / 快速开始 / 分类 / MIT）
  docs/site/components.html   组件文档（侧边栏导航 + 锚点 + 截图 + 用法源码）
  docs/site/assets/screenshots/*   复制自 docs/screenshots

用法： python3 docs/gen_site.py
"""
import os
import re
import shutil

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DOCS = os.path.join(ROOT, "docs")
SITE = os.path.join(DOCS, "site")
ASSETS = os.path.join(SITE, "assets")
SHOTS_DST = os.path.join(ASSETS, "screenshots")

# 开源仓库地址（部署时替换为你真实的 GitHub 仓库）
REPO_URL = "https://github.com/your-org/uview_flutter"
SITE_TITLE = "uView Flutter"
SITE_DESC = "uView UI 组件库的 Flutter 社区复刻版 · 主题系统 + 50+ 基础组件"

# ---------------------------------------------------------------------------
# Markdown -> HTML 转换（仅覆盖本文档用到的语法）
# ---------------------------------------------------------------------------

def slugify(text):
    s = text.strip().lower()
    # 保留中文与单词字符，其余替换为 '-'
    s = re.sub(r"[^\w\u4e00-\u9fff]+", "-", s)
    s = re.sub(r"-+", "-", s).strip("-")
    return s or "section"


def inline(text):
    text = text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
    text = re.sub(r"`([^`]+)`", r"<code>\1</code>", text)
    text = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", text)
    return text


def highlight_dart(code):
    """对转义后的 Dart 代码做轻量着色（自包含，无外部依赖）。"""
    pattern = re.compile(
        r"""("(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*')|   # 1 字符串
            (//[^\n]*)|                              # 2 行注释
            (/\*[^\n]*\*/)|                          # 3 块注释
            (\b\d+\.?\d*\b)|                         # 4 数字
            (\b(?:class|extends|implements|with|const|final|var|void|return|if|else|for|while|import|export|library|part|new|this|static|async|await|null|true|false|required|super|typedef|enum|abstract|mixin|factory)\b)|  # 5 关键字
            (\b(?:Widget|StatelessWidget|StatefulWidget|State|BuildContext|MaterialApp|Scaffold|Column|Row|Container|Padding|Text|Expanded|ListView|Stack|Align|Center|GestureDetector|SizedBox|BoxDecoration|EdgeInsets|Border|BorderSide|Color|Colors|Icon|Icons|Key|WidgetBuilder|Navigator|MediaQuery)\b)  # 6 类型
        """,
        re.VERBOSE,
    )

    def repl(m):
        if m.group(1):
            return f'<span class="c-str">{m.group(1)}</span>'
        if m.group(2):
            return f'<span class="c-com">{m.group(2)}</span>'
        if m.group(3):
            return f'<span class="c-com">{m.group(3)}</span>'
        if m.group(4):
            return f'<span class="c-num">{m.group(4)}</span>'
        if m.group(5):
            return f'<span class="c-kw">{m.group(5)}</span>'
        if m.group(6):
            return f'<span class="c-type">{m.group(6)}</span>'
        return m.group(0)

    return pattern.sub(repl, code)


def render_code(buf, lang):
    code = "\n".join(buf)
    code = code.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
    code = highlight_dart(code)
    return (
        '<div class="code-block">'
        '<button class="copy-btn" onclick="copyCode(this)">复制</button>'
        f'<pre><code class="lang-{lang}">{code}</code></pre></div>'
    )


def is_block_start(line):
    s = line.lstrip()
    return (
        s.startswith("#")
        or s.startswith(">")
        or s.startswith("- ")
        or s.startswith("* ")
        or s.startswith("```")
        or s.startswith("<details")
        or s.startswith("</details>")
        or s.startswith("<summary>")
        or s.startswith("</summary>")
        or re.match(r"^!\[[^\]]*\]\([^)]+\)$", line.strip()) is not None
    )


def convert(md):
    lines = md.split("\n")
    out = []
    toc = []  # (level, title, slug)
    i = 0
    n = len(lines)
    in_code = False
    code_buf = []
    code_lang = ""

    while i < n:
        line = lines[i]

        # 代码块
        if line.strip().startswith("```"):
            if not in_code:
                in_code = True
                code_lang = line.strip()[3:].strip()
                code_buf = []
            else:
                in_code = False
                out.append(render_code(code_buf, code_lang))
            i += 1
            continue
        if in_code:
            code_buf.append(line)
            i += 1
            continue

        # 原生 HTML 标签（details / summary）
        s = line.lstrip()
        if s.startswith("<details") or s.startswith("</details>") or s.startswith("<summary>") or s.startswith("</summary>"):
            out.append(line)
            i += 1
            continue

        # 标题
        m = re.match(r"^(#{1,4})\s+(.*)$", line)
        if m:
            level = len(m.group(1))
            title = m.group(2).strip()
            slug = slugify(title)
            out.append(f'<h{level} id="{slug}">{inline(title)}</h{level}>')
            if level in (2, 3):
                toc.append((level, title, slug))
            i += 1
            continue

        # 图片（独立成行）
        m = re.match(r"^!\[([^\]]*)\]\(([^)]+)\)\s*$", line.strip())
        if m:
            alt = m.group(1)
            src = m.group(2).replace("screenshots/", "assets/screenshots/")
            out.append(
                f'<figure class="shot"><img src="{src}" alt="{alt}" '
                f'loading="lazy"><figcaption>{alt}</figcaption></figure>'
            )
            i += 1
            continue

        # 引用
        if s.startswith(">"):
            buf = []
            while i < n and lines[i].lstrip().startswith(">"):
                buf.append(lines[i].lstrip()[1:].strip())
                i += 1
            out.append("<blockquote>" + inline(" ".join(buf)) + "</blockquote>")
            continue

        # 列表
        if re.match(r"^\s*-\s+", line) or re.match(r"^\s*\*\s+", line):
            buf = []
            while i < n and (re.match(r"^\s*-\s+", lines[i]) or re.match(r"^\s*\*\s+", lines[i])):
                item = re.sub(r"^\s*[*-]\s+", "", lines[i])
                buf.append("<li>" + inline(item) + "</li>")
                i += 1
            out.append("<ul>" + "".join(buf) + "</ul>")
            continue

        # 空行
        if line.strip() == "":
            i += 1
            continue

        # 段落
        buf = [line]
        i += 1
        while i < n and lines[i].strip() != "" and not is_block_start(lines[i]):
            buf.append(lines[i])
            i += 1
        out.append("<p>" + inline(" ".join(buf)) + "</p>")

    return "\n".join(out), toc


def build_sidebar(toc):
    out = ['<nav class="sidebar-nav">']
    open_group = False
    for level, title, slug in toc:
        if level == 2:
            if open_group:
                out.append("</ul></div>")
            out.append(
                f'<div class="nav-section"><a class="nav-section-title" '
                f'href="#{slug}">{inline(title)}</a><ul>'
            )
            open_group = True
        else:
            out.append(f'<li><a href="#{slug}">{inline(title)}</a></li>')
    if open_group:
        out.append("</ul></div>")
    out.append("</nav>")
    return "".join(out)


# ---------------------------------------------------------------------------
# 页面外壳
# ---------------------------------------------------------------------------

HEADER = """
<header class="site-header">
  <button class="menu-toggle" aria-label="菜单">☰</button>
  <a class="logo" href="index.html">
    <span class="mark">U</span><span>uView Flutter</span>
  </a>
  <nav>
    <a href="index.html">首页</a>
    <a href="components.html">组件</a>
    <a href="index.html#license">许可证</a>
    <a class="gh" href="{repo}" target="_blank" rel="noopener">GitHub</a>
  </nav>
</header>
"""

FOOTER = """
<footer class="site-footer">
  <p>Copyright © 2026 uview_flutter contributors · 基于 MIT License 开源发布</p>
  <p>本组件库为 <a href="https://uviewpro.cn" target="_blank" rel="noopener">uView UI</a> 的 Flutter 社区复刻，与官方无隶属关系。</p>
</footer>
"""

# 组件分类（用于首页卡片，标题与 components.html 的 h2 锚点一致）
CATEGORIES = [
    ("基础组件", ["Button", "Text", "Tag", "Badge", "Cell", "Icon", "Image", "Loading", "Gap", "Layout", "Divider"]),
    ("表单组件", ["Form", "Input", "Textarea", "Search", "VerificationCode", "Checkbox", "Radio", "Switch", "Select", "NumberBox", "Slider", "Rate", "Picker", "Calendar", "Upload", "Keyboard"]),
    ("反馈组件", ["Toast", "AlertTips", "Modal", "Popup", "ActionSheet", "NoticeBar", "Collapse", "SwipeAction"]),
    ("导航组件", ["Navbar", "Tabbar", "Tabs", "Steps", "Dropdown", "BackTop"]),
    ("布局组件", ["Grid", "Swiper", "Avatar", "Empty", "Skeleton", "Sticky", "Waterfall"]),
    ("数据/其他", ["Progress", "CountDown", "CountTo", "Card", "LoadMore"]),
    ("其他组件", ["FloatingBall"]),
]


def sidebar_anchor(title):
    return slugify(title)


def render_components_page(body, sidebar, toc):
    cats_html = "".join(
        f'<div class="cat-card"><h4>{name}</h4><div class="chips">'
        + "".join(f'<span class="chip">{c}</span>' for c in comps)
        + "</div></div>"
        for name, comps in CATEGORIES
    )
    return f"""<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>组件文档 · {SITE_TITLE}</title>
<meta name="description" content="{SITE_DESC}">
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
{HEADER.format(repo=REPO_URL)}
<div class="layout">
  <aside class="sidebar">{sidebar}</aside>
  <main class="content">
{body}
  </main>
</div>
{FOOTER}
<script src="assets/site.js"></script>
</body>
</html>
"""


def render_index_page():
    cat_cards = "".join(
        f'<div class="cat-card"><h4>{name}</h4><div class="chips">'
        + "".join(f'<span class="chip">{c}</span>' for c in comps)
        + "</div></div>"
        for name, comps in CATEGORIES
    )
    return f"""<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{SITE_TITLE} · Flutter UI 组件库</title>
<meta name="description" content="{SITE_DESC}">
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
{HEADER.format(repo=REPO_URL)}

<section class="hero">
  <h1>uView Flutter</h1>
  <p class="sub">uView UI 组件库的 Flutter 社区复刻版：内置主题系统，50+ 基础组件，纯框架实现、零额外依赖。</p>
  <div class="cta">
    <a class="btn btn-primary" href="components.html">浏览组件</a>
    <a class="btn btn-ghost" href="{REPO_URL}" target="_blank" rel="noopener">GitHub 仓库</a>
  </div>
</section>

<section class="features">
  <div class="feature"><h3>主题系统</h3><p>UViewThemeData 提供 uView 默认蓝/成功/警告/错误/信息色、圆角、字号、间距 token，支持运行时 UView.update 切换。</p></div>
  <div class="feature"><h3>零额外依赖</h3><p>仅依赖 Flutter 框架与 cupertino_icons，全部组件纯框架实现，体积可控。</p></div>
  <div class="feature"><h3>Dart 2.17 兼容</h3><p>未使用 records / pattern 等 Dart 3 特性，对老项目友好。</p></div>
  <div class="feature"><h3>配套 Demo</h3><p>example/ 工程按 uView 分类提供可交互预览页，效果截图与用法示例一一对应。</p></div>
</section>

<section class="section">
  <h2>快速安装</h2>
  <div class="code-block"><button class="copy-btn" onclick="copyCode(this)">复制</button><pre><code class="lang-yaml">dependencies:
  uview_flutter:
    git:
      url: {REPO_URL}
      ref: main</code></pre></div>
</section>

<section class="section">
  <h2>快速开始</h2>
  <div class="code-block"><button class="copy-btn" onclick="copyCode(this)">复制</button><pre><code class="lang-dart">import 'package:flutter/material.dart';
import 'package:uview_flutter/uview_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {{
  const MyApp({{super.key}});
  @override
  Widget build(BuildContext context) => UView(
    theme: const UViewThemeData(),
    child: MaterialApp(
      home: Scaffold(
        body: UCol(gap: 12, children: [
          const UText('欢迎使用 uview_flutter', bold: true, size: 18),
          const UButton(text: '主要按钮', type: UViewType.primary),
          UCell(title: '地址', value: '杭州', isLink: true),
        ]),
      ),
    ),
  );
}}</code></pre></div>
</section>

<section class="section">
  <h2>组件分类</h2>
  <div class="grid-cats">{cat_cards}</div>
  <p style="margin-top:18px"><a class="btn btn-primary" href="components.html">查看全部组件与示例 →</a></p>
</section>

<section class="license-box" id="license">
  <h2>开源许可 · MIT</h2>
  <p>uview_flutter 以 <strong>MIT License</strong> 开源，可自由用于商业与非商业项目。完整文本见 <a href="LICENSE" target="_blank" rel="noopener">LICENSE</a> 文件。</p>
  <pre>MIT License

Copyright (c) 2026 uview_flutter contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.</pre>
</section>

{FOOTER}
<script src="assets/site.js"></script>
</body>
</html>
"""


def copy_screenshots():
    os.makedirs(SHOTS_DST, exist_ok=True)
    src = os.path.join(DOCS, "screenshots")
    copied = 0
    if not os.path.isdir(src):
        return 0
    for f in os.listdir(src):
        if f.lower().endswith(".png"):
            shutil.copy2(os.path.join(src, f), os.path.join(SHOTS_DST, f))
            copied += 1
    return copied


def main():
    os.makedirs(ASSETS, exist_ok=True)
    # 复制静态资源引用（style.css / site.js 已存在；若缺失则跳过）
    md_path = os.path.join(DOCS, "components.md")
    with open(md_path, "r", encoding="utf-8") as f:
        md = f.read()

    body, toc = convert(md)
    sidebar = build_sidebar(toc)

    with open(os.path.join(SITE, "components.html"), "w", encoding="utf-8") as f:
        f.write(render_components_page(body, sidebar, toc))

    with open(os.path.join(SITE, "index.html"), "w", encoding="utf-8") as f:
        f.write(render_index_page())

    n = copy_screenshots()
    print(f"generated: index.html, components.html; screenshots copied: {n}")


if __name__ == "__main__":
    main()
