import 'package:flutter/material.dart';

/// 分类标签模型
class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final bool isGlobal; // true=全局通用，false=项目专属

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isGlobal = true,
  });
}

/// 内置默认分类
class DefaultCategories {
  static final List<Category> all = [
    Category(
      id: 'food',
      name: '餐饮',
      icon: Icons.restaurant_rounded,
      color: const Color(0xFFA8E6CF),
    ),
    Category(
      id: 'shopping',
      name: '购物',
      icon: Icons.shopping_bag_rounded,
      color: const Color(0xFFFDD1B4),
    ),
    Category(
      id: 'transport',
      name: '交通',
      icon: Icons.directions_car_rounded,
      color: const Color(0xFFDCDE8D),
    ),
    Category(
      id: 'home',
      name: '居家',
      icon: Icons.home_rounded,
      color: const Color(0xFFDBEAFE),
    ),
    Category(
      id: 'entertainment',
      name: '娱乐',
      icon: Icons.sports_esports_rounded,
      color: const Color(0xFFF3E8FF),
    ),
    Category(
      id: 'health',
      name: '医疗',
      icon: Icons.favorite_rounded,
      color: const Color(0xFFFCE7F3),
    ),
    Category(
      id: 'education',
      name: '教育',
      icon: Icons.school_rounded,
      color: const Color(0xFFFFEDD5),
    ),
    Category(
      id: 'work',
      name: '工作',
      icon: Icons.work_rounded,
      color: const Color(0xFFEEEEEE),
    ),
  ];
}
