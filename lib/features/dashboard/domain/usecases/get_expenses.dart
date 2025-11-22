import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

/// Use case for getting all expenses
class GetExpenses {
  final ExpenseRepository repository;

  GetExpenses(this.repository);

  Future<Either<Failure, List<Expense>>> call() async {
    return await repository.getExpenses();
  }
}
