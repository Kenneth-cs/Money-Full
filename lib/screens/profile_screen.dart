import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/shared/app_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
        child: Column(
          children: [
            const AppHeader(title: '个人中心', showBell: true),

            // 用户信息
            Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryGreen, Colors.white],
                        ),
                        boxShadow: [BoxShadow(color: AppColors.primaryGreen.withOpacity(0.3), blurRadius: 20)],
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Container(
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.surfaceGray),
                        child: const Center(child: Text('🦫', style: TextStyle(fontSize: 48))),
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.background, width: 2),
                      ),
                      child: const Icon(Icons.edit_rounded, size: 15, color: AppColors.darkGreen),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('Julian Thorne', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                const Text('高级财务分析师', style: TextStyle(fontSize: 14, color: AppColors.textHint, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 28),

            // 统计卡片
            Row(
              children: const [
                _StatCard(icon: Icons.create_new_folder_outlined, count: 12, label: '活跃项目', color: AppColors.primaryGreen, textColor: AppColors.darkGreen),
                SizedBox(width: 14),
                _StatCard(icon: Icons.book_outlined, count: 48, label: '总账目', color: AppColors.yellowGreen, textColor: Color(0xFF5F621F)),
              ],
            ),
            const SizedBox(height: 28),

            // 账户管理菜单
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('账户管理', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textHint, letterSpacing: 2)),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)],
              ),
              child: const Column(
                children: [
                  _MenuItem(icon: Icons.download_rounded, iconBg: Color(0x66FDD1B4), iconColor: AppColors.warningOrange, title: '导出数据'),
                  _Divider(),
                  _MenuItem(icon: Icons.palette_rounded, iconBg: Color(0x66A8E6CF), iconColor: AppColors.darkGreen, title: '主题设置'),
                  _Divider(),
                  _MenuItem(icon: Icons.notifications_outlined, iconBg: Color(0x99DCDE8D), iconColor: Color(0xFF5F621F), title: '通知偏好'),
                  _Divider(),
                  _MenuItem(icon: Icons.help_outline_rounded, iconBg: Color(0xFFEEEEEE), iconColor: Colors.grey, title: '帮助与反馈'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 退出登录
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: const Text('退出登录', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFDAD6),
                  foregroundColor: const Color(0xFF93000A),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final Color color;
  final Color textColor;

  const _StatCard({required this.icon, required this.count, required this.label, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: textColor),
            const SizedBox(height: 12),
            Text('$count', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: textColor)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: textColor.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;

  const _MenuItem({required this.icon, required this.iconBg, required this.iconColor, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 76, endIndent: 16, color: Color(0xFFF3F3F3));
  }
}
