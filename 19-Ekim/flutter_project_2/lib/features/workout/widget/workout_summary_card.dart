import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WorkoutSummaryCard extends StatelessWidget {
  const WorkoutSummaryCard({
    required this.totalMinutes,
    required this.totalCalories,
    super.key,
  });

  final int totalMinutes;
  final int totalCalories;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MetricItem(
              title: 'TOPLAM SÜRE',
              value: '$totalMinutes dk',
              accentColor: AppColors.neonGreen,
            ),
            Container(height: 40, width: 1, color: AppColors.border),
            _MetricItem(
              title: 'YAKILAN KALORİ',
              value: '$totalCalories kcal',
              accentColor: AppColors.neonOrange,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.title,
    required this.value,
    required this.accentColor,
  });

  final String title;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: accentColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
