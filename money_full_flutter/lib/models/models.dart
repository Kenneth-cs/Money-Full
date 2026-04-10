class Project {
  final String id;
  final String title;
  final String description;
  final double budget;
  final String icon;
  final String colorHex;
  final DateTime createdAt;
  final bool isArchived;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
    required this.icon,
    required this.colorHex,
    required this.createdAt,
    this.isArchived = false,
  });
}

class TransactionRecord {
  final String id;
  final String projectId;
  final String categoryId;
  final double amount;
  final bool isExpense;
  final String note;
  final DateTime date;

  TransactionRecord({
    required this.id,
    required this.projectId,
    required this.categoryId,
    required this.amount,
    required this.isExpense,
    this.note = '',
    required this.date,
  });
}

class Category {
  final String id;
  final String name;
  final String icon;
  final String colorHex;
  final bool isExpense;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    this.isExpense = true,
  });
}
