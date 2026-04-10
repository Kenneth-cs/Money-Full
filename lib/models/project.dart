/// 项目模型 - "抽屉"容器
class Project {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final double budget;
  final double spent;
  final DateTime createdAt;
  final bool isArchived;

  const Project({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.budget,
    required this.spent,
    required this.createdAt,
    this.isArchived = false,
  });

  /// 预算使用百分比
  double get progressPercent => budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;

  /// 剩余预算
  double get remaining => budget - spent;

  /// 预算状态
  BudgetStatus get budgetStatus {
    final percent = budget > 0 ? spent / budget : 0.0;
    if (percent >= 1.0) return BudgetStatus.overBudget;
    if (percent >= 0.8) return BudgetStatus.warning;
    return BudgetStatus.healthy;
  }

  Project copyWith({
    String? id,
    String? name,
    String? emoji,
    String? description,
    double? budget,
    double? spent,
    DateTime? createdAt,
    bool? isArchived,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      budget: budget ?? this.budget,
      spent: spent ?? this.spent,
      createdAt: createdAt ?? this.createdAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}

/// 预算健康状态
enum BudgetStatus { healthy, warning, overBudget }
