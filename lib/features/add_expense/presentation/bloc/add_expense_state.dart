import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';

/// Base class for all add expense states
abstract class AddExpenseState extends Equatable {
  const AddExpenseState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AddExpenseInitial extends AddExpenseState {
  const AddExpenseInitial();
}

/// Form state with current values
class AddExpenseFormState extends AddExpenseState {
  final Category? selectedCategory;
  final String amount;
  final DateTime selectedDate;
  final String selectedCurrency;
  final String? receiptPath;
  final String? errorMessage;
  final List<String> availableCurrencies;

  const AddExpenseFormState({
    this.selectedCategory,
    this.amount = '',
    required this.selectedDate,
    this.selectedCurrency = 'USD',
    this.receiptPath,
    this.errorMessage,
    this.availableCurrencies = const ['USD'],
  });

  @override
  List<Object?> get props => [
    selectedCategory,
    amount,
    selectedDate,
    selectedCurrency,
    receiptPath,
    errorMessage,
    availableCurrencies,
  ];

  AddExpenseFormState copyWith({
    Category? selectedCategory,
    String? amount,
    DateTime? selectedDate,
    String? selectedCurrency,
    String? receiptPath,
    String? errorMessage,
    List<String>? availableCurrencies,
    bool clearError = false,
  }) {
    return AddExpenseFormState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      amount: amount ?? this.amount,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      receiptPath: receiptPath ?? this.receiptPath,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      availableCurrencies: availableCurrencies ?? this.availableCurrencies,
    );
  }

  bool get isValid {
    return selectedCategory != null &&
        amount.isNotEmpty &&
        double.tryParse(amount) != null &&
        double.parse(amount) > 0;
  }
}

/// Loading state (saving expense)
class AddExpenseLoading extends AddExpenseState {
  const AddExpenseLoading();
}

/// Success state
class AddExpenseSuccess extends AddExpenseState {
  const AddExpenseSuccess();
}

/// Error state
class AddExpenseError extends AddExpenseState {
  final String message;

  const AddExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}
