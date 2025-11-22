import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense.dart';

/// Repository interface for expense operations
abstract class ExpenseRepository {
  /// Get all expenses
  Future<Either<Failure, List<Expense>>> getExpenses();

  /// Get paginated expenses
  Future<Either<Failure, List<Expense>>> getExpensesPaginated({
    required int page,
    required int limit,
  });

  /// Get filtered expenses by date range
  Future<Either<Failure, List<Expense>>> getFilteredExpenses({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Add a new expense
  Future<Either<Failure, void>> addExpense(Expense expense);

  /// Delete an expense
  Future<Either<Failure, void>> deleteExpense(String id);

  /// Get total balance (income - expenses)
  Future<Either<Failure, double>> getTotalBalance();

  /// Get total income
  Future<Either<Failure, double>> getTotalIncome();

  /// Get total expenses
  Future<Either<Failure, double>> getTotalExpenses();
}
