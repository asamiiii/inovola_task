import 'package:equatable/equatable.dart';

/// Expense entity representing a single expense
class Expense extends Equatable {
  final String id;
  final String categoryId;
  final String categoryName;
  final double amount;
  final String currency;
  final double convertedAmount; // Amount in USD
  final DateTime date;
  final String? receiptPath;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.currency,
    required this.convertedAmount,
    required this.date,
    this.receiptPath,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    categoryId,
    categoryName,
    amount,
    currency,
    convertedAmount,
    date,
    receiptPath,
    createdAt,
  ];

  /// Copy with method for creating modified copies
  Expense copyWith({
    String? id,
    String? categoryId,
    String? categoryName,
    double? amount,
    String? currency,
    double? convertedAmount,
    DateTime? date,
    String? receiptPath,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      convertedAmount: convertedAmount ?? this.convertedAmount,
      date: date ?? this.date,
      receiptPath: receiptPath ?? this.receiptPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
