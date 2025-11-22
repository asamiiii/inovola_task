import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/expense.dart';

/// Widget displaying a list of expenses with pagination
class ExpenseListWidget extends StatefulWidget {
  final List<Expense> expenses;
  final VoidCallback onLoadMore;
  final bool isLoadingMore;
  final bool hasMore;

  const ExpenseListWidget({
    super.key,
    required this.expenses,
    required this.onLoadMore,
    required this.isLoadingMore,
    required this.hasMore,
  });

  @override
  State<ExpenseListWidget> createState() => _ExpenseListWidgetState();
}

class _ExpenseListWidgetState extends State<ExpenseListWidget> {
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
      if (widget.hasMore && !widget.isLoadingMore) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.expenses.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index < widget.expenses.length) {
            final expense = widget.expenses[index];
            return _buildExpenseItem(expense);
          } else if (widget.isLoadingMore) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return null;
        }, childCount: widget.expenses.length + (widget.isLoadingMore ? 1 : 0)),
      ),
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
                Text(
                  '${DateFormatter.formatDate(expense.date)} ${DateFormatter.formatTime(expense.date)}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-${CurrencyFormatter.format(expense.amount, expense.currency)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.expense,
                ),
              ),
              if (expense.currency != 'USD')
                Text(
                  CurrencyFormatter.format(expense.convertedAmount, 'USD'),
                  style: AppTextStyles.caption,
                ),
            ],
          ),
        ],
      ),
    );
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
}
