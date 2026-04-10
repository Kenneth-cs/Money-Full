# 钱小满 (Money Full) Flutter App

本项目是将 React 原型转换而来的 Flutter 应用程序，采用纯 Dart 开发，实现 iOS / Android 双端跨平台高度一致性体验。

## 目前进度
阶段一 (UI & 基础架构) 已基本完成：
- [x] Flutter 项目初始化与依赖配置 (`pubspec.yaml`)
- [x] 主题、颜色、基础组件封装 (`AppTheme`, `AppColors`)
- [x] 核心数据模型 (`Project`, `Transaction`, `Category`)
- [x] 状态管理模拟数据层 (`Riverpod`)
- [x] 底部带动画和沉浮按钮的导航栏 (`AppShell`)
- [x] 首页看版 (`DashboardScreen` + `CapyMascot` 纯代码绘制水豚动画)
- [x] 项目中心与详情页面 (`ProjectsScreen`, `ProjectDetailScreen` 包含时间轴)
- [x] 财务统计高级页面 (`AnalyticsScreen` 包含环形图、曲线图及预算监控)
- [x] 个人中心页面 (`ProfileScreen`)
- [x] 记一笔丝滑交互页 (`AddRecordScreen` 全屏模态 + 自定义丝滑数字小键盘)

## 如何运行
1. 确保已安装 Flutter SDK (`flutter --version`)。
2. 在项目根目录 (`money_full_flutter`) 运行 `flutter pub get` 获取依赖。
3. 运行 `flutter run` 启动应用 (建议在 iOS 模拟器或 Android 模拟器上运行，体验最佳丝滑效果)。
