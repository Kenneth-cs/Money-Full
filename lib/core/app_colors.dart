import 'package:flutter/material.dart';

/// 钱小满 - 莫兰迪色系色彩系统
class AppColors {
  // 主色调：莫兰迪薄荷绿
  static const Color primaryGreen = Color(0xFFA8E6CF);
  static const Color darkGreen = Color(0xFF2C6957);
  static const Color lightGreen = Color(0xFFDCEDC1);

  // 背景色
  static const Color background = Color(0xFFF9F9F9);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color surfaceGray = Color(0xFFF3F3F3);

  // 文字色
  static const Color textPrimary = Color(0xFF1A1C1C);
  static const Color textSecondary = Color(0xFF404945);
  static const Color textHint = Color(0xFF9E9E9E);

  // 分类点缀色 (莫兰迪系)
  static const Color peach = Color(0xFFFDD1B4);      // 暖橘
  static const Color yellowGreen = Color(0xFFDCDE8D); // 黄绿
  static const Color sunnyYellow = Color(0xFFE5E796); // 柠檬黄
  static const Color lavender = Color(0xFFF3E8FF);    // 薰衣草
  static const Color blueLight = Color(0xFFDBEAFE);   // 天蓝
  static const Color pink = Color(0xFFFCE7F3);        // 粉

  // 状态色
  static const Color expense = Color(0xFFBA1A1A);     // 支出红
  static const Color income = Color(0xFF2C6956);      // 收入绿
  static const Color warningOrange = Color(0xFFD97736);
  static const Color dangerRed = Color(0xFFBA1A1A);

  // 图表色系
  static const List<Color> chartColors = [
    primaryGreen,
    peach,
    yellowGreen,
    Color(0xFFC9CB7D),
  ];
}
