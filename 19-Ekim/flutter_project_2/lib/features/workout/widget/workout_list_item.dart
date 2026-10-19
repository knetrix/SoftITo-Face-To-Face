import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_item.dart';

class WorkoutListItem extends StatelessWidget {
  const WorkoutListItem({
    required this.workout,
    required this.onDelete,
    super.key,
  });

  final WorkoutItem workout;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _CategoryBadge(category: workout.category),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${workout.durationMinutes} dk • ${workout.caloriesBurned} kcal',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: AppColors.neonPink,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final WorkoutCategory category;

  @override
  Widget build(BuildContext context) {
    final iconData = switch (category) {
      WorkoutCategory.cardio => Icons.directions_run,
      WorkoutCategory.strength => Icons.fitness_center,
      WorkoutCategory.flexibility => Icons.self_improvement,
    };

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: AppColors.neonGreen, size: 20),
    );
  }
}
