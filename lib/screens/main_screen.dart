import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../core/theme.dart';
import '../core/app_colors.dart';
import 'dashboard_screen.dart';
import 'projects_screen.dart';
import 'analytics_screen.dart';
import 'profile_screen.dart';
import 'add_record_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const ProjectsScreen(),
    const AnalyticsScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showAddRecord() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddRecordScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background/Pages
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          
          // Custom Bottom Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 36, // 稍微上浮
            child: Container(
              height: 68, // 调整高度符合图5比例
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(34),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home_rounded, Icons.home_outlined, "首页", 0), // 替换了图标使其更符合图2
                  _buildNavItem(Icons.grid_view_rounded, Icons.grid_view_outlined, "项目", 1),
                  const SizedBox(width: 80), // 给中间的大按钮留出足够空间，稍微调大
                  _buildNavItem(Icons.bar_chart_rounded, Icons.bar_chart_outlined, "统计", 2),
                  _buildNavItem(Icons.person_rounded, Icons.person_outline_rounded, "我的", 3),
                ],
              ),
            ),
          ),
          
          // Center Big Add Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 38, // 与 NavigationBar 居中对齐 (36 + (68-64)/2 = 38)
            child: Center(
              child: GestureDetector(
                onTap: _showAddRecord,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA1E4C9), // 图5中间加号按钮稍亮的薄荷绿
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFA1E4C9).withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center( // 居中
                    child: Icon(
                      Icons.add_rounded, // 更粗的加号图标
                      size: 34, // 稍微再大一点，图2加号很大
                      color: Color(0xFF1B211C), // 深色加号
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData activeIcon, IconData inactiveIcon, String label, int index) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? const Color(0xFF1B211C) : AppColors.textHint;
    final icon = isSelected ? activeIcon : inactiveIcon;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTabTapped(index),
        child: SizedBox(
          height: 68,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 背景渐变药丸
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: isSelected ? 1.0 : 0.0,
                curve: Curves.easeInOut,
                child: Container(
                  width: 48, // 缩小一下宽度，匹配图2的淡绿色圆圈比例
                  height: 48, // 缩小一下高度
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F6F0), // 极浅的绿色药丸背景
                    shape: BoxShape.circle, // 图2是圆形的背景
                  ),
                ),
              ),
              // 内容 (Icon + Text)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                    child: Icon(
                      icon,
                      key: ValueKey<bool>(isSelected),
                      color: color, 
                      size: 26, // 图标调大一些，和图2一样
                    ),
                  ),
                  const SizedBox(height: 2), // 调整间距以适应图2的紧凑比例
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: TextStyle(
                      color: color,
                      fontSize: 10, // 字不变
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      fontFamily: DefaultTextStyle.of(context).style.fontFamily, // 继承字体避免样式丢失
                    ),
                    child: Text(label),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
