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
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
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
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Stack(
        children: [
          // 装饰圆
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 卡皮吉祥物 + 对话气泡
          Positioned(
            top: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
                  ),
                  child: const Text(
                    '早安，今天也是\n平静的一天呢~',
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 4),
                const CapyMascot(),
              ],
            ),
          ),

          // 数据区域（左侧）
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '当前支出',
                  style: TextStyle(
                    color: Color(0xFF2C6957),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppUtils.formatCurrency(expense),
                  style: const TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 140),
                Row(
                  children: [
                    _MiniCard(label: '收入', value: income),
                    const SizedBox(width: 10),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.35),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF2C6957), fontSize: 11, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(
              AppUtils.formatCurrencyShort(value),
              style: const TextStyle(color: AppColors.darkGreen, fontSize: 16, fontWeight: FontWeight.w800),
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
        width: 220,
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text(project.emoji, style: const TextStyle(fontSize: 22))),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.peach,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('进行中', style: TextStyle(color: Color(0xFF795841), fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const Spacer(),
            Text(
              project.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('已用 ${AppUtils.formatCurrencyShort(project.spent)}', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                Text('预算 ${AppUtils.formatCurrencyShort(project.budget)}', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: project.progressPercent,
                backgroundColor: AppColors.surfaceGray,
                valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
                minHeight: 6,
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
              fontSize: 15,
              fontWeight: FontWeight.w800,
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
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(actionLabel!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.darkGreen)),
          ),
      ],
    );
  }
}
