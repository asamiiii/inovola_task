import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inovola_task/core/shared/widgets/custom_button.dart';
import 'package:inovola_task/core/shared/widgets/custom_text_field.dart';
import 'package:inovola_task/core/shared/widgets/loading_indicator.dart';
import '../bloc/add_expense_bloc.dart';
import '../bloc/add_expense_event.dart';
import '../bloc/add_expense_state.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/category_grid.dart';
import '../widgets/currency_dropdown.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/receipt_upload_field.dart';

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
  void initState() {
    super.initState();
    // Load currencies when screen opens
    context.read<AddExpenseBloc>().add(const LoadCurrencies());
  }

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
                // Category Dropdown at Top
                CategoryDropdown(
                  selectedCategoryName: formState.selectedCategory?.name,
                ),
                const SizedBox(height: 20),

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

                // Currency Dropdown
                CurrencyDropdown(
                  selectedCurrency: formState.selectedCurrency,
                  availableCurrencies: formState.availableCurrencies,
                ),
                const SizedBox(height: 20),

                // Date Picker
                DatePickerField(selectedDate: formState.selectedDate),
                const SizedBox(height: 20),

                // Receipt Upload
                ReceiptUploadField(
                  receiptPath: formState.receiptPath,
                  onTap: _pickImage,
                ),
                const SizedBox(height: 32),

                // Categories Grid at Bottom
                CategoryGrid(selectedCategory: formState.selectedCategory),
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
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
