import 'package:hive/hive.dart';
import '../../domain/entities/expense.dart';

part 'expense_model.g.dart';

/// Expense model for Hive storage
@HiveType(typeId: 0)
class ExpenseModel extends Expense {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String categoryId;

  @HiveField(2)
  @override
  final String categoryName;

  @HiveField(3)
  @override
  final double amount;

  @HiveField(4)
  @override
  final String currency;

  @HiveField(5)
  @override
  final double convertedAmount;

  @HiveField(6)
  @override
  final DateTime date;

  @HiveField(7)
  @override
  final String? receiptPath;

  @HiveField(8)
  @override
  final DateTime createdAt;

  const ExpenseModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.currency,
    required this.convertedAmount,
    required this.date,
    this.receiptPath,
    required this.createdAt,
  }) : super(
         id: id,
         categoryId: categoryId,
         categoryName: categoryName,
         amount: amount,
         currency: currency,
         convertedAmount: convertedAmount,
         date: date,
         receiptPath: receiptPath,
         createdAt: createdAt,
       );

  /// Create from entity
  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      categoryId: expense.categoryId,
      categoryName: expense.categoryName,
      amount: expense.amount,
      currency: expense.currency,
      convertedAmount: expense.convertedAmount,
      date: expense.date,
      receiptPath: expense.receiptPath,
      createdAt: expense.createdAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'amount': amount,
      'currency': currency,
      'convertedAmount': convertedAmount,
      'date': date.toIso8601String(),
      'receiptPath': receiptPath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      convertedAmount: (json['convertedAmount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      receiptPath: json['receiptPath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
