import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

/// Use case for getting filtered expenses by date range
class GetFilteredExpenses {
  final ExpenseRepository repository;

  GetFilteredExpenses(this.repository);

  Future<Either<Failure, List<Expense>>> call({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.getFilteredExpenses(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
