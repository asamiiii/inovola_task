import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../domain/entities/category.dart';
import '../../domain/usecases/get_categories.dart';
import '../bloc/add_expense_bloc.dart';
import '../bloc/add_expense_event.dart';

/// Category grid widget for visual category selection
class CategoryGrid extends StatelessWidget {
  final Category? selectedCategory;

  const CategoryGrid({super.key, this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        FutureBuilder(
          future: di.sl<GetCategories>()(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return snapshot.data!.fold(
              (failure) => Text('Error: ${failure.message}'),
              (categories) => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == categories.length) {
                    // Add Category button
                    return _buildAddCategoryButton();
                  }

                  final category = categories[index];
                  final isSelected = selectedCategory?.id == category.id;

                  return _buildCategoryItem(context, category, isSelected);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAddCategoryButton() {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.border,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: const Icon(Icons.add, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        const Text(
          'Add Category',
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    Category category,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<AddExpenseBloc>().add(CategorySelected(category));
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected
                  ? category.color
                  : category.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getCategoryIcon(category.iconName),
              color: isSelected ? Colors.white : category.color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: TextStyle(
              fontSize: 11,
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'shopping_cart':
      case 'groceries':
        return Icons.shopping_cart;
      case 'movie':
      case 'entertainment':
        return Icons.movie;
      case 'local_gas_station':
      case 'gas':
        return Icons.local_gas_station;
      case 'shopping_bag':
      case 'shopping':
        return Icons.shopping_bag;
      case 'directions_car':
      case 'transport':
        return Icons.directions_car;
      case 'home':
      case 'rent':
        return Icons.home;
      default:
        return Icons.category;
    }
  }
}
