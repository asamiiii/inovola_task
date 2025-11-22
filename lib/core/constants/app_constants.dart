/// App-wide constants
class AppConstants {
  AppConstants._();

  // Pagination
  static const int itemsPerPage = 10;

  // API
  static const String exchangeRateApiBaseUrl =
      'https://open.er-api.com/v6/latest';
  static const String baseCurrency = 'USD';
  static const int apiTimeoutSeconds = 30;

  // Cache
  static const int exchangeRateCacheHours = 24;

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Filter Options
  static const String filterThisMonth = 'This Month';
  static const String filterLast7Days = 'Last 7 Days';
  static const String filterAllTime = 'All Time';

  // Hive Box Names
  static const String expensesBoxName = 'expenses';
  static const String exchangeRatesBoxName = 'exchange_rates';
  static const String categoriesBoxName = 'categories';

  // Hive Type IDs
  static const int expenseTypeId = 0;
  static const int exchangeRateTypeId = 1;
  static const int categoryTypeId = 2;

  // Supported Currencies
  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'EGP',
    'SAR',
    'AED',
    'JPY',
    'CNY',
    'INR',
  ];

  // Default Categories
  static const List<Map<String, dynamic>> defaultCategories = [
    {
      'id': 'groceries',
      'name': 'Groceries',
      'iconName': 'shopping_cart',
      'colorValue': 0xFF6C63FF,
    },
    {
      'id': 'entertainment',
      'name': 'Entertainment',
      'iconName': 'movie',
      'colorValue': 0xFF2F6FED,
    },
    {
      'id': 'gas',
      'name': 'Gas',
      'iconName': 'local_gas_station',
      'colorValue': 0xFFFF6B9D,
    },
    {
      'id': 'shopping',
      'name': 'Shopping',
      'iconName': 'shopping_bag',
      'colorValue': 0xFFFFC542,
    },
    {
      'id': 'transport',
      'name': 'Transport',
      'iconName': 'directions_car',
      'colorValue': 0xFFB4A5FF,
    },
    {
      'id': 'rent',
      'name': 'Rent',
      'iconName': 'home',
      'colorValue': 0xFFFFB74D,
    },
  ];

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // Icon Sizes
  static const double iconSizeS = 20.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;

  // UI Behavior
  static const double scrollThresholdForPagination = 0.85;
  static const int paginationDelayMs = 800;
  static const int loadingFlagResetDelaySeconds = 5;
}
