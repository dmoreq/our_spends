class Expense {
  final String id;
  final String userId;
  final DateTime date;
  final double amount;
  final String currency;

  final String item;
  final String? description;
  final String? location;
  final String? paymentMethod;
  final String? receiptUrl;
  final bool isRecurring;
  final String? recurringFrequency;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int syncStatus;

  Expense({
    required this.id,
    required this.userId,
    required this.date,
    required this.amount,
    required this.currency,

    required this.item,
    this.description,
    this.location,
    this.paymentMethod,
    this.receiptUrl,
    this.isRecurring = false,
    this.recurringFrequency,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.syncStatus = 0,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      date: DateTime.parse(json['date']),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] ?? 'VND',

      item: json['item'] ?? '',
      description: json['description'],
      location: json['location'],
      paymentMethod: json['payment_method'],
      receiptUrl: json['receipt_url'],
      isRecurring: json['is_recurring'] ?? false,
      recurringFrequency: json['recurring_frequency'],
      notes: json['notes'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      syncStatus: json['sync_status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'amount': amount,
      'currency': currency,

      'item': item,
      'description': description,
      'location': location,
      'payment_method': paymentMethod,
      'receipt_url': receiptUrl,
      'is_recurring': isRecurring,
      'recurring_frequency': recurringFrequency,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'sync_status': syncStatus,
    };
  }

  Expense copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? amount,
    String? currency,

    String? item,
    String? description,
    String? location,
    String? paymentMethod,
    String? receiptUrl,
    bool? isRecurring,
    String? recurringFrequency,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncStatus,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,

      item: item ?? this.item,
      description: description ?? this.description,
      location: location ?? this.location,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringFrequency: recurringFrequency ?? this.recurringFrequency,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}