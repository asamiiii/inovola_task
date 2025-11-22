import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/expense_repository.dart';

/// Summary data for dashboard
class ExpenseSummary extends Equatable {
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;

  const ExpenseSummary({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
  });

  @override
  List<Object?> get props => [totalBalance, totalIncome, totalExpenses];
}

/// Use case for calculating expense summary
class CalculateSummary {
  final ExpenseRepository repository;

  CalculateSummary(this.repository);

  Future<Either<Failure, ExpenseSummary>> call() async {
    try {
      final balanceResult = await repository.getTotalBalance();
      final incomeResult = await repository.getTotalIncome();
      final expensesResult = await repository.getTotalExpenses();

      return balanceResult.fold(
        (failure) => Left(failure),
        (balance) => incomeResult.fold(
          (failure) => Left(failure),
          (income) => expensesResult.fold(
            (failure) => Left(failure),
            (expenses) => Right(
              ExpenseSummary(
                totalBalance: balance,
                totalIncome: income,
                totalExpenses: expenses,
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      return Left(CacheFailure('Failed to calculate summary: $e'));
    }
  }
}
