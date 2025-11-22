import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../domain/usecases/get_categories.dart';
import '../bloc/add_expense_bloc.dart';
import '../bloc/add_expense_event.dart';

/// Category dropdown widget for selecting expense category
class CategoryDropdown extends StatelessWidget {
  final String? selectedCategoryName;

  const CategoryDropdown({super.key, this.selectedCategoryName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        FutureBuilder(
          future: di.sl<GetCategories>()(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }

            return snapshot.data!.fold(
              (failure) => Text('Error: ${failure.message}'),
              (categories) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedCategoryName,
                  hint: Text(
                    'Entertainment',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category.name,
                      child: Text(
                        category.name,
                        style: AppTextStyles.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      final selectedCat = categories.firstWhere(
                        (cat) => cat.name == value,
                      );
                      context.read<AddExpenseBloc>().add(
                        CategorySelected(selectedCat),
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
