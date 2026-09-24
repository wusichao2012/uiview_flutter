/// uView Flutter —— uView UI 组件库的 Flutter 社区复刻版。
///
/// 顶层用 [UView] 注入主题（对标 uView `ConfigProvider`），组件内部用
/// `UView.of(context)` 读取主题 token。
library uview_flutter;

// 主题与全局配置
export 'src/theme/uview_theme_data.dart';
export 'src/theme/uview.dart';

// 工具
export 'src/utils/uview_color_utils.dart';

// 基础组件
export 'src/components/u_text.dart';
export 'src/components/u_button.dart';
export 'src/components/u_tag.dart';
export 'src/components/u_badge.dart';
export 'src/components/u_cell.dart';
export 'src/components/u_icon.dart';
export 'src/components/u_image.dart';
export 'src/components/u_loading.dart';
export 'src/components/u_gap.dart';
export 'src/components/u_layout.dart';
export 'src/components/u_divider.dart';

// 表单组件
export 'src/components/u_input.dart';
export 'src/components/u_textarea.dart';
export 'src/components/u_search.dart';
export 'src/components/u_verification_code.dart';
export 'src/components/u_form.dart';
export 'src/components/u_checkbox.dart';
export 'src/components/u_radio.dart';
export 'src/components/u_switch.dart';
export 'src/components/u_select.dart';
export 'src/components/u_number_box.dart';
export 'src/components/u_slider.dart';
export 'src/components/u_rate.dart';

// 表单组件（剩余）
export 'src/components/u_picker.dart';
export 'src/components/u_calendar.dart';
export 'src/components/u_upload.dart';
export 'src/components/u_keyboard.dart';

// 反馈组件
export 'src/components/u_toast.dart';
export 'src/components/u_alert_tips.dart';
export 'src/components/u_modal.dart';
export 'src/components/u_popup.dart';
export 'src/components/u_action_sheet.dart';
export 'src/components/u_notice_bar.dart';
export 'src/components/u_collapse.dart';
export 'src/components/u_swipe_action.dart';

// 导航组件
export 'src/components/u_navbar.dart';
export 'src/components/u_tabbar.dart';
export 'src/components/u_tabs.dart';
export 'src/components/u_steps.dart';
export 'src/components/u_dropdown.dart';
export 'src/components/u_back_top.dart';

// 布局组件
export 'src/components/u_grid.dart';
export 'src/components/u_swiper.dart';
export 'src/components/u_avatar.dart';
export 'src/components/u_empty.dart';
export 'src/components/u_skeleton.dart';
export 'src/components/u_sticky.dart';
export 'src/components/u_waterfall.dart';

// 数据/其他
export 'src/components/u_progress.dart';
export 'src/components/u_count_down.dart';
export 'src/components/u_count_to.dart';
export 'src/components/u_card.dart';
export 'src/components/u_load_more.dart';

// 其他组件
export 'src/components/u_floating_ball.dart';
