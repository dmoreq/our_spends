class Expense {
  final String id;
  final String userId;
  final DateTime date;
  final double amount;
  final String currency;
  final String category;
  final String item;
  final DateTime? createdAt;

  Expense({
    required this.id,
    required this.userId,
    required this.date,
    required this.amount,
    required this.currency,
    required this.category,
    required this.item,
    this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      date: DateTime.parse(json['date']),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] ?? 'VND',
      category: json['category'] ?? '',
      item: json['item'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'amount': amount,
      'currency': currency,
      'category': category,
      'item': item,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}