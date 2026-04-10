/// 账单记录模型
class Transaction {
  final String id;
  final String projectId;
  final String categoryId;
  final double amount;
  final TransactionType type;
  final String note;
  final DateTime date;

  const Transaction({
    required this.id,
    required this.projectId,
    required this.categoryId,
    required this.amount,
    required this.type,
    required this.note,
    required this.date,
  });

  bool get isExpense => type == TransactionType.expense;

  Transaction copyWith({
    String? id,
    String? projectId,
    String? categoryId,
    double? amount,
    TransactionType? type,
    String? note,
    DateTime? date,
  }) {
    return Transaction(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }
}

/// 交易类型
enum TransactionType { expense, income }
