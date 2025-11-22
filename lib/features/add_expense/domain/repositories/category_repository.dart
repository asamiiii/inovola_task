import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/category.dart';

/// Repository interface for category operations
abstract class CategoryRepository {
  /// Get all categories
  Future<Either<Failure, List<Category>>> getCategories();

  /// Get category by ID
  Future<Either<Failure, Category>> getCategoryById(String id);

  /// Add a new category
  Future<Either<Failure, void>> addCategory(Category category);

  /// Initialize default categories
  Future<Either<Failure, void>> initializeDefaultCategories();
}
