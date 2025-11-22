import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/category.dart';

part 'category_model.g.dart';

/// Category model for Hive storage
@HiveType(typeId: 2)
class CategoryModel extends Category {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String iconName;

  @HiveField(3)
  final int colorValue;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorValue,
  }) : super(id: id, name: name, iconName: iconName, color: Color(colorValue));

  /// Create from entity
  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      iconName: category.iconName,
      colorValue: category.color.value,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'colorValue': colorValue,
    };
  }

  /// Create from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String,
      colorValue: json['colorValue'] as int,
    );
  }
}
