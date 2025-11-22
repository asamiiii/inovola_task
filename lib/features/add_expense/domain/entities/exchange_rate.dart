import 'package:equatable/equatable.dart';

/// Exchange rate entity representing currency exchange rates
class ExchangeRate extends Equatable {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime lastUpdated;

  const ExchangeRate({
    required this.baseCurrency,
    required this.rates,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [baseCurrency, rates, lastUpdated];

  /// Get rate for a specific currency
  double? getRateFor(String currency) {
    return rates[currency.toUpperCase()];
  }

  /// Convert amount from one currency to another
  double? convert(double amount, String fromCurrency, String toCurrency) {
    final from = fromCurrency.toUpperCase();
    final to = toCurrency.toUpperCase();

    // If same currency, return amount
    if (from == to) return amount;

    // If converting from base currency
    if (from == baseCurrency) {
      final toRate = rates[to];
      if (toRate == null) return null;
      return amount * toRate;
    }

    // If converting to base currency
    if (to == baseCurrency) {
      final fromRate = rates[from];
      if (fromRate == null) return null;
      return amount / fromRate;
    }

    // Converting between two non-base currencies
    final fromRate = rates[from];
    final toRate = rates[to];

    if (fromRate == null || toRate == null) return null;

    // Convert to base currency first, then to target currency
    final inBaseCurrency = amount / fromRate;
    return inBaseCurrency * toRate;
  }

  /// Copy with method for creating modified copies
  ExchangeRate copyWith({
    String? baseCurrency,
    Map<String, double>? rates,
    DateTime? lastUpdated,
  }) {
    return ExchangeRate(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      rates: rates ?? this.rates,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
