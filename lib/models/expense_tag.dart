class ExpenseTag {
  final String expenseId;
  final String tagId;
  final DateTime? createdAt;

  ExpenseTag({
    required this.expenseId,
    required this.tagId,
    this.createdAt,
  });

  factory ExpenseTag.fromJson(Map<String, dynamic> json) {
    return ExpenseTag(
      expenseId: json['expense_id'],
      tagId: json['tag_id'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expense_id': expenseId,
      'tag_id': tagId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ExpenseTag copyWith({
    String? expenseId,
    String? tagId,
    DateTime? createdAt,
  }) {
    return ExpenseTag(
      expenseId: expenseId ?? this.expenseId,
      tagId: tagId ?? this.tagId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}