import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/currency_repository.dart';

/// Use case for converting currency
class ConvertCurrency {
  final CurrencyRepository repository;

  ConvertCurrency(this.repository);

  Future<Either<Failure, double>> call({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    return await repository.convertCurrency(
      amount: amount,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );
  }
}
