import 'package:hive_flutter/hive_flutter.dart';
import '../di/injection_container.dart' as di;
import '../../features/dashboard/data/models/expense_model.dart';
import '../../features/add_expense/data/models/category_model.dart';
import '../../features/add_expense/domain/repositories/category_repository.dart';

/// App initialization logic
class AppInitializer {
  AppInitializer._();

  /// Initialize the app
  static Future<void> initialize() async {
    await _initializeHive();
    await _initializeDependencies();
    await _initializeDefaultCategories();
  }

  /// Initialize Hive database
  static Future<void> _initializeHive() async {
    await Hive.initFlutter();

    // Register Hive adapters
    Hive.registerAdapter(ExpenseModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());

    // Open Hive boxes
    await Hive.openBox<ExpenseModel>('expenses');
    await Hive.openBox<CategoryModel>('categories');
  }

  /// Initialize dependency injection
  static Future<void> _initializeDependencies() async {
    await di.initializeDependencies();
  }

  /// Initialize default categories
  static Future<void> _initializeDefaultCategories() async {
    final categoryRepository = di.sl<CategoryRepository>();
    await categoryRepository.initializeDefaultCategories();
  }
}
