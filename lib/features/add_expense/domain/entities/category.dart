import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// Category entity representing an expense category
class Category extends Equatable {
  final String id;
  final String name;
  final String iconName;
  final Color color;

  const Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.color,
  });

  @override
  List<Object?> get props => [id, name, iconName, color];

  /// Copy with method for creating modified copies
  Category copyWith({
    String? id,
    String? name,
    String? iconName,
    Color? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
    );
  }
}
