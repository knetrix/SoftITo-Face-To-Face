import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_model.dart';

class WorkoutItemCardWidget extends StatelessWidget {
  final WorkoutItem workout;
  final VoidCallback onToggle;

  const WorkoutItemCardWidget({
    super.key,
    required this.workout,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = workout.isCompleted;

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDone ? AppColors.neonLime.withAlpha(100) : AppColors.border,
            width: isDone ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDone
                    ? AppColors.neonLime.withAlpha(30)
                    : AppColors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDone ? Icons.check : Icons.fitness_center,
                color: isDone ? AppColors.neonLime : AppColors.neonCyan,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDone ? AppColors.textSecondary : AppColors.textPrimary,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          workout.category,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.neonCyan,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${workout.durationMinutes} dk • ${workout.caloriesBurned} kcal',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Checkbox(
              value: isDone,
              activeColor: AppColors.neonLime,
              checkColor: Colors.black,
              side: const BorderSide(color: AppColors.textSecondary, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              onChanged: (_) => onToggle(),
            ),
          ],
        ),
      ),
    );
  }
}
