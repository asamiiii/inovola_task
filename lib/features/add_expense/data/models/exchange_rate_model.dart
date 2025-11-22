import 'package:inovola_task/features/add_expense/domain/entities/exchange_rate.dart';

/// Exchange rate model for Hive storage
class ExchangeRateModel extends ExchangeRate {
  final String baseCurrency;

  final Map<String, double> rates;

  final DateTime lastUpdated;

  const ExchangeRateModel({
    required this.baseCurrency,
    required this.rates,
    required this.lastUpdated,
  }) : super(
         baseCurrency: baseCurrency,
         rates: rates,
         lastUpdated: lastUpdated,
       );

  /// Create from entity
  factory ExchangeRateModel.fromEntity(ExchangeRate exchangeRate) {
    return ExchangeRateModel(
      baseCurrency: exchangeRate.baseCurrency,
      rates: exchangeRate.rates,
      lastUpdated: exchangeRate.lastUpdated,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'baseCurrency': baseCurrency,
      'rates': rates,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Create from JSON
  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      baseCurrency: json['baseCurrency'] as String,
      rates: Map<String, double>.from(json['rates'] as Map),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}
