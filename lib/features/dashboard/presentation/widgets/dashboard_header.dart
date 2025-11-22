import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';

/// Dashboard header widget with user greeting and filter
class DashboardHeader extends StatelessWidget {
  final String currentFilter;
  final Function(String) onFilterChanged;

  const DashboardHeader({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning',
              style: AppTextStyles.caption.copyWith(color: Colors.white70),
            ),
            Text(
              'Ahmed Sami',
              style: AppTextStyles.h4.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Filter dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: currentFilter,
            underline: const SizedBox(),
            isDense: true,
            items:
                [
                  AppConstants.filterThisMonth,
                  AppConstants.filterLast7Days,
                  AppConstants.filterAllTime,
                ].map((filter) {
                  return DropdownMenuItem(
                    value: filter,
                    child: Text(filter, style: AppTextStyles.bodySmall),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                onFilterChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
