import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/features/add_expense/domain/usecases/convert_currency.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../dashboard/domain/entities/expense.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../domain/usecases/add_expense.dart';
import 'add_expense_event.dart';
import 'add_expense_state.dart';

/// BLoC for add expense feature
class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final AddExpense addExpense;
  final ConvertCurrency convertCurrency;
  final CurrencyRepository currencyRepository;

  AddExpenseBloc({
    required this.addExpense,
    required this.convertCurrency,
    required this.currencyRepository,
  }) : super(AddExpenseFormState(selectedDate: DateTime.now())) {
    on<LoadCurrencies>(_onLoadCurrencies);
    on<CategorySelected>(_onCategorySelected);
    on<AmountChanged>(_onAmountChanged);
    on<DateSelected>(_onDateSelected);
    on<CurrencySelected>(_onCurrencySelected);
    on<ReceiptUploaded>(_onReceiptUploaded);
    on<SaveExpense>(_onSaveExpense);
    on<ResetForm>(_onResetForm);
  }

  Future<void> _onLoadCurrencies(
    LoadCurrencies event,
    Emitter<AddExpenseState> emit,
  ) async {
    if (state is! AddExpenseFormState) return;

    final currentState = state as AddExpenseFormState;

    // Fetch exchange rates
    final result = await currencyRepository.getExchangeRates();

    result.fold(
      (failure) {
        // If failed, keep default USD
        // User can still use the app with USD
      },
      (exchangeRate) {
        // Extract currency codes from rates map
        final currencies = exchangeRate.rates.keys.toList()..sort();
        emit(currentState.copyWith(availableCurrencies: currencies));
      },
    );
  }

  void _onCategorySelected(
    CategorySelected event,
    Emitter<AddExpenseState> emit,
  ) {
    if (state is AddExpenseFormState) {
      final currentState = state as AddExpenseFormState;
      emit(
        currentState.copyWith(
          selectedCategory: event.category,
          clearError: true,
        ),
      );
    }
  }

  void _onAmountChanged(AmountChanged event, Emitter<AddExpenseState> emit) {
    if (state is AddExpenseFormState) {
      final currentState = state as AddExpenseFormState;
      emit(currentState.copyWith(amount: event.amount, clearError: true));
    }
  }

  void _onDateSelected(DateSelected event, Emitter<AddExpenseState> emit) {
    if (state is AddExpenseFormState) {
      final currentState = state as AddExpenseFormState;
      emit(currentState.copyWith(selectedDate: event.date, clearError: true));
    }
  }

  void _onCurrencySelected(
    CurrencySelected event,
    Emitter<AddExpenseState> emit,
  ) {
    if (state is AddExpenseFormState) {
      final currentState = state as AddExpenseFormState;
      emit(
        currentState.copyWith(
          selectedCurrency: event.currency,
          clearError: true,
        ),
      );
    }
  }

  void _onReceiptUploaded(
    ReceiptUploaded event,
    Emitter<AddExpenseState> emit,
  ) {
    if (state is AddExpenseFormState) {
      final currentState = state as AddExpenseFormState;
      emit(
        currentState.copyWith(receiptPath: event.receiptPath, clearError: true),
      );
    }
  }

  Future<void> _onSaveExpense(
    SaveExpense event,
    Emitter<AddExpenseState> emit,
  ) async {
    if (state is! AddExpenseFormState) return;

    final formState = state as AddExpenseFormState;

    // Validate
    if (!formState.isValid) {
      emit(formState.copyWith(errorMessage: 'Please fill all required fields'));
      return;
    }

    emit(const AddExpenseLoading());

    // Convert currency to USD
    final amount = double.parse(formState.amount);
    final conversionResult = await convertCurrency(
      amount: amount,
      fromCurrency: formState.selectedCurrency,
      toCurrency: AppConstants.baseCurrency,
    );

    await conversionResult.fold(
      (failure) async {
        emit(AddExpenseError(failure.message));
        // Return to form state
        emit(formState);
      },
      (convertedAmount) async {
        // Create expense
        final expense = Expense(
          id: const Uuid().v4(),
          categoryId: formState.selectedCategory!.id,
          categoryName: formState.selectedCategory!.name,
          amount: amount,
          currency: formState.selectedCurrency,
          convertedAmount: convertedAmount,
          date: formState.selectedDate,
          receiptPath: formState.receiptPath,
          createdAt: DateTime.now(),
        );

        // Save expense
        final result = await addExpense(expense);

        result.fold(
          (failure) {
            emit(AddExpenseError(failure.message));
            // Return to form state
            emit(formState);
          },
          (_) {
            emit(const AddExpenseSuccess());
          },
        );
      },
    );
  }

  void _onResetForm(ResetForm event, Emitter<AddExpenseState> emit) {
    emit(AddExpenseFormState(selectedDate: DateTime.now()));
  }
}
