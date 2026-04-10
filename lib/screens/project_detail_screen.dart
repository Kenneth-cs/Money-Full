import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_colors.dart';
import '../core/utils.dart';
import '../models/project.dart';
import '../models/transaction.dart';
import '../providers/app_state.dart';
import '../widgets/shared/app_header.dart';

class ProjectDetailScreen extends ConsumerWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);
    final transNotifier = ref.watch(transactionsProvider.notifier);
    final project = projects.firstWhere((p) => p.id == projectId);
    final transactions = transNotifier.getByProject(projectId);
    final categories = ref.read(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 顶部渐变Hero区域
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryGreen, AppColors.lightGreen],
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
              ),
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppHeader(
                    title: '',
                    showBack: true,
                    onBack: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      Text(project.emoji, style: const TextStyle(fontSize: 40)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(project.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.darkGreen)),
                            Text(project.description, style: const TextStyle(fontSize: 13, color: Color(0xFF2C6957), height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 预算进度条
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('已用 ${AppUtils.formatCurrency(project.spent)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.darkGreen)),
                      Text('总预算 ${AppUtils.formatCurrency(project.budget)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.darkGreen)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: project.progressPercent,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkGreen),
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 时间轴
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  if (i == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text('账单时间轴', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    );
                  }
                  final tx = transactions[i - 1];
                  final cat = categories.firstWhere((c) => c.id == tx.categoryId, orElse: () => categories.first);
                  return _TimelineItem(transaction: tx, category: cat, isLast: i == transactions.length);
                },
                childCount: transactions.isEmpty ? 1 : transactions.length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Transaction transaction;
  final dynamic category;
  final bool isLast;

  const _TimelineItem({required this.transaction, required this.category, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // 时间轴线
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: transaction.isExpense ? AppColors.expense : AppColors.income,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: AppColors.surfaceGray)),
            ],
          ),
          const SizedBox(width: 14),
          // 内容
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: category.color.withOpacity(0.2), shape: BoxShape.circle),
                      child: Icon(category.icon, size: 20, color: category.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(transaction.note, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                          Text(AppUtils.formatDateTime(transaction.date), style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                        ],
                      ),
                    ),
                    Text(
                      '${transaction.isExpense ? "- " : "+ "}${AppUtils.formatCurrency(transaction.amount)}',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: transaction.isExpense ? AppColors.expense : AppColors.income),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
