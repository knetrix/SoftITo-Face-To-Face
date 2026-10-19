import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/workout_controller.dart';
import '../models/workout_model.dart';
import '../widgets/workout_add_dialog_widget.dart';
import '../widgets/workout_item_card_widget.dart';
import '../widgets/workout_stats_card_widget.dart';

class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({
    super.key,
    required this.controller,
  });

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => WorkoutAddDialogWidget(
        onAdd: controller.addCustomWorkout,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WorkoutModel>(
      valueListenable: controller.state,
      builder: (context, data, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WorkoutStatsCardWidget(
                totalCalories: data.totalCaloriesBurned,
                calorieGoal: data.dailyCalorieGoal,
                activeMinutes: data.totalActiveMinutes,
                progress: data.calorieProgress,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Günlük Antrenman Listesi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showAddDialog(context),
                    icon: const Icon(Icons.add_circle, color: AppColors.neonLime),
                    tooltip: 'Egzersiz Ekle',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.workouts.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final workout = data.workouts[index];
                  return WorkoutItemCardWidget(
                    workout: workout,
                    onToggle: () => controller.toggleWorkoutCompletion(workout.id),
                  );
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: controller.resetAll,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Antrenmanları Sıfırla'),
              ),
            ],
          ),
        );
      },
    );
  }
}
