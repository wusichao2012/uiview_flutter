import 'package:flutter/material.dart';
import 'package:uview_flutter/uview_flutter.dart';

/// 单个组件演示条目。
class DemoItem {
  final String name;
  final String? description;
  final Widget demo;

  const DemoItem(this.name, this.demo, {this.description});
}

/// ---------- Button ----------
class ButtonDemo extends StatelessWidget {
  const ButtonDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return UCol(
      crossAxisAlignment: CrossAxisAlignment.start,
      gap: 12,
      children: [
        const UText('按类型', bold: true),
        URow(
          gap: 10,
          children: const [
            UButton(text: '主要', type: UViewType.primary),
            UButton(text: '成功', type: UViewType.success),
            UButton(text: '警告', type: UViewType.warning),
            UButton(text: '错误', type: UViewType.error),
          ],
        ),
        const UText('幽灵 / 胶囊 / 细边', bold: true),
        URow(
          gap: 10,
          children: const [
            UButton(text: 'plain', plain: true),
            UButton(text: 'round', round: true),
            UButton(text: 'hairline', plain: true, hairline: true),
          ],
        ),
        const UText('禁用 / 加载 / 图标', bold: true),
        URow(
          gap: 10,
          children: const [
            UButton(text: '禁用', disabled: true),
            UButton(text: '加载', loading: true),
            UButton(text: '设置', icon: Icons.settings, plain: true),
          ],
        ),
        const UText('通栏按钮', bold: true),
        const UButton(text: '确认提交', block: true, onPressed: null),
      ],
    );
  }
}

/// ---------- Text ----------
class TextDemo extends StatelessWidget {
  const TextDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return UCol(
      crossAxisAlignment: CrossAxisAlignment.start,
      gap: 10,
      children: const [
        UText('主要文字', type: UViewType.def, bold: true, size: 16),
        UText('成功色文字', type: UViewType.success),
        UText('警告色文字', type: UViewType.warning),
        UText('错误色文字', type: UViewType.error),
        UText('信息色文字', type: UViewType.info),
        UText(
          '这是一段会被截断的长文本，最多显示两行，超出部分以省略号结尾，用于演示 lines 参数。',
          lines: 2,
        ),
      ],
    );
  }
}

/// ---------- Tag ----------
class TagDemo extends StatelessWidget {
  const TagDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return UCol(
      crossAxisAlignment: CrossAxisAlignment.start,
      gap: 12,
      children: [
        URow(
          gap: 8,
          children: const [
            UTag(text: '标签', type: UViewType.primary),
            UTag(text: '成功', type: UViewType.success),
            UTag(text: '警告', type: UViewType.warning),
            UTag(text: '错误', type: UViewType.error),
          ],
        ),
        URow(
          gap: 8,
          children: const [
            UTag(text: 'plain', plain: true),
            UTag(text: 'round', round: true),
            UTag(text: 'mini', size: UViewSize.mini),
            UTag(text: '带图标', icon: Icons.star, type: UViewType.primary),
          ],
        ),
        URow(
          gap: 8,
          children: const [
            UTag(text: '可关闭', closable: true, type: UViewType.info),
            UTag(text: '自定义', bgColor: Color(0xFFE6F0FF), textColor: Color(0xFF3C9CFF)),
          ],
        ),
      ],
    );
  }
}

/// ---------- Badge ----------
class BadgeDemo extends StatelessWidget {
  const BadgeDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return URow(
      gap: 24,
      children: [
        const UBadge(text: 'NEW', child: UText('消息', bold: true)),
        const UBadge(count: 8, child: UIcon(name: 'bell')),
        const UBadge(count: 199, child: UIcon(name: 'email')),
        const UBadge(isDot: true, child: UIcon(name: 'setting')),
        const UBadge(count: 3, type: UViewType.primary, child: UText('动态')),
      ],
    );
  }
}

/// ---------- Cell ----------
class CellDemo extends StatelessWidget {
  const CellDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return UCellGroup(
      title: '基础信息',
      children: [
        const UCell(title: '收货人', value: '张三', isLink: true),
        const UCell(title: '手机号', value: '138****8888', isLink: true),
        const UCell(title: '详细地址', label: '浙江省杭州市余杭区文一西路', isLink: true),
        const UCell(title: '设为默认', required: true, value: '必填项'),
      ],
    );
  }
}

/// ---------- Icon ----------
class IconDemo extends StatelessWidget {
  const IconDemo({Key? key}) : super(key: key);
  static const names = [
    'setting', 'star-fill', 'heart-fill', 'search', 'check-circle-fill',
    'warning-fill', 'error-circle-fill', 'info-circle-fill', 'plus', 'minus',
    'arrow-right', 'phone', 'email', 'location', 'user', 'lock', 'edit', 'trash',
  ];
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 18,
      children: names
          .map((n) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UIcon(name: n, size: 26),
                  const SizedBox(height: 4),
                  UText(n, size: 10, type: UViewType.info),
                ],
              ))
          .toList(),
    );
  }
}

/// ---------- Image ----------
class ImageDemo extends StatelessWidget {
  const ImageDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const url = 'https://uviewpro.cn/logo.png';
    return URow(
      gap: 16,
      children: [
        const UImage(src: url, width: 64, height: 64, shape: UViewShape.circle),
        const UImage(src: url, width: 64, height: 64, radius: 12),
        const UImage(src: url, width: 64, height: 64),
        const UImage(src: null, width: 64, height: 64, radius: 12),
      ],
    );
  }
}

/// ---------- Loading ----------
class LoadingDemo extends StatelessWidget {
  const LoadingDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return URow(
      gap: 20,
      children: const [
        ULoading(size: 18),
        ULoading(size: 28, type: UViewType.success),
        ULoading(size: 38, type: UViewType.warning),
        ULoading(size: 48, type: UViewType.error),
        ULoading(show: false),
      ],
    );
  }
}

/// ---------- Gap ----------
class GapDemo extends StatelessWidget {
  const GapDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber.withOpacity(0.15),
      padding: const EdgeInsets.all(8),
      child: UCol(
        gap: 0,
        children: [
          Container(height: 24, color: Colors.amber),
          const UGap(height: 8),
          Container(height: 24, color: Colors.amber),
          const UGap(height: 16),
          Container(height: 24, color: Colors.amber),
        ],
      ),
    );
  }
}

/// ---------- Layout ----------
class LayoutDemo extends StatelessWidget {
  const LayoutDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return UCol(
      crossAxisAlignment: CrossAxisAlignment.start,
      gap: 12,
      children: [
        const UText('URow（gap=12）', bold: true),
        URow(
          gap: 12,
          children: List.generate(
              4, (i) => Container(width: 40, height: 40, color: Colors.blue.withOpacity(0.6))),
        ),
        const UText('UCol（gap=12）', bold: true),
        UCol(
          gap: 12,
          children: List.generate(
              3, (i) => Container(height: 28, color: Colors.green.withOpacity(0.5))),
        ),
      ],
    );
  }
}

/// ---------- Divider ----------
class DividerDemo extends StatelessWidget {
  const DividerDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const UCol(
      crossAxisAlignment: CrossAxisAlignment.start,
      gap: 8,
      children: [
        UDivider(),
        UDivider(text: '居中文字'),
        UDivider(text: '左对齐', textAlign: MainAxisAlignment.start),
        UDivider(text: '虚线', dashed: true),
      ],
    );
  }
}

/// ---------- Form ----------
class FormDemo extends StatefulWidget {
  const FormDemo({Key? key}) : super(key: key);
  @override
  _FormDemoState createState() => _FormDemoState();
}

class _FormDemoState extends State<FormDemo> {
  final UFormController _ctrl = UFormController();
  String? _msg;
  @override
  Widget build(BuildContext context) {
    return UCol(
      gap: 14,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UForm(
          controller: _ctrl,
          child: UCol(
            gap: 14,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UFormItem(
                label: '用户名',
                required: true,
                child: UInput(
                  placeholder: '请输入用户名',
                  validator: (v) => (v == null || v.isEmpty) ? '必填' : null,
                ),
              ),
              UFormItem(
                label: '密码',
                required: true,
                child: UInput(
                  password: true,
                  clearable: true,
                  placeholder: '请输入密码',
                  validator: (v) => (v != null && v.length < 6) ? '至少 6 位' : null,
                ),
              ),
            ],
          ),
        ),
        UButton(
          text: '校验提交',
          onPressed: () {
            final ok = _ctrl.validate();
            setState(() => _msg = ok ? '校验通过' : '请检查标红项');
          },
        ),
        if (_msg != null) UText(_msg!, type: UViewType.primary, bold: true),
      ],
    );
  }
}

class InputDemo extends StatelessWidget {
  const InputDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const UCol(
      gap: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UInput(placeholder: '基础输入框'),
        UInput(placeholder: '可清空', clearable: true),
        UInput(placeholder: '密码', password: true, clearable: true),
        UInput(placeholder: '带前缀图标', prefixIcon: Icon(Icons.person, size: 18)),
        UInput(placeholder: '禁用', enabled: false),
      ],
    );
  }
}

class TextareaDemo extends StatelessWidget {
  const TextareaDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) =>
      const UTextarea(placeholder: '请输入多行文本...', maxLength: 100, showCounter: true, maxLines: 3);
}

class SearchDemo extends StatelessWidget {
  const SearchDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const USearch(placeholder: '搜索商品');
}

class VerificationCodeDemo extends StatelessWidget {
  const VerificationCodeDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const UVerificationCode();
}

class CheckboxDemo extends StatefulWidget {
  const CheckboxDemo({Key? key}) : super(key: key);
  @override
  _CheckboxDemoState createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<CheckboxDemo> {
  List<String> _v = ['b'];
  @override
  Widget build(BuildContext context) => UCheckboxGroup<String>(
        value: _v,
        onChanged: (v) => setState(() => _v = v),
        options: const [
          UCheckboxOption('苹果', 'a'),
          UCheckboxOption('香蕉', 'b'),
          UCheckboxOption('橘子', 'c'),
        ],
      );
}

class RadioDemo extends StatefulWidget {
  const RadioDemo({Key? key}) : super(key: key);
  @override
  _RadioDemoState createState() => _RadioDemoState();
}

class _RadioDemoState extends State<RadioDemo> {
  String? _v = 'b';
  @override
  Widget build(BuildContext context) => URadioGroup<String>(
        value: _v,
        onChanged: (v) => setState(() => _v = v),
        options: const [
          URadioOption('男', 'male'),
          URadioOption('女', 'female'),
          URadioOption('保密', 'secret'),
        ],
      );
}

class SwitchDemo extends StatefulWidget {
  const SwitchDemo({Key? key}) : super(key: key);
  @override
  _SwitchDemoState createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<SwitchDemo> {
  bool _v = true;
  @override
  Widget build(BuildContext context) => URow(
        children: [
          const UText('接收推送通知', size: 15),
          const Spacer(),
          USwitch(value: _v, onChanged: (b) => setState(() => _v = b)),
        ],
      );
}

class SelectDemo extends StatefulWidget {
  const SelectDemo({Key? key}) : super(key: key);
  @override
  _SelectDemoState createState() => _SelectDemoState();
}

class _SelectDemoState extends State<SelectDemo> {
  String? _v;
  @override
  Widget build(BuildContext context) => USelect<String>(
        value: _v,
        placeholder: '请选择城市',
        title: '选择城市',
        onChanged: (v) => setState(() => _v = v),
        options: const [
          USelectOption('北京', 'bj'),
          USelectOption('上海', 'sh'),
          USelectOption('杭州', 'hz'),
          USelectOption('深圳', 'sz'),
        ],
      );
}

class NumberBoxDemo extends StatefulWidget {
  const NumberBoxDemo({Key? key}) : super(key: key);
  @override
  _NumberBoxDemoState createState() => _NumberBoxDemoState();
}

class _NumberBoxDemoState extends State<NumberBoxDemo> {
  double _v = 1;
  @override
  Widget build(BuildContext context) => UNumberBox(
        value: _v,
        min: 0,
        max: 10,
        onChanged: (v) => setState(() => _v = v),
      );
}

class SliderDemo extends StatefulWidget {
  const SliderDemo({Key? key}) : super(key: key);
  @override
  _SliderDemoState createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> {
  double _v = 40;
  @override
  Widget build(BuildContext context) => UCol(
        gap: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          USlider(value: _v, divisions: 100, label: _v.round().toString(), onChanged: (v) => setState(() => _v = v)),
          UText('当前值：${_v.round()}', type: UViewType.info),
        ],
      );
}

class RateDemo extends StatefulWidget {
  const RateDemo({Key? key}) : super(key: key);
  @override
  _RateDemoState createState() => _RateDemoState();
}

class _RateDemoState extends State<RateDemo> {
  int _v = 3;
  @override
  Widget build(BuildContext context) => URate(value: _v, onChanged: (v) => setState(() => _v = v));
}

/// ---------- Picker ----------
class PickerDemo extends StatefulWidget {
  const PickerDemo({Key? key}) : super(key: key);
  @override
  _PickerDemoState createState() => _PickerDemoState();
}
class _PickerDemoState extends State<PickerDemo> {
  List<int>? _idx;
  void _open() {
    UPicker.show(
      context,
      columns: const [
        ['男', '女'],
      ],
    ).then((r) {
      if (r != null) UToast.show(context, '选择索引: $r');
    });
  }
  @override
  Widget build(BuildContext context) => UCol(
        gap: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UPickerField(
            columns: const [
              ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
              ['上午', '下午', '晚上'],
            ],
            valueIndexes: _idx,
            title: '选择时间',
            onChanged: (v) => setState(() => _idx = v),
          ),
          UButton(text: '直接弹出', onPressed: _open),
        ],
      );
}

/// ---------- Calendar ----------
class CalendarDemo extends StatefulWidget {
  const CalendarDemo({Key? key}) : super(key: key);
  @override
  _CalendarDemoState createState() => _CalendarDemoState();
}
class _CalendarDemoState extends State<CalendarDemo> {
  DateTime? _v = DateTime.now();
  void _open() {
    UCalendar.show(context, value: _v).then((r) {
      if (r != null) setState(() => _v = r);
    });
  }
  @override
  Widget build(BuildContext context) => UCol(
        gap: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UCalendar(value: _v, onChanged: (d) => setState(() => _v = d), type: UViewType.primary),
          UButton(text: '弹窗选择', onPressed: _open),
        ],
      );
}

/// ---------- Upload ----------
class UploadDemo extends StatefulWidget {
  const UploadDemo({Key? key}) : super(key: key);
  @override
  _UploadDemoState createState() => _UploadDemoState();
}
class _UploadDemoState extends State<UploadDemo> {
  List<UUploadItem> _files = [];
  void _add() {
    final i = _files.length;
    setState(() => _files.add(UUploadItem(
          thumb: Container(
            color: Colors.blue.withOpacity(0.18),
            child: Center(child: UText('图$i')),
          ),
          value: i,
        )));
  }
  void _remove(int i) => setState(() => _files.removeAt(i));
  @override
  Widget build(BuildContext context) =>
      UUpload(files: _files, onAdd: _add, onRemove: _remove, maxCount: 6);
}

/// ---------- Keyboard ----------
class KeyboardDemo extends StatefulWidget {
  const KeyboardDemo({Key? key}) : super(key: key);
  @override
  _KeyboardDemoState createState() => _KeyboardDemoState();
}
class _KeyboardDemoState extends State<KeyboardDemo> {
  String _text = '';
  void _open() {
    UKeyboard.show(
      context,
      onKey: (k) => setState(() => _text += k),
      onDelete: () => setState(
          () => _text = _text.isNotEmpty ? _text.substring(0, _text.length - 1) : ''),
      onConfirm: () => UToast.show(context, '完成：$_text'),
    );
  }
  @override
  Widget build(BuildContext context) => UCol(
        gap: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UText('输入：$_text', size: 16),
          UButton(text: '唤起键盘', onPressed: _open),
        ],
      );
}

/// ---------- Toast ----------
class ToastDemo extends StatelessWidget {
  const ToastDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => UCol(
        gap: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          URow(
            gap: 10,
            children: [
              UButton(text: '普通', onPressed: () => UToast.show(context, '这是一条普通提示')),
              UButton(text: '成功', type: UViewType.success, onPressed: () => UToast.success(context, '操作成功')),
            ],
          ),
          URow(
            gap: 10,
            children: [
              UButton(text: '错误', type: UViewType.error, onPressed: () => UToast.error(context, '操作失败')),
              UButton(text: 'Loading', onPressed: () {
                UToast.loading(context, message: '加载中');
                Future.delayed(const Duration(seconds: 2), () => UToast.hide(context));
              }),
            ],
          ),
        ],
      );
}

/// ---------- AlertTips ----------
class AlertTipsDemo extends StatelessWidget {
  const AlertTipsDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => UCol(
        gap: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          UAlertTips(type: UViewType.success, title: '成功', description: '操作已完成'),
          UAlertTips(type: UViewType.warning, title: '注意', description: '请检查输入', showClose: true),
          UAlertTips(type: UViewType.error, description: '网络异常，请重试'),
        ],
      );
}

/// ---------- Modal ----------
class ModalDemo extends StatelessWidget {
  const ModalDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => UButton(
        text: '打开模态框',
        onPressed: () {
          UModal.show(
            context,
            title: '提示',
            content: '确定要删除吗？',
            confirmText: '删除',
            type: UViewType.error,
          ).then((r) {
            if (r.confirmed) UToast.show(context, '已删除');
          });
        },
      );
}

/// ---------- Popup ----------
class PopupDemo extends StatelessWidget {
  const PopupDemo({Key? key}) : super(key: key);
  static Widget _panel(String t) =>
      Container(padding: const EdgeInsets.all(24), child: UText(t, bold: true, size: 16));
  @override
  Widget build(BuildContext context) => URow(
        gap: 12,
        children: [
          UButton(text: '底部', onPressed: () => UPopup.show(
                context,
                position: UPopupPosition.bottom,
                child: _panel('底部弹出内容'),
              )),
          UButton(text: '居中', onPressed: () => UPopup.show(
                context,
                position: UPopupPosition.center,
                child: _panel('居中弹出内容'),
              )),
        ],
      );
}

/// ---------- ActionSheet ----------
class ActionSheetDemo extends StatelessWidget {
  const ActionSheetDemo({Key? key}) : super(key: key);
  static const _opts = ['拍照', '从相册选择', '取消选择'];
  @override
  Widget build(BuildContext context) => UButton(
        text: '打开操作菜单',
        onPressed: () {
          UActionSheet.show(context, actions: _opts).then((i) {
            if (i != null) UToast.show(context, '选中：${_opts[i]}');
          });
        },
      );
}

/// ---------- NoticeBar ----------
class NoticeBarDemo extends StatelessWidget {
  const NoticeBarDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => UCol(
        gap: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UNoticeBar(text: '这是一条滚动的普通通知消息，用于演示滚动效果，足够长才会滚动。', mode: UNoticeBarMode.closeable),
          UNoticeBar(text: '短通知（不滚动）', type: UViewType.info, mode: UNoticeBarMode.link, scrollable: false, onTap: () {}),
        ],
      );
}

/// ---------- Collapse ----------
class CollapseDemo extends StatelessWidget {
  const CollapseDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => UCollapse(
        accordion: true,
        children: const [
          UCollapseItem(title: '面板一', content: UText('这是第一个面板的内容。')),
          UCollapseItem(title: '面板二', content: UText('这是第二个面板的内容。')),
          UCollapseItem(title: '面板三', content: UText('这是第三个面板的内容。')),
        ],
      );
}

/// ---------- SwipeAction ----------
class SwipeActionDemo extends StatelessWidget {
  const SwipeActionDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => USwipeActionCell(
        actions: [
          USwipeAction(text: '删除', type: UViewType.error, onTap: () => UToast.show(context, '删除')),
          USwipeAction(text: '收藏', type: UViewType.primary, onTap: () => UToast.show(context, '收藏')),
        ],
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: const UText('向左滑动我看看', size: 15),
        ),
      );
}

/// ---------- Navbar ----------
class NavbarDemo extends StatelessWidget {
  const NavbarDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            border: Border.all(color: UView.of(context).borderColor)),
        child: UNavbar(
          title: '标题',
          showBack: true,
          safeAreaTop: false,
          onBack: () {},
          actions: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.more_horiz),
            ),
          ],
        ),
      );
}

/// ---------- Tabbar ----------
class TabbarDemo extends StatefulWidget {
  const TabbarDemo({Key? key}) : super(key: key);
  @override
  _TabbarDemoState createState() => _TabbarDemoState();
}
class _TabbarDemoState extends State<TabbarDemo> {
  int _i = 0;
  @override
  Widget build(BuildContext context) => Container(
        height: 360,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: UText('页面 ${_i + 1}', size: 18, bold: true),
              ),
            ),
            UTabbar(
              currentIndex: _i,
              onTap: (v) => setState(() => _i = v),
              items: const [
                UTabbarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '首页'),
                UTabbarItem(icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view), label: '分类'),
                UTabbarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: '我的'),
              ],
            ),
          ],
        ),
      );
}

/// ---------- Steps ----------
class StepsDemo extends StatelessWidget {
  const StepsDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) =>
      const USteps(steps: ['填写', '审核', '完成'], current: 1);
}

/// ---------- Dropdown ----------
class DropdownDemo extends StatefulWidget {
  const DropdownDemo({Key? key}) : super(key: key);
  @override
  _DropdownDemoState createState() => _DropdownDemoState();
}
class _DropdownDemoState extends State<DropdownDemo> {
  int? _v;
  @override
  Widget build(BuildContext context) => Container(
        height: 240,
        child: Column(
          children: [
            UDropdown(
              options: const ['全部', '进行中', '已完成', '已取消'],
              value: _v,
              onChanged: (i) => setState(() => _v = i),
            ),
            const Expanded(
              child: Center(child: UText('下方内容可被浮层覆盖')),
            ),
          ],
        ),
      );
}

/// ---------- Tabs ----------
class TabsDemo extends StatelessWidget {
  const TabsDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container(
        height: 240,
        child: UTabs(
          tabs: const ['标签一', '标签二', '标签三'],
          children: const [
            Center(child: UText('内容一')),
            Center(child: UText('内容二')),
            Center(child: UText('内容三')),
          ],
        ),
      );
}

/// ---------- BackTop ----------
class BackTopDemo extends StatefulWidget {
  const BackTopDemo({Key? key}) : super(key: key);
  @override
  _BackTopDemoState createState() => _BackTopDemoState();
}
class _BackTopDemoState extends State<BackTopDemo> {
  final ScrollController _c = ScrollController();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => Container(
        height: 320,
        child: Stack(
          children: [
            Positioned.fill(
              child: ListView(
                controller: _c,
                padding: const EdgeInsets.all(12),
                children: List.generate(
                  30,
                  (i) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: UView.of(context).surfaceColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: UText('列表项 $i'),
                  ),
                ),
              ),
            ),
            Positioned(bottom: 16, right: 16, child: UBackTop(controller: _c)),
          ],
        ),
      );
}

/// ---------- Grid ----------
class GridDemo extends StatelessWidget {
  const GridDemo({Key? key}) : super(key: key);
  Widget _tile(Color c) => Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(8)),
      );
  @override
  Widget build(BuildContext context) => UGrid(
        crossAxisCount: 4,
        items: [
          UGridItem(icon: _tile(Colors.blue), label: '功能一'),
          UGridItem(icon: _tile(Colors.green), label: '功能二'),
          UGridItem(icon: _tile(Colors.orange), label: '功能三'),
          UGridItem(icon: _tile(Colors.purple), label: '功能四'),
          UGridItem(icon: _tile(Colors.teal), label: '功能五'),
          UGridItem(icon: _tile(Colors.pink), label: '功能六'),
          UGridItem(icon: _tile(Colors.indigo), label: '功能七'),
          UGridItem(icon: _tile(Colors.amber), label: '功能八'),
        ],
      );
}

/// ---------- Swiper ----------
class SwiperDemo extends StatelessWidget {
  const SwiperDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const USwiper(
        height: 140,
        autoplay: true,
        children: [
          ColoredBox(color: Colors.blue, child: Center(child: UText('幻灯片 1', color: Colors.white))),
          ColoredBox(color: Colors.green, child: Center(child: UText('幻灯片 2', color: Colors.white))),
          ColoredBox(color: Colors.orange, child: Center(child: UText('幻灯片 3', color: Colors.white))),
        ],
      );
}

/// ---------- Avatar ----------
class AvatarDemo extends StatelessWidget {
  const AvatarDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const URow(
        gap: 16,
        children: [
          UAvatar(child: UText('U', bold: true), size: 40),
          UAvatar(child: UText('W', bold: true), size: 56, backgroundColor: Color(0xFFE6F0FF)),
          UAvatar(shape: UViewShape.square, radius: 12, child: UText('S', bold: true), size: 48),
        ],
      );
}

/// ---------- Empty ----------
class EmptyDemo extends StatelessWidget {
  const EmptyDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container(
        height: 160,
        child: UEmpty(
          text: '暂无数据',
          action: UButton(text: '刷新', onPressed: () {}),
        ),
      );
}

/// ---------- Skeleton ----------
class SkeletonDemo extends StatelessWidget {
  const SkeletonDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const UCol(
        gap: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          USkeleton(width: 200),
          USkeleton(width: 160, height: 12),
          USkeleton(width: 48, height: 48, shape: UViewShape.circle),
        ],
      );
}

/// ---------- Sticky ----------
class StickyDemo extends StatelessWidget {
  const StickyDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container(
        height: 320,
        child: USticky(
          header: Container(
            color: UView.of(context).surfaceColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: const UText('吸顶标题', bold: true, size: 16),
          ),
          body: List.generate(
            20,
            (i) => Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: UView.of(context).borderColor),
                ),
              ),
              child: UText('内容行 $i'),
            ),
          ),
        ),
      );
}

/// ---------- Progress ----------
class ProgressDemo extends StatelessWidget {
  const ProgressDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const UCol(
        gap: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UProgress(percent: 0.3, showText: true),
          UProgress(percent: 0.6, type: UViewType.success, showText: true),
          UProgress(percent: 0.85, type: UViewType.warning, showText: true),
          UProgress(percent: 1.0, type: UViewType.error),
        ],
      );
}

/// ---------- CountDown ----------
class CountDownDemo extends StatelessWidget {
  const CountDownDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const URow(
        gap: 12,
        children: [
          UCountDown(duration: Duration(minutes: 1), textSize: 18),
          UCountDown(duration: Duration(hours: 2), textSize: 18),
        ],
      );
}

/// ---------- CountTo ----------
class CountToDemo extends StatelessWidget {
  const CountToDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const URow(
        gap: 16,
        children: [
          UCountTo(end: 12345, suffix: ' 次', type: UViewType.primary),
          UCountTo(end: 99.9, decimals: 1, prefix: '¥', type: UViewType.error),
        ],
      );
}

/// ---------- Card ----------
class CardDemo extends StatelessWidget {
  const CardDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const UCard(
        title: UText('卡片标题', bold: true),
        extra: UText('更多', type: UViewType.info, size: 13),
        child: UText('这是卡片的内容区域，用于承载正文信息。'),
      );
}

/// ---------- LoadMore ----------
class LoadMoreDemo extends StatelessWidget {
  const LoadMoreDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const ULoadMore(status: ULoadMoreStatus.normal);
}

/// ---------- Waterfall ----------
class WaterfallDemo extends StatelessWidget {
  const WaterfallDemo({Key? key}) : super(key: key);
  static final List<double> _heights = [80, 120, 100, 140, 90, 110, 130, 70, 100, 150, 95, 120];
  @override
  Widget build(BuildContext context) => Container(
        height: 360,
        child: SingleChildScrollView(
          child: UWaterfall(
            columnCount: 2,
            spacing: 8,
            children: List.generate(_heights.length, (i) {
              return Container(
                height: _heights[i],
                decoration: BoxDecoration(
                  color: Colors.primaries[i % Colors.primaries.length].withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: UText('卡片 $i')),
              );
            }),
          ),
        ),
      );
}

/// ---------- FloatingBall ----------
class FloatingBallDemo extends StatelessWidget {
  const FloatingBallDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container(
        height: 360,
        decoration: BoxDecoration(
          color: UView.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: UFloatingBall(
          actions: const [
            UFloatingAction(child: Icon(Icons.edit, color: Colors.white), label: '编辑'),
            UFloatingAction(child: Icon(Icons.share, color: Colors.white), label: '分享'),
            UFloatingAction(child: Icon(Icons.add, color: Colors.white), label: '新建'),
          ],
        ),
      );
}

/// 组件注册表（按 uView 分类）。
final Map<String, List<DemoItem>> demoRegistry = {
  '基础组件': [
    DemoItem('Button 按钮', const ButtonDemo(), description: 'type / plain / round / loading / block / icon'),
    DemoItem('Text 文本', const TextDemo(), description: 'type 取主题色、bold、lines 截断'),
    DemoItem('Tag 标签', const TagDemo(), description: 'type / plain / round / closable / 自定义色'),
    DemoItem('Badge 徽标数', const BadgeDemo(), description: '数字 / 圆点 / 溢出 / 角标包裹'),
    DemoItem('Cell 单元格', const CellDemo(), description: 'title / value / label / isLink / required'),
    DemoItem('Icon 图标', const IconDemo(), description: '按名称取图标，统一主题色'),
    DemoItem('Image 图片', const ImageDemo(), description: 'circle / radius / 加载与失败占位'),
    DemoItem('Loading 加载', const LoadingDemo(), description: '圆环 spinner，可换色换尺寸'),
    DemoItem('Gap 间隔', const GapDemo(), description: '布局中等距间隔'),
    DemoItem('Layout 布局', const LayoutDemo(), description: 'URow / UCol，支持 gap'),
    DemoItem('Divider 分割线', const DividerDemo(), description: '中间文字 / 虚线 / 对齐'),
  ],
  '表单组件': [
    DemoItem('Form 表单', const FormDemo(), description: 'UFormItem + 校验'),
    DemoItem('Input 输入框', const InputDemo(), description: 'clearable / password / 前后缀'),
    DemoItem('Textarea 文本域', const TextareaDemo(), description: '计数 / 多行'),
    DemoItem('Search 搜索', const SearchDemo(), description: '搜索图标 + 清空'),
    DemoItem('VerificationCode 验证码', const VerificationCodeDemo(), description: '输入框 + 倒计时'),
    DemoItem('Checkbox 复选框', const CheckboxDemo(), description: '多选组'),
    DemoItem('Radio 单选框', const RadioDemo(), description: '单选组'),
    DemoItem('Switch 开关', const SwitchDemo(), description: '开关选择器'),
    DemoItem('Select 选择器', const SelectDemo(), description: '底部弹窗列表'),
    DemoItem('NumberBox 步进器', const NumberBoxDemo(), description: 'min/max/step'),
    DemoItem('Slider 滑动', const SliderDemo(), description: '滑动选择器'),
    DemoItem('Rate 评分', const RateDemo(), description: '星级评分'),
    DemoItem('Picker 滚轮选择器', const PickerDemo(), description: '多列滚轮 / 字段触发'),
    DemoItem('Calendar 日历', const CalendarDemo(), description: '月历单日选择'),
    DemoItem('Upload 上传', const UploadDemo(), description: '上传格子（接 onAdd）'),
    DemoItem('Keyboard 键盘', const KeyboardDemo(), description: '自定义数字键盘'),
  ],
  '反馈组件': [
    DemoItem('Toast 轻提示', const ToastDemo(), description: '全局 Overlay / loading'),
    DemoItem('AlertTips 警告', const AlertTipsDemo(), description: '内嵌提示条'),
    DemoItem('Modal 模态框', const ModalDemo(), description: '确认/取消对话框'),
    DemoItem('Popup 弹出层', const PopupDemo(), description: '多方向弹出'),
    DemoItem('ActionSheet 操作菜单', const ActionSheetDemo(), description: '底部操作菜单'),
    DemoItem('NoticeBar 通知', const NoticeBarDemo(), description: '滚动通知条'),
    DemoItem('Collapse 折叠面板', const CollapseDemo(), description: '手风琴/多开'),
    DemoItem('SwipeAction 滑动', const SwipeActionDemo(), description: '左滑操作按钮'),
  ],
  '导航组件': [
    DemoItem('Navbar 导航栏', const NavbarDemo(), description: '顶部标题/返回/操作'),
    DemoItem('Tabbar 标签栏', const TabbarDemo(), description: '底部切换'),
    DemoItem('Tabs 标签页', const TabsDemo(), description: '顶部标签页'),
    DemoItem('Steps 步骤条', const StepsDemo(), description: '横向步骤'),
    DemoItem('Dropdown 下拉菜单', const DropdownDemo(), description: '浮层选项'),
    DemoItem('BackTop 返回顶部', const BackTopDemo(), description: '滚动吸顶按钮'),
  ],
  '布局组件': [
    DemoItem('Grid 宫格', const GridDemo(), description: '多列图标网格'),
    DemoItem('Swiper 轮播', const SwiperDemo(), description: '自动轮播 + 指示点'),
    DemoItem('Avatar 头像', const AvatarDemo(), description: '圆形/方形'),
    DemoItem('Empty 空状态', const EmptyDemo(), description: '空数据占位'),
    DemoItem('Skeleton 骨架屏', const SkeletonDemo(), description: '加载占位动画'),
    DemoItem('Sticky 吸顶', const StickyDemo(), description: '滚动吸顶'),
    DemoItem('Waterfall 瀑布流', const WaterfallDemo(), description: '多列不等高'),
  ],
  '数据/其他': [
    DemoItem('Progress 进度条', const ProgressDemo(), description: '百分比/主题色'),
    DemoItem('CountDown 倒计时', const CountDownDemo(), description: '天时分秒'),
    DemoItem('CountTo 数字滚动', const CountToDemo(), description: '动画计数'),
    DemoItem('Card 卡片', const CardDemo(), description: '标题/内容容器'),
    DemoItem('LoadMore 加载更多', const LoadMoreDemo(), description: '加载状态'),
  ],
  '其他组件': [
    DemoItem('FloatingBall 悬浮球', const FloatingBallDemo(), description: '可拖拽 / 展开菜单'),
  ],
};
