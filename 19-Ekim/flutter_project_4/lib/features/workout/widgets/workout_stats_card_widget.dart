import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WorkoutStatsCardWidget extends StatelessWidget {
  final int totalCalories;
  final int calorieGoal;
  final int activeMinutes;
  final double progress;

  const WorkoutStatsCardWidget({
    super.key,
    required this.totalCalories,
    required this.calorieGoal,
    required this.activeMinutes,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatItem(
                  icon: Icons.local_fire_department,
                  iconColor: AppColors.neonPink,
                  value: '$totalCalories',
                  unit: 'kcal',
                  label: 'Yakılan Kalori',
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.border,
                ),
                _StatItem(
                  icon: Icons.timer,
                  iconColor: AppColors.neonCyan,
                  value: '$activeMinutes',
                  unit: 'dk',
                  label: 'Aktif Süre',
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.border,
                ),
                _StatItem(
                  icon: Icons.flag,
                  iconColor: AppColors.neonLime,
                  value: '$calorieGoal',
                  unit: 'kcal',
                  label: 'Günlük Hedef',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kalori Hedef İlerlemesi',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    Text(
                      '%${(progress * 100).toInt()}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neonPink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonPink),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String unit;
  final String label;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
