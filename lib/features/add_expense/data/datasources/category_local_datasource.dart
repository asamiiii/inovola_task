import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/category_model.dart';

/// Local data source for category operations using Hive
class CategoryLocalDataSource {
  final Box<CategoryModel> _categoryBox;

  CategoryLocalDataSource(this._categoryBox);

  /// Get all categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      return _categoryBox.values.toList();
    } catch (e) {
      throw CacheException('Failed to get categories: $e');
    }
  }

  /// Get category by ID
  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final category = _categoryBox.get(id);
      if (category == null) {
        throw NotFoundException('Category with id $id not found');
      }
      return category;
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw CacheException('Failed to get category: $e');
    }
  }

  /// Add a new category
  Future<void> addCategory(CategoryModel category) async {
    try {
      await _categoryBox.put(category.id, category);
    } catch (e) {
      throw CacheException('Failed to add category: $e');
    }
  }

  /// Initialize default categories
  Future<void> initializeDefaultCategories() async {
    try {
      // Only initialize if box is empty
      if (_categoryBox.isEmpty) {
        for (final categoryData in AppConstants.defaultCategories) {
          final category = CategoryModel(
            id: categoryData['id'] as String,
            name: categoryData['name'] as String,
            iconName: categoryData['iconName'] as String,
            colorValue: categoryData['colorValue'] as int,
          );
          await _categoryBox.put(category.id, category);
        }
      }
    } catch (e) {
      throw CacheException('Failed to initialize default categories: $e');
    }
  }
}
