import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/usecases/calculate_summary.dart';
import '../../domain/usecases/get_expenses.dart';
import '../../domain/usecases/get_filtered_expenses.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// BLoC for dashboard feature
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetExpenses getExpenses;
  final GetFilteredExpenses getFilteredExpenses;
  final CalculateSummary calculateSummary;

  DashboardBloc({
    required this.getExpenses,
    required this.getFilteredExpenses,
    required this.calculateSummary,
  }) : super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<LoadMoreExpenses>(_onLoadMoreExpenses);
    on<ApplyFilter>(_onApplyFilter);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    // Get summary
    final summaryResult = await calculateSummary();

    await summaryResult.fold(
      (failure) async {
        emit(DashboardError(failure.message));
      },
      (summary) async {
        // Get first page of expenses with default filter (This Month)
        final startDate = DateFormatter.startOfMonth(DateTime.now());
        final endDate = DateFormatter.endOfMonth(DateTime.now());

        final expensesResult = await getFilteredExpenses(
          startDate: startDate,
          endDate: endDate,
        );

        expensesResult.fold(
          (failure) {
            emit(DashboardError(failure.message));
          },
          (allExpenses) {
            // Take first page
            final firstPage = allExpenses
                .take(AppConstants.itemsPerPage)
                .toList();
            final hasMore = allExpenses.length > AppConstants.itemsPerPage;

            emit(
              DashboardLoaded(
                expenses: firstPage,
                allFilteredExpenses: allExpenses,
                summary: summary,
                currentFilter: AppConstants.filterThisMonth,
                hasMore: hasMore,
                currentPage: 0,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onLoadMoreExpenses(
    LoadMoreExpenses event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is! DashboardLoaded) return;

    final currentState = state as DashboardLoaded;
    if (!currentState.hasMore) return;

    emit(
      DashboardLoadingMore(
        currentExpenses: currentState.expenses,
        summary: currentState.summary,
        currentFilter: currentState.currentFilter,
        currentPage: currentState.currentPage,
      ),
    );

    // Add a small delay to make pagination visible
    await Future.delayed(
      Duration(milliseconds: AppConstants.paginationDelayMs),
    );

    // Get next page from cached allFilteredExpenses
    final nextPage = currentState.currentPage + 1;
    final startIndex = nextPage * AppConstants.itemsPerPage;
    final endIndex = startIndex + AppConstants.itemsPerPage;

    if (startIndex >= currentState.allFilteredExpenses.length) {
      emit(currentState.copyWith(hasMore: false));
      return;
    }

    final newExpenses = currentState.allFilteredExpenses.sublist(
      startIndex,
      endIndex > currentState.allFilteredExpenses.length
          ? currentState.allFilteredExpenses.length
          : endIndex,
    );

    final updatedExpenses = [...currentState.expenses, ...newExpenses];
    final hasMore = endIndex < currentState.allFilteredExpenses.length;

    emit(
      DashboardLoaded(
        expenses: updatedExpenses,
        allFilteredExpenses: currentState.allFilteredExpenses,
        summary: currentState.summary,
        currentFilter: currentState.currentFilter,
        hasMore: hasMore,
        currentPage: nextPage,
      ),
    );
  }

  Future<void> _onApplyFilter(
    ApplyFilter event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    // Get summary
    final summaryResult = await calculateSummary();

    await summaryResult.fold(
      (failure) async {
        emit(DashboardError(failure.message));
      },
      (summary) async {
        // Get filtered expenses
        final dateRange = _getDateRangeForFilter(event.filter);
        final expensesResult = await getFilteredExpenses(
          startDate: dateRange['start'],
          endDate: dateRange['end'],
        );

        expensesResult.fold(
          (failure) {
            emit(DashboardError(failure.message));
          },
          (allExpenses) {
            // Take first page
            final firstPage = allExpenses
                .take(AppConstants.itemsPerPage)
                .toList();
            final hasMore = allExpenses.length > AppConstants.itemsPerPage;

            emit(
              DashboardLoaded(
                expenses: firstPage,
                allFilteredExpenses: allExpenses,
                summary: summary,
                currentFilter: event.filter,
                hasMore: hasMore,
                currentPage: 0,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    // Refresh with current filter if loaded, otherwise use default
    final currentFilter = state is DashboardLoaded
        ? (state as DashboardLoaded).currentFilter
        : AppConstants.filterThisMonth;

    add(ApplyFilter(currentFilter));
  }

  /// Get date range for filter
  Map<String, DateTime?> _getDateRangeForFilter(String filter) {
    switch (filter) {
      case AppConstants.filterThisMonth:
        return {
          'start': DateFormatter.startOfMonth(DateTime.now()),
          'end': DateFormatter.endOfMonth(DateTime.now()),
        };
      case AppConstants.filterLast7Days:
        return {'start': DateFormatter.last7Days(), 'end': DateTime.now()};
      case AppConstants.filterAllTime:
      default:
        return {'start': null, 'end': null};
    }
  }
}
