import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/add_expense_bloc.dart';
import '../bloc/add_expense_event.dart';

/// Currency dropdown widget for selecting currency
class CurrencyDropdown extends StatelessWidget {
  final String selectedCurrency;
  final List<String> availableCurrencies;

  const CurrencyDropdown({
    super.key,
    required this.selectedCurrency,
    required this.availableCurrencies,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Currency',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: selectedCurrency,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down),
            items: availableCurrencies.map((currency) {
              return DropdownMenuItem(
                value: currency,
                child: Text(currency, style: AppTextStyles.bodyMedium),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<AddExpenseBloc>().add(CurrencySelected(value));
              }
            },
          ),
        ),
      ],
    );
  }
}
