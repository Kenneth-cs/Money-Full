import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_colors.dart';
import '../core/utils.dart';
import '../models/project.dart';
import '../providers/app_state.dart';
import '../widgets/shared/app_header.dart';
import 'project_detail_screen.dart';
import 'new_project_screen.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  int _tabIndex = 0; // 0=进行中 1=已归档

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);
    final active = projects.where((p) => !p.isArchived).toList();
    final archived = projects.where((p) => p.isArchived).toList();
    final displayList = _tabIndex == 0 ? active : archived;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
        child: Column(
          children: [
            const AppHeader(title: '项目中心'),

            // Tab 切换
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  _Tab(label: '进行中', isActive: _tabIndex == 0, onTap: () => setState(() => _tabIndex = 0)),
                  _Tab(label: '已归档', isActive: _tabIndex == 1, onTap: () => setState(() => _tabIndex = 1)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 项目列表
            ...displayList.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ProjectCard(
                project: p,
                onViewDetail: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProjectDetailScreen(projectId: p.id)),
                ),
              ),
            )),

            // 新建项目按钮
            if (_tabIndex == 0) ...[
              const SizedBox(height: 8),
              // 卡皮提示语
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '🦫 慢慢规划，不着急，我在这儿陪你。',
                  style: TextStyle(fontSize: 13, color: AppColors.textHint, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewProjectScreen()),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFBFC9C3), width: 3, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(color: AppColors.cardWhite, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
                        child: const Icon(Icons.add_rounded, size: 30, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      const Text('新建项目', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ===== Tab 按钮 =====
class _Tab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isActive ? AppColors.darkGreen : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===== 项目详情卡片 =====
class _ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onViewDetail;

  const _ProjectCard({required this.project, required this.onViewDetail});

  Color get _progressBarColor {
    switch (project.budgetStatus) {
      case BudgetStatus.overBudget:
        return AppColors.dangerRed;
      case BudgetStatus.warning:
        return AppColors.warningOrange;
      case BudgetStatus.healthy:
        return AppColors.darkGreen;
    }
  }

  String get _statusLabel {
    if (project.isArchived) return '已归档';
    return '进行中';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: AppColors.primaryGreen.withOpacity(0.15), shape: BoxShape.circle),
                child: Center(child: Text(project.emoji, style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    Text('创建于 ${project.createdAt.year}年${project.createdAt.month}月${project.createdAt.day}日',
                        style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: AppColors.peach, borderRadius: BorderRadius.circular(20)),
                child: Text(_statusLabel, style: const TextStyle(color: Color(0xFF795841), fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 项目描述
          Text(project.description, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
          const SizedBox(height: 16),

          // 预算进度
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('预算进度', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
              Text('${(project.progressPercent * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.darkGreen)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: project.progressPercent,
              backgroundColor: AppColors.surfaceGray,
              valueColor: AlwaysStoppedAnimation<Color>(_progressBarColor),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('已用: ${AppUtils.formatCurrency(project.spent)}', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
              Text('剩余: ${AppUtils.formatCurrency(project.remaining)}', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
            ],
          ),
          const SizedBox(height: 16),

          // 查看详情按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewDetail,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: AppColors.darkGreen,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('查看详情 →', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }
}
