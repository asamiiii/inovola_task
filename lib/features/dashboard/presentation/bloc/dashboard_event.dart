import 'package:equatable/equatable.dart';

/// Base class for all dashboard events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load dashboard data
class LoadDashboard extends DashboardEvent {
  const LoadDashboard();
}

/// Event to load more expenses (pagination)
class LoadMoreExpenses extends DashboardEvent {
  const LoadMoreExpenses();
}

/// Event to apply filter
class ApplyFilter extends DashboardEvent {
  final String filter; // 'This Month', 'Last 7 Days', 'All Time'

  const ApplyFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Event to refresh dashboard
class RefreshDashboard extends DashboardEvent {
  const RefreshDashboard();
}
