import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_remote_datasource.dart';

/// Implementation of CurrencyRepository - fetches exchange rates from API
class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;

  CurrencyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ExchangeRate>> getExchangeRates() async {
    try {
      final exchangeRate = await remoteDataSource.getExchangeRates();
      return Right(exchangeRate);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    try {
      final exchangeRateResult = await getExchangeRates();

      return exchangeRateResult.fold((failure) => Left(failure), (
        exchangeRate,
      ) {
        final convertedAmount = exchangeRate.convert(
          amount,
          fromCurrency,
          toCurrency,
        );

        if (convertedAmount == null) {
          return Left(
            ValidationFailure(
              'Unable to convert from $fromCurrency to $toCurrency',
            ),
          );
        }

        return Right(convertedAmount);
      });
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
