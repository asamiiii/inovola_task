import 'package:intl/intl.dart';

/// Utility class for currency formatting
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format amount with currency symbol
  static String format(double amount, String currencyCode) {
    final formatter = NumberFormat.currency(
      symbol: _getCurrencySymbol(currencyCode),
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Format amount without currency symbol
  static String formatWithoutSymbol(double amount) {
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 2);
    return formatter.format(amount).trim();
  }

  /// Get currency symbol for currency code
  static String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'EGP':
        return 'E£';
      case 'SAR':
        return 'SR';
      case 'AED':
        return 'AED';
      case 'JPY':
        return '¥';
      case 'CNY':
        return '¥';
      case 'INR':
        return '₹';
      default:
        return currencyCode;
    }
  }

  /// Get currency symbol only
  static String getSymbol(String currencyCode) {
    return _getCurrencySymbol(currencyCode);
  }
}
