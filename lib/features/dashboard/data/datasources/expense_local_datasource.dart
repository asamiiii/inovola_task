import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/expense_model.dart';

/// Local data source for expense operations using Hive
class ExpenseLocalDataSource {
  final Box<ExpenseModel> _expenseBox;

  ExpenseLocalDataSource(this._expenseBox);

  /// Get all expenses
  Future<List<ExpenseModel>> getExpenses() async {
    try {
      return _expenseBox.values.toList()
        ..sort((a, b) => b.date.compareTo(a.date)); // Sort by date descending
    } catch (e) {
      throw CacheException('Failed to get expenses: $e');
    }
  }

  /// Get paginated expenses
  Future<List<ExpenseModel>> getExpensesPaginated({
    required int page,
    required int limit,
  }) async {
    try {
      final allExpenses = await getExpenses();
      final startIndex = page * limit;
      final endIndex = startIndex + limit;

      if (startIndex >= allExpenses.length) {
        return [];
      }

      return allExpenses.sublist(
        startIndex,
        endIndex > allExpenses.length ? allExpenses.length : endIndex,
      );
    } catch (e) {
      throw CacheException('Failed to get paginated expenses: $e');
    }
  }

  /// Get filtered expenses by date range
  Future<List<ExpenseModel>> getFilteredExpenses({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final allExpenses = await getExpenses();

      if (startDate == null && endDate == null) {
        return allExpenses;
      }

      return allExpenses.where((expense) {
        if (startDate != null && expense.date.isBefore(startDate)) {
          return false;
        }
        if (endDate != null && expense.date.isAfter(endDate)) {
          return false;
        }
        return true;
      }).toList();
    } catch (e) {
      throw CacheException('Failed to get filtered expenses: $e');
    }
  }

  /// Add a new expense
  Future<void> addExpense(ExpenseModel expense) async {
    try {
      await _expenseBox.put(expense.id, expense);
    } catch (e) {
      throw CacheException('Failed to add expense: $e');
    }
  }

  /// Delete an expense
  Future<void> deleteExpense(String id) async {
    try {
      await _expenseBox.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete expense: $e');
    }
  }

  /// Get total balance (for this app, we'll treat all as expenses)
  Future<double> getTotalBalance() async {
    try {
      final expenses = await getExpenses();
      final totalExpenses = expenses.fold<double>(
        0,
        (sum, expense) => sum + expense.convertedAmount,
      );
      // For this app, balance is negative of expenses
      return -totalExpenses;
    } catch (e) {
      throw CacheException('Failed to calculate total balance: $e');
    }
  }

  /// Get total income (placeholder - returns 0 for now)
  Future<double> getTotalIncome() async {
    try {
      // In a real app, you'd filter by income category
      return 0.0;
    } catch (e) {
      throw CacheException('Failed to calculate total income: $e');
    }
  }

  /// Get total expenses
  Future<double> getTotalExpenses() async {
    try {
      final expenses = await getExpenses();
      return expenses.fold<double>(
        0,
        (sum, expense) => sum + expense.convertedAmount,
      );
    } catch (e) {
      throw CacheException('Failed to calculate total expenses: $e');
    }
  }
}
