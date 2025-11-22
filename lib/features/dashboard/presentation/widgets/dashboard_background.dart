import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Blue gradient background for dashboard top section
class DashboardBackground extends StatelessWidget {
  const DashboardBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(color: AppColors.primaryDark),
    );
  }
}
