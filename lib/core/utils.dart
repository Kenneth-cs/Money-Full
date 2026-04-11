import 'package:intl/intl.dart';

/// 全局工具函数
class AppUtils {
  // 货币格式化：¥ 12,840.00
  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0.00', 'zh_CN');
    return '¥ ${formatter.format(amount)}'; // 依然保留了¥，但是在DashboardScreen调用时如果数字大也可以直接用这个
  }

  // 简短货币格式：¥ 12k
  static String formatCurrencyShort(double amount) {
    if (amount >= 1000) {
      return '¥ ${(amount / 1000).toStringAsFixed(0)}k';
    }
    return '¥ ${amount.toStringAsFixed(0)}';
  }

  // 日期格式化
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return '今天';
    if (diff == 1) return '昨天';
    return DateFormat('M月d日').format(date);
  }

  // 时间格式化
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  // 日期时间组合格式化
  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} ${formatTime(date)}';
  }
}
