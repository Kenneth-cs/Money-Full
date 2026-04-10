import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_colors.dart';
import 'core/app_theme.dart';
import 'providers/app_state.dart';
import 'screens/dashboard_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/add_record_screen.dart';

class MoneyFullApp extends StatelessWidget {
  const MoneyFullApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '钱小满',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const _AppShell(),
    );
  }
}

/// 主导航框架
class _AppShell extends ConsumerWidget {
  const _AppShell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeTabProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: activeTab > 2 ? activeTab - 1 : activeTab,
        children: const [
          DashboardScreen(),
          ProjectsScreen(),
          AnalyticsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(activeTab: activeTab),
    );
  }
}

/// 底部导航栏
class _BottomNav extends ConsumerWidget {
  final int activeTab;

  const _BottomNav({required this.activeTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded, label: '首页', index: 0, activeTab: activeTab),
              _NavItem(icon: Icons.grid_view_rounded, label: '项目', index: 1, activeTab: activeTab),

              // 中间 + 记账大按钮
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const _AddRecordSheet(),
                  );
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add_rounded, size: 32, color: AppColors.darkGreen),
                ),
              ),

              _NavItem(icon: Icons.bar_chart_rounded, label: '统计', index: 3, activeTab: activeTab),
              _NavItem(icon: Icons.person_rounded, label: '我的', index: 4, activeTab: activeTab),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends ConsumerWidget {
  final IconData icon;
  final String label;
  final int index;
  final int activeTab;

  const _NavItem({required this.icon, required this.label, required this.index, required this.activeTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = activeTab == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(activeTabProvider.notifier).state = index;
      },
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primaryGreen.withOpacity(0.25) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 24, color: isActive ? AppColors.darkGreen : AppColors.textHint),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isActive ? AppColors.darkGreen : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 记账弹窗（全屏模态）
class _AddRecordSheet extends StatelessWidget {
  const _AddRecordSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        color: AppColors.background,
      ),
      child: const AddRecordScreen(),
    );
  }
}
