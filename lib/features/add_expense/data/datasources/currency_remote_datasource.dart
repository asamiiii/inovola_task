import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/exchange_rate.dart';

/// Remote data source for fetching exchange rates from API
class CurrencyRemoteDataSource {
  final ApiClient apiClient;

  CurrencyRemoteDataSource(this.apiClient);

  /// Fetch latest exchange rates from API
  Future<ExchangeRate> getExchangeRates() async {
    try {
      final response = await apiClient.get('/USD');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        return ExchangeRate(
          baseCurrency: data['base_code'] as String,
          rates: Map<String, double>.from(
            (data['rates'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, (value as num).toDouble()),
            ),
          ),
          lastUpdated: DateTime.now(),
        );
      } else {
        throw ServerException('Failed to fetch exchange rates');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}
