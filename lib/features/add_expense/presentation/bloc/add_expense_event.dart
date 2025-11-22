import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';

/// Base class for all add expense events
abstract class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load available currencies
class LoadCurrencies extends AddExpenseEvent {
  const LoadCurrencies();
}

/// Event when category is selected
class CategorySelected extends AddExpenseEvent {
  final Category category;

  const CategorySelected(this.category);

  @override
  List<Object?> get props => [category];
}

/// Event when amount changes
class AmountChanged extends AddExpenseEvent {
  final String amount;

  const AmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

/// Event when date is selected
class DateSelected extends AddExpenseEvent {
  final DateTime date;

  const DateSelected(this.date);

  @override
  List<Object?> get props => [date];
}

/// Event when currency is selected
class CurrencySelected extends AddExpenseEvent {
  final String currency;

  const CurrencySelected(this.currency);

  @override
  List<Object?> get props => [currency];
}

/// Event when receipt is uploaded
class ReceiptUploaded extends AddExpenseEvent {
  final String receiptPath;

  const ReceiptUploaded(this.receiptPath);

  @override
  List<Object?> get props => [receiptPath];
}

/// Event to save expense
class SaveExpense extends AddExpenseEvent {
  const SaveExpense();
}

/// Event to reset form
class ResetForm extends AddExpenseEvent {
  const ResetForm();
}
