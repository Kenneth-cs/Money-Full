import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_colors.dart';
import '../core/utils.dart';
import '../models/project.dart';
import '../models/transaction.dart';
import '../providers/app_state.dart';
import '../widgets/shared/capy_mascot.dart';
import '../widgets/shared/app_header.dart';
import 'add_record_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);
    final transactions = ref.watch(transactionsProvider.notifier);
    final activeProjects = projects.where((p) => !p.isArchived).toList();
    final recentTx = ref.watch(transactionsProvider).take(4).toList();
    final monthlyExpense = transactions.monthlyExpense;
    final monthlyIncome = transactions.monthlyIncome;
    final monthlySaving = monthlyIncome - monthlyExpense;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(title: '首页看板', showBell: true),

            // 财务看板卡片（莫兰迪绿渐变 + 卡皮）
            _FinanceSummaryCard(
              expense: monthlyExpense,
              income: monthlyIncome,
              saving: monthlySaving,
            ),
            const SizedBox(height: 28),

            // 进行中的项目
            _SectionHeader(
              title: '进行中的项目',
              actionLabel: '查看全部',
              onAction: () => ref.read(activeTabProvider.notifier).state = 1,
            ),
                const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), // 让滑动更丝滑
                itemCount: activeProjects.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) => _ProjectCardHorizontal(
                  project: activeProjects[i],
                  onTap: () => _openProjectDetail(context, activeProjects[i]),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // 最近交易
            const _SectionHeader(title: '最近交易'),
            const SizedBox(height: 12),
            ...recentTx.map((tx) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TransactionItem(transaction: tx),
            )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _openProjectDetail(BuildContext context, Project project) {
    // TODO: 导航到项目详情
  }
}

// ===== 财务看板卡片 =====
class _FinanceSummaryCard extends StatelessWidget {
  final double expense;
  final double income;
  final double saving;

  const _FinanceSummaryCard({required this.expense, required this.income, required this.saving});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryGreen, AppColors.lightGreen],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28), // 左右边距稍微收一点，让大字体不拥挤
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 卡皮吉祥物 + 对话气泡
          Positioned(
            top: -16, // 往上移动，避免与底部储蓄卡片重叠
            right: 0, // 靠右
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 气泡框 (黄色框位置，左右拉长)
                Container(
                  width: 166, // 左右拉长
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(4), // 小尾巴在右下
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
                  ),
                  child: const Text(
                    '早安，今天也是平静的一天呢~', // 去掉换行，单行显示
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6), // 气泡和卡皮之间的距离
                // 卡皮 (红框位置)
                const Padding(
                  padding: EdgeInsets.only(right: 16.0), // 让卡皮稍往左移一点，对齐气泡的小尾巴
                  child: CapyMascot(),
                ),
              ],
            ),
          ),

          // 数据区域（左侧）
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '当前支出',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppUtils.formatCurrency(expense),
                  style: const TextStyle(
                    color: AppColors.darkGreen, // 参考图2修改了数字颜色
                    fontSize: 36, // 字体再调大点匹配图2
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 28), // 微调间距以适合大字体
                Row(
                  children: [
                    _MiniCard(label: '收入', value: income),
                    const SizedBox(width: 12),
                    _MiniCard(label: '储蓄', value: saving),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String label;
  final double value;

  const _MiniCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.35),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.darkGreen, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              AppUtils.formatCurrencyShort(value), // 已经带有¥前缀
              style: const TextStyle(color: AppColors.darkGreen, fontSize: 18, fontWeight: FontWeight.w800), // 参考图2修改颜色和大小
            ),
          ],
        ),
      ),
    );
  }
}

// ===== 横向项目卡片 =====
class _ProjectCardHorizontal extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const _ProjectCardHorizontal({required this.project, required this.onTap});

  Color get _progressColor {
    switch (project.budgetStatus) {
      case BudgetStatus.overBudget:
        return AppColors.dangerRed;
      case BudgetStatus.warning:
        return AppColors.warningOrange;
      case BudgetStatus.healthy:
        return AppColors.darkGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180, // 调整为更宽以符合图1
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text(project.emoji, style: const TextStyle(fontSize: 18))),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE1D1), // 类似图1的蜜桃橙底色
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('进行中', style: TextStyle(color: Color(0xFFC78D63), fontSize: 9, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const Spacer(),
            Text(
              project.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary), // 加粗加黑
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 保持左右对齐，更符合卡片布局
              children: [
                Text('已用 ${AppUtils.formatCurrencyShort(project.spent)}', style: const TextStyle(fontSize: 10, color: AppColors.textHint, fontWeight: FontWeight.w500)),
                Text('预算 ${AppUtils.formatCurrencyShort(project.budget)}', style: const TextStyle(fontSize: 10, color: AppColors.textHint, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: project.progressPercent,
                backgroundColor: AppColors.surfaceGray,
                valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
                minHeight: 6, // 调整进度条高度
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== 交易记录条目 =====
class _TransactionItem extends ConsumerWidget {
  final Transaction transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.read(categoriesProvider);
    final cat = categories.firstWhere(
      (c) => c.id == transaction.categoryId,
      orElse: () => categories.first,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(color: cat.color.withOpacity(0.3), shape: BoxShape.circle),
            child: Icon(cat.icon, size: 22, color: cat.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.note, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(
                  '${cat.name} · ${AppUtils.formatDateTime(transaction.date)}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                ),
              ],
            ),
          ),
                Text(
                  '${transaction.isExpense ? "- " : "+ "}${AppUtils.formatCurrency(transaction.amount)}',
                  style: TextStyle(
                    fontSize: 16, // 加大一点以匹配图2底部交易记录数字的重量感
                    fontWeight: FontWeight.w900, // 加黑
                    color: transaction.isExpense ? AppColors.expense : AppColors.income,
                  ),
                ),
        ],
      ),
    );
  }
}

// ===== 分区标题 =====
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.textPrimary)), // 加黑加粗
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(actionLabel!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.darkGreen)),
          ),
      ],
    );
  }
}
