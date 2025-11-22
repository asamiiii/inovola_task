import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../add_expense/presentation/bloc/add_expense_bloc.dart';
import '../../../add_expense/presentation/screens/add_expense_screen.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/balance_card_widget.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_background.dart';
import '../widgets/expense_list.dart';
import '../../../../core/shared/widgets/error_display.dart';

/// Dashboard screen showing expenses and summary
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent *
            AppConstants.scrollThresholdForPagination) {
      final state = context.read<DashboardBloc>().state;
      if (state is DashboardLoaded && state.hasMore) {
        context.read<DashboardBloc>().add(const LoadMoreExpenses());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Blue background for top half
          const DashboardBackground(),
          // Content
          SafeArea(
            child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (state is DashboardError) {
                  return ErrorDisplay(
                    message: state.message,
                    onRetry: () {
                      context.read<DashboardBloc>().add(
                        const RefreshDashboard(),
                      );
                    },
                  );
                }

                if (state is DashboardLoaded || state is DashboardLoadingMore) {
                  return _buildLoadedState(context, state);
                }

                // Initial state
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        onAddPressed: (context) => _navigateToAddExpense(context),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, DashboardState state) {
    final expenses = state is DashboardLoaded
        ? state.expenses
        : (state as DashboardLoadingMore).currentExpenses;
    final summary = state is DashboardLoaded
        ? state.summary
        : (state as DashboardLoadingMore).summary;
    final currentFilter = state is DashboardLoaded
        ? state.currentFilter
        : (state as DashboardLoadingMore).currentFilter;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(const RefreshDashboard());
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Header with blue background
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User greeting and filter
                  DashboardHeader(
                    currentFilter: currentFilter,
                    onFilterChanged: (filter) {
                      context.read<DashboardBloc>().add(ApplyFilter(filter));
                    },
                  ),
                  const SizedBox(height: 24),
                  // Balance Card
                  BalanceCardWidget(
                    totalBalance: summary.totalBalance,
                    totalIncome: summary.totalIncome,
                    totalExpenses: summary.totalExpenses,
                  ),
                ],
              ),
            ),
            // Recent Expenses section with white background
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recent Expenses', style: AppTextStyles.h4),
                      ],
                    ),
                  ),
                  // Expense List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ExpenseList(expenses: expenses, state: state),
                  ),
                  const SizedBox(height: 80), // Bottom padding for nav bar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddExpense(BuildContext context) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => di.sl<AddExpenseBloc>(),
              child: const AddExpenseScreen(),
            ),
          ),
        )
        .then((_) {
          // Refresh dashboard after adding expense
          context.read<DashboardBloc>().add(const RefreshDashboard());
        });
  }
}
