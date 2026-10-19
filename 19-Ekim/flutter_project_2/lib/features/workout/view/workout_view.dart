import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../controller/workout_controller.dart';
import '../models/workout_item.dart';
import '../widget/workout_list_item.dart';
import '../widget/workout_summary_card.dart';

class WorkoutView extends StatelessWidget {
  const WorkoutView({required this.controller, super.key});

  final WorkoutController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WorkoutSummaryCard(
                totalMinutes: controller.totalMinutes,
                totalCalories: controller.totalCalories,
              ),
              const SizedBox(height: 16),
              _AddWorkoutQuickButton(onAdded: controller.addWorkout),
              const SizedBox(height: 20),
              _WorkoutListSection(
                workouts: controller.workouts,
                onDelete: controller.removeWorkout,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddWorkoutQuickButton extends StatelessWidget {
  const _AddWorkoutQuickButton({required this.onAdded});

  final void Function(WorkoutItem) onAdded;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.neonGreen,
        foregroundColor: AppColors.background,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        final now = DateTime.now().millisecondsSinceEpoch;
        onAdded(
          WorkoutItem(
            id: now.toString(),
            title: 'Hızlı Antrenman',
            durationMinutes: 20,
            caloriesBurned: 150,
            category: WorkoutCategory.strength,
          ),
        );
      },
      icon: const Icon(Icons.add, size: 20),
      label: const Text(
        'HIZLI ANTRENMAN EKLE',
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }
}

class _WorkoutListSection extends StatelessWidget {
  const _WorkoutListSection({required this.workouts, required this.onDelete});

  final List<WorkoutItem> workouts;
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'Henüz antrenman kaydı yok.',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workouts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = workouts[index];
        return WorkoutListItem(
          workout: item,
          onDelete: () => onDelete(item.id),
        );
      },
    );
  }
}
