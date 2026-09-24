import 'package:flutter/material.dart';
import '../theme/uview.dart';
import '../theme/uview_theme_data.dart';
import '../components/u_text.dart';

/// uView `Calendar` 日历（月历，单日选择）。
class UCalendar extends StatefulWidget {
  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final UViewType? type;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool showHeader;

  const UCalendar({
    Key? key,
    this.value,
    this.onChanged,
    this.type,
    this.minDate,
    this.maxDate,
    this.showHeader = true,
  }) : super(key: key);

  /// 底部弹窗日历，返回选中的 [DateTime]，取消返回 null。
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? value,
    UViewType? type,
    DateTime? minDate,
    DateTime? maxDate,
    String? title,
  }) {
    final theme = UView.of(context);
    return showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: theme.surfaceColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(theme.radiusLg)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: UText(title, bold: true, size: 16),
              ),
            UCalendar(
              value: value,
              type: type,
              minDate: minDate,
              maxDate: maxDate,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  _UCalendarState createState() => _UCalendarState();
}

class _UCalendarState extends State<UCalendar> {
  late DateTime _focus; // 当前展示的月份（day=1）

  @override
  void initState() {
    super.initState();
    final v = widget.value ?? DateTime.now();
    _focus = DateTime(v.year, v.month, 1);
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _disabled(DateTime d) {
    if (widget.minDate != null && d.isBefore(_startOfDay(widget.minDate!))) return true;
    if (widget.maxDate != null && d.isAfter(_startOfDay(widget.maxDate!))) return true;
    return false;
  }

  DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

  void _shiftMonth(int delta) {
    setState(() => _focus = DateTime(_focus.year, _focus.month + delta, 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = UView.of(context);
    final accent = theme.colorOf(widget.type ?? UViewType.primary);
    final today = DateTime.now();

    final first = DateTime(_focus.year, _focus.month, 1);
    final leading = (first.weekday - 1) % 7; // 周一为第一列
    final daysInMonth = DateTime(_focus.year, _focus.month + 1, 0).day;

    final cells = <Widget>[];
    for (int i = 0; i < leading; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(_focus.year, _focus.month, d);
      final isSelected = widget.value != null && _sameDay(date, widget.value!);
      final isToday = _sameDay(date, today);
      final disabled = _disabled(date);

      cells.add(_DayCell(
        day: d,
        isSelected: isSelected,
        isToday: isToday,
        disabled: disabled,
        accent: accent,
        theme: theme,
        onTap: disabled
            ? null
            : () {
                widget.onChanged?.call(date);
                setState(() {});
              },
      ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showHeader)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _shiftMonth(-1),
                ),
                UText('${_focus.year} 年 ${_focus.month} 月', bold: true, size: 16),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _shiftMonth(1),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: const ['一', '二', '三', '四', '五', '六', '日']
                .map((w) => Expanded(
                      child: Center(
                        child: UText(w, size: 12, type: UViewType.info),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 4),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: cells,
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isSelected;
  final bool isToday;
  final bool disabled;
  final Color accent;
  final UViewThemeData theme;
  final VoidCallback? onTap;

  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.disabled,
    required this.accent,
    required this.theme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = disabled
        ? theme.lightTextColor
        : (isSelected ? theme.inverseTextColor : theme.mainTextColor);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(theme.radius),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? accent : null,
          borderRadius: BorderRadius.circular(theme.radius),
          border: (!isSelected && isToday)
              ? Border.all(color: accent, width: 1)
              : null,
        ),
        child: Center(
          child: UText(
            '$day',
            color: color,
            size: 14,
            bold: isToday || isSelected,
          ),
        ),
      ),
    );
  }
}
