import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../models/transaction.dart';
import '../models/category.dart';

/// 模拟数据 - 与React原型保持一致
final _mockProjects = [
  Project(
    id: 'xinjiang',
    name: '新疆之旅',
    emoji: '✈️',
    description: '美丽的新疆之行，探索壮美的自然风光和独特的风土人情。',
    budget: 15000,
    spent: 8500,
    createdAt: DateTime(2023, 10, 1),
  ),
  Project(
    id: 'daily',
    name: '日常开销',
    emoji: '🏠',
    description: '日常生活的基础支出，包括三餐、交通和日用品。',
    budget: 4000,
    spent: 3200,
    createdAt: DateTime(2023, 9, 1),
  ),
  Project(
    id: 'brand',
    name: '品牌重塑项目',
    emoji: '🎨',
    description: '为本地精品咖啡馆设计的全新视觉系统，包括LOGO、包装及线上社交媒体视觉。',
    budget: 6800,
    spent: 3200,
    createdAt: DateTime(2023, 11, 5),
  ),
  Project(
    id: 'decoration',
    name: '海景房装修',
    emoji: '🏡',
    description: '温馨自然的北欧风格，注重采光与海景视野的最大化，打造宁静的度假居住空间。',
    budget: 100000,
    spent: 75000,
    createdAt: DateTime(2023, 10, 12),
  ),
];

final _mockTransactions = [
  Transaction(
    id: '1',
    projectId: 'xinjiang',
    categoryId: 'food',
    amount: 458,
    type: TransactionType.expense,
    note: '海鲜餐厅',
    date: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Transaction(
    id: '2',
    projectId: 'brand',
    categoryId: 'work',
    amount: 120,
    type: TransactionType.expense,
    note: '设计素材',
    date: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
  ),
  Transaction(
    id: '3',
    projectId: 'daily',
    categoryId: 'transport',
    amount: 100,
    type: TransactionType.expense,
    note: '交通充值',
    date: DateTime.now().subtract(const Duration(days: 1, hours: 16)),
  ),
  Transaction(
    id: '4',
    projectId: 'brand',
    categoryId: 'work',
    amount: 5000,
    type: TransactionType.income,
    note: '项目结款',
    date: DateTime(2023, 10, 24),
  ),
];

// ===== Providers =====

/// 项目列表 Provider
final projectsProvider = StateNotifierProvider<ProjectsNotifier, List<Project>>(
  (ref) => ProjectsNotifier(_mockProjects),
);

class ProjectsNotifier extends StateNotifier<List<Project>> {
  ProjectsNotifier(super.projects);

  /// 添加新项目
  void addProject(Project project) {
    state = [...state, project];
  }

  /// 归档项目
  void archiveProject(String id) {
    state = state.map((p) => p.id == id ? p.copyWith(isArchived: true) : p).toList();
  }

  /// 进行中的项目
  List<Project> get activeProjects => state.where((p) => !p.isArchived).toList();

  /// 已归档的项目
  List<Project> get archivedProjects => state.where((p) => p.isArchived).toList();
}

/// 交易记录 Provider
final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<Transaction>>(
  (ref) => TransactionsNotifier(_mockTransactions),
);

class TransactionsNotifier extends StateNotifier<List<Transaction>> {
  TransactionsNotifier(super.transactions);

  /// 添加新交易
  void addTransaction(Transaction transaction) {
    state = [transaction, ...state];
  }

  /// 获取某项目的交易记录
  List<Transaction> getByProject(String projectId) {
    return state.where((t) => t.projectId == projectId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// 本月总支出
  double get monthlyExpense {
    final now = DateTime.now();
    return state
        .where((t) => t.type == TransactionType.expense && t.date.month == now.month && t.date.year == now.year)
        .fold(0, (sum, t) => sum + t.amount);
  }

  /// 本月总收入
  double get monthlyIncome {
    final now = DateTime.now();
    return state
        .where((t) => t.type == TransactionType.income && t.date.month == now.month && t.date.year == now.year)
        .fold(0, (sum, t) => sum + t.amount);
  }
}

/// 分类列表 Provider
final categoriesProvider = Provider<List<Category>>(
  (ref) => DefaultCategories.all,
);

/// 当前导航 Tab Provider
final activeTabProvider = StateProvider<int>((ref) => 0);
