import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/calculate_summary.dart';

/// Base class for all dashboard states
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

/// Loading state
class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

/// Loaded state with data
class DashboardLoaded extends DashboardState {
  final List<Expense> expenses;
  final ExpenseSummary summary;
  final String currentFilter;
  final bool hasMore;
  final int currentPage;

  const DashboardLoaded({
    required this.expenses,
    required this.summary,
    required this.currentFilter,
    required this.hasMore,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [
    expenses,
    summary,
    currentFilter,
    hasMore,
    currentPage,
  ];

  DashboardLoaded copyWith({
    List<Expense>? expenses,
    ExpenseSummary? summary,
    String? currentFilter,
    bool? hasMore,
    int? currentPage,
  }) {
    return DashboardLoaded(
      expenses: expenses ?? this.expenses,
      summary: summary ?? this.summary,
      currentFilter: currentFilter ?? this.currentFilter,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Loading more state (for pagination)
class DashboardLoadingMore extends DashboardState {
  final List<Expense> currentExpenses;
  final ExpenseSummary summary;
  final String currentFilter;
  final int currentPage;

  const DashboardLoadingMore({
    required this.currentExpenses,
    required this.summary,
    required this.currentFilter,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [
    currentExpenses,
    summary,
    currentFilter,
    currentPage,
  ];
}

/// Error state
class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
