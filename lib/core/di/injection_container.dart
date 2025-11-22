import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import '../network/api_client.dart';

// Data sources
import '../../features/dashboard/data/datasources/expense_local_datasource.dart';
import '../../features/add_expense/data/datasources/category_local_datasource.dart';
import '../../features/add_expense/data/datasources/currency_remote_datasource.dart';

// Repositories
import '../../features/dashboard/data/repositories/expense_repository_impl.dart';
import '../../features/dashboard/domain/repositories/expense_repository.dart';
import '../../features/add_expense/data/repositories/category_repository_impl.dart';
import '../../features/add_expense/domain/repositories/category_repository.dart';
import '../../features/add_expense/data/repositories/currency_repository_impl.dart';
import '../../features/add_expense/domain/repositories/currency_repository.dart';

// Use cases
import '../../features/dashboard/domain/usecases/get_expenses.dart';
import '../../features/dashboard/domain/usecases/get_filtered_expenses.dart';
import '../../features/dashboard/domain/usecases/calculate_summary.dart';
import '../../features/add_expense/domain/usecases/add_expense.dart';
import '../../features/add_expense/domain/usecases/get_categories.dart';
import '../../features/add_expense/domain/usecases/convert_currency.dart';

// BLoCs
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/add_expense/presentation/bloc/add_expense_bloc.dart';

// Models
import '../../features/dashboard/data/models/expense_model.dart';
import '../../features/add_expense/data/models/category_model.dart';

final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> initializeDependencies() async {
  // ============ Core ============

  // API Client
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Hive Boxes
  sl.registerLazySingleton<Box<ExpenseModel>>(
    () => Hive.box<ExpenseModel>('expenses'),
  );
  sl.registerLazySingleton<Box<CategoryModel>>(
    () => Hive.box<CategoryModel>('categories'),
  );

  // ============ Data Sources ============

  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSource(sl()),
  );
  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSource(sl()),
  );
  sl.registerLazySingleton<CurrencyRemoteDataSource>(
    () => CurrencyRemoteDataSource(sl()),
  );

  // ============ Repositories ============

  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(remoteDataSource: sl()),
  );

  // ============ Use Cases ============

  // Dashboard use cases
  sl.registerLazySingleton(() => GetExpenses(sl()));
  sl.registerLazySingleton(() => GetFilteredExpenses(sl()));
  sl.registerLazySingleton(() => CalculateSummary(sl()));

  // Add expense use cases
  sl.registerLazySingleton(() => AddExpense(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));

  // Currency use cases (in add_expense feature)
  sl.registerLazySingleton(() => ConvertCurrency(sl()));

  // ============ BLoCs ============

  sl.registerFactory(
    () => DashboardBloc(
      getExpenses: sl(),
      getFilteredExpenses: sl(),
      calculateSummary: sl(),
    ),
  );

  sl.registerFactory(
    () => AddExpenseBloc(addExpense: sl(), convertCurrency: sl()),
  );
}
