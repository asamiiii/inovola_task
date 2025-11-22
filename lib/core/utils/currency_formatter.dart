import 'package:intl/intl.dart';

/// Utility class for currency formatting
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format amount with currency symbol
  static String format(double amount, String currencyCode) {
    final formatter = NumberFormat.currency(
      symbol: currencyCode,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Format amount without currency symbol
  static String formatWithoutSymbol(double amount) {
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 2);
    return formatter.format(amount).trim();
  }
}
