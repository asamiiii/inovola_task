import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inovola_task/core/shared/widgets/custom_button.dart';
import 'package:inovola_task/core/shared/widgets/custom_text_field.dart';
import 'package:inovola_task/core/shared/widgets/loading_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../add_expense/domain/usecases/get_categories.dart';
import '../bloc/add_expense_bloc.dart';
import '../bloc/add_expense_event.dart';
import '../bloc/add_expense_state.dart';

/// Screen for adding a new expense
class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null && mounted) {
        context.read<AddExpenseBloc>().add(ReceiptUploaded(image.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Expense',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AddExpenseBloc, AddExpenseState>(
        listener: (context, state) {
          if (state is AddExpenseSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Expense added successfully')),
            );
          } else if (state is AddExpenseError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AddExpenseLoading) {
            return const LoadingIndicator();
          }

          final formState = state is AddExpenseFormState
              ? state
              : AddExpenseFormState(selectedDate: DateTime.now());

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categories Section at Top
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                        itemCount: categories.length + 1,
                        itemBuilder: (context, index) {
                          if (index == categories.length) {
                            // Add Category button
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
                                  child: const Icon(
                                    Icons.add,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Add Category',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          }

                          final category = categories[index];
                          final isSelected =
                              formState.selectedCategory?.id == category.id;

                          return GestureDetector(
                            onTap: () {
                              context.read<AddExpenseBloc>().add(
                                CategorySelected(category),
                              );
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
                                    color: isSelected
                                        ? Colors.white
                                        : category.color,
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
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Amount Input
                CustomTextField(
                  label: 'Amount',
                  hint: '\$2,000',
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                  onChanged: (value) {
                    context.read<AddExpenseBloc>().add(AmountChanged(value));
                  },
                ),
                const SizedBox(height: 20),

                // Date Picker
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: formState.selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null && mounted) {
                      context.read<AddExpenseBloc>().add(DateSelected(date));
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${formState.selectedDate.day.toString().padLeft(2, '0')}/${formState.selectedDate.month.toString().padLeft(2, '0')}/${formState.selectedDate.year}',
                              style: AppTextStyles.bodyMedium,
                            ),
                            const Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Receipt Upload
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attach Receipt',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formState.receiptPath != null
                                  ? 'Receipt attached'
                                  : 'Upload Image',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: formState.receiptPath != null
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            Icon(
                              formState.receiptPath != null
                                  ? Icons.check_circle
                                  : Icons.camera_alt,
                              color: formState.receiptPath != null
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Save Button
                CustomButton(
                  text: 'Save',
                  onPressed: formState.isValid
                      ? () {
                          context.read<AddExpenseBloc>().add(
                            const SaveExpense(),
                          );
                        }
                      : null,
                ),
              ],
            ),
          );
        },
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
