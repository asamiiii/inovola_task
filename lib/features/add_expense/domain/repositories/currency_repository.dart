import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/exchange_rate.dart';

/// Repository interface for currency operations
abstract class CurrencyRepository {
  /// Get exchange rates from API
  Future<Either<Failure, ExchangeRate>> getExchangeRates();

  /// Convert currency amount
  Future<Either<Failure, double>> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  });
}
