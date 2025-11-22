import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../dashboard/domain/entities/expense.dart';
import '../../../dashboard/domain/repositories/expense_repository.dart';

/// Use case for adding a new expense
class AddExpense {
  final ExpenseRepository repository;

  AddExpense(this.repository);

  Future<Either<Failure, void>> call(Expense expense) async {
    return await repository.addExpense(expense);
  }
}
