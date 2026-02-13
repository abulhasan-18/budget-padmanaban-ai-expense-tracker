class Expense {
  final String id;
  final String userId;
  final double amount;
  final DateTime date;
  final String category;
  final String paymentMethod;
  final String? notes;
  final String? receiptUrl;
  final String? merchant;
  final bool isRecurring;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.date,
    required this.category,
    required this.paymentMethod,
    this.notes,
    this.receiptUrl,
    this.merchant,
    this.isRecurring = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
      paymentMethod: json['payment_method'] as String,
      notes: json['notes'] as String?,
      receiptUrl: json['receipt_url'] as String?,
      merchant: json['merchant'] as String?,
      isRecurring: json['is_recurring'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'payment_method': paymentMethod,
      'notes': notes,
      'receipt_url': receiptUrl,
      'merchant': merchant,
      'is_recurring': isRecurring,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Expense copyWith({
    String? id,
    String? userId,
    double? amount,
    DateTime? date,
    String? category,
    String? paymentMethod,
    String? notes,
    String? receiptUrl,
    String? merchant,
    bool? isRecurring,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      merchant: merchant ?? this.merchant,
      isRecurring: isRecurring ?? this.isRecurring,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
