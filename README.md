# Expense Tracker Lite

A lightweight, offline-first expense tracking mobile application built with Flutter, following Clean Architecture principles and the BLoC pattern for state management.

## Features

- ✅ **Expense Management**: Add, view, and track expenses with categories
- ✅ **Currency Conversion**: Automatic conversion to USD using live exchange rates
- ✅ **Offline-First**: All data stored locally using Hive
- ✅ **Pagination**: Infinite scroll for expense lists
- ✅ **Filtering**: Filter expenses by time period (This Month, Last 7 Days, All Time)
- ✅ **Receipt Upload**: Attach receipt images to expenses
- ✅ **Dashboard**: View total balance, income, and expenses at a glance

## Architecture

This project follows **Clean Architecture** with a **feature-based structure**:

```
lib/
├── core/                    # Core utilities and infrastructure
│   ├── constants/          # App colors, text styles, constants
│   ├── di/                 # Dependency injection setup
│   ├── error/              # Error handling (failures & exceptions)
│   ├── network/            # API client
│   └── utils/              # Utility classes (formatters)
├── features/               # Feature modules
│   ├── dashboard/         # Dashboard feature
│   │   ├── data/          # Data layer (models, datasources, repositories)
│   │   ├── domain/        # Domain layer (entities, repositories, use cases)
│   │   └── presentation/  # Presentation layer (BLoC, screens, widgets)
│   ├── add_expense/       # Add expense feature
│   └── currency/          # Currency conversion feature
└── main.dart              # App entry point
```

### Key Architectural Decisions

1. **Clean Architecture**: Separation of concerns with distinct layers (data, domain, presentation)
2. **BLoC Pattern**: State management using `flutter_bloc`
3. **Repository Pattern**: Abstract repositories in domain, concrete implementations in data layer
4. **Dependency Injection**: Using `get_it` for managing dependencies
5. **Offline-First**: Hive for local storage, API calls only for currency rates
6. **Error Handling**: Using `dartz` for functional error handling with `Either<Failure, Success>`

## Tech Stack

- **Flutter SDK**: 3.6.0+
- **State Management**: `flutter_bloc` ^8.1.3
- **Local Storage**: `hive` ^2.2.3, `hive_flutter` ^1.1.0
- **Network**: `dio` ^5.4.0
- **Dependency Injection**: `get_it` ^7.6.4
- **Functional Programming**: `dartz` ^0.10.1
- **Code Generation**: `hive_generator`, `build_runner`

## Setup Instructions

### Prerequisites

- Flutter SDK (3.6.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd inovola_task
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

### Core Layer

- **constants/**: Application-wide constants
  - `app_colors.dart`: Color palette
  - `app_text_styles.dart`: Typography styles
  - `app_constants.dart`: API URLs, pagination settings, default categories

- **di/**: Dependency injection
  - `injection_container.dart`: GetIt service locator setup

- **error/**: Error handling
  - `failures.dart`: Domain-level error representations
  - `exceptions.dart`: Data-level exceptions

- **network/**: Network infrastructure
  - `api_client.dart`: Dio-based HTTP client

- **utils/**: Utility classes
  - `date_formatter.dart`: Date formatting and calculations
  - `currency_formatter.dart`: Currency formatting

### Feature Modules

Each feature follows the same structure:

#### Dashboard Feature
- **Domain Layer**
  - Entities: `Expense`
  - Repositories: `ExpenseRepository` (abstract)
  - Use Cases: `GetExpenses`, `GetFilteredExpenses`, `CalculateSummary`

- **Data Layer**
  - Models: `ExpenseModel` (Hive model)
  - Data Sources: `ExpenseLocalDataSource`
  - Repositories: `ExpenseRepositoryImpl`

- **Presentation Layer**
  - BLoC: `DashboardBloc`, `DashboardEvent`, `DashboardState`
  - Screens: `DashboardScreen`
  - Widgets: `BalanceCardWidget`, `ExpenseListWidget`

#### Add Expense Feature
- **Domain Layer**
  - Entities: `Category`
  - Repositories: `CategoryRepository`
  - Use Cases: `AddExpense`, `GetCategories`

- **Data Layer**
  - Models: `CategoryModel`
  - Data Sources: `CategoryLocalDataSource`
  - Repositories: `CategoryRepositoryImpl`

- **Presentation Layer**
  - BLoC: `AddExpenseBloc`, `AddExpenseEvent`, `AddExpenseState`
  - Screens: `AddExpenseScreen`

#### Currency Feature
- **Domain Layer**
  - Entities: `ExchangeRate`
  - Repositories: `CurrencyRepository`
  - Use Cases: `ConvertCurrency`, `GetExchangeRate`

- **Data Layer**
  - Models: `ExchangeRateModel`
  - Data Sources: `CurrencyRemoteDataSource`, `CurrencyLocalDataSource`
  - Repositories: `CurrencyRepositoryImpl`

## Key Features Implementation

### Currency Conversion
- Uses [open.er-api.com](https://open.er-api.com) for exchange rates
- Caches rates locally for 24 hours
- Offline-first: uses cached rates when available
- Supports multiple currencies: USD, EUR, GBP, EGP, SAR, AED, JPY, CNY, INR

### Pagination
- Implements infinite scroll with `itemsPerPage = 10`
- Loads more expenses when scrolling near bottom (90% threshold)
- Shows loading indicator while fetching more data

### Filtering
- **This Month**: Shows expenses from start of current month
- **Last 7 Days**: Shows expenses from last 7 days
- **All Time**: Shows all expenses

### Local Storage
- Uses Hive for fast, lightweight local storage
- Three Hive boxes:
  - `expenses`: Stores all expense records
  - `categories`: Stores expense categories
  - `exchange_rates`: Caches currency exchange rates

## Default Categories

The app comes with 6 pre-configured categories:
1. **Groceries** (Purple)
2. **Entertainment** (Pink)
3. **Gas** (Orange)
4. **Shopping** (Blue)
5. **Transport** (Green)
6. **Rent** (Red)

## Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Test Structure
- Unit tests for BLoCs
- Unit tests for use cases
- Unit tests for repositories
- Widget tests for key screens

## Known Limitations

1. **Currency API**: Free tier has rate limits
2. **Receipt Storage**: Images stored locally only
3. **Categories**: Fixed set of categories (no custom categories yet)
4. **Export**: No data export functionality yet

## Future Enhancements

- [ ] Custom category creation
- [ ] Data export (CSV/PDF)
- [ ] Budget tracking
- [ ] Expense analytics and charts
- [ ] Cloud backup
- [ ] Multi-user support

## License

This project is for educational purposes.

## Contact

For questions or support, please contact the development team.
