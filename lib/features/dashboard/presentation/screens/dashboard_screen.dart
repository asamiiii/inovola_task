import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../add_expense/presentation/bloc/add_expense_bloc.dart';
import '../../../add_expense/presentation/screens/add_expense_screen.dart';
import '../../domain/entities/expense.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/balance_card_widget.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_background.dart';
import '../widgets/expense_list.dart';

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
        _scrollController.position.maxScrollExtent * 0.9) {
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
                  return _buildErrorState(context, state.message);
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

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<DashboardBloc>().add(const RefreshDashboard());
            },
            child: const Text('Retry'),
          ),
        ],
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
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'see all',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expense List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildExpenseList(expenses, context, state),
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

  Widget _buildExpenseList(
    List<Expense> expenses,
    BuildContext context,
    DashboardState state,
  ) {
    if (expenses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No expenses yet',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add your first expense',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...expenses.map((expense) => _buildExpenseItem(expense)),
        if (state is DashboardLoadingMore)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Widget _buildExpenseItem(Expense expense) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          // Category icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getCategoryColor(expense.categoryId).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(expense.categoryId),
              color: _getCategoryColor(expense.categoryId),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Expense details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.categoryName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(_formatDate(expense.date), style: AppTextStyles.caption),
              ],
            ),
          ),
          // Amount
          Text(
            '-\$${expense.convertedAmount.toStringAsFixed(2)}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.expense,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'groceries':
        return AppColors.groceries;
      case 'entertainment':
        return AppColors.entertainment;
      case 'gas':
        return AppColors.gas;
      case 'shopping':
        return AppColors.shopping;
      case 'transport':
        return AppColors.transport;
      case 'rent':
        return AppColors.rent;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'groceries':
        return Icons.shopping_cart;
      case 'entertainment':
        return Icons.movie;
      case 'gas':
        return Icons.local_gas_station;
      case 'shopping':
        return Icons.shopping_bag;
      case 'transport':
        return Icons.directions_car;
      case 'rent':
        return Icons.home;
      default:
        return Icons.receipt;
    }
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
