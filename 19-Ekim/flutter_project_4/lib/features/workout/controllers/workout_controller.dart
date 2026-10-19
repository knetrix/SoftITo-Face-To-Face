import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

class WorkoutController {
  final ValueNotifier<WorkoutModel> state = ValueNotifier<WorkoutModel>(
    const WorkoutModel(
      dailyCalorieGoal: 600,
      workouts: [
        WorkoutItem(
          id: 'w1',
          title: 'HIIT Kardiyo & Isınma',
          category: 'Kardiyo',
          durationMinutes: 20,
          caloriesBurned: 180,
          isCompleted: false,
        ),
        WorkoutItem(
          id: 'w2',
          title: 'Üst Vücut Güç Antrenmanı',
          category: 'Ağırlık',
          durationMinutes: 35,
          caloriesBurned: 240,
          isCompleted: false,
        ),
        WorkoutItem(
          id: 'w3',
          title: 'Karın & Core Sıkılaştırma',
          category: 'Core',
          durationMinutes: 15,
          caloriesBurned: 110,
          isCompleted: false,
        ),
        WorkoutItem(
          id: 'w4',
          title: 'Koşu Bandı & Soğuma',
          category: 'Kardiyo',
          durationMinutes: 25,
          caloriesBurned: 200,
          isCompleted: false,
        ),
      ],
    ),
  );

  void toggleWorkoutCompletion(String id) {
    final updatedList = state.value.workouts.map((workout) {
      if (workout.id == id) {
        return workout.copyWith(isCompleted: !workout.isCompleted);
      }
      return workout;
    }).toList();

    state.value = state.value.copyWith(workouts: updatedList);
  }

  void addCustomWorkout(String title, String category, int duration, int calories) {
    final newWorkout = WorkoutItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: category,
      durationMinutes: duration,
      caloriesBurned: calories,
      isCompleted: true,
    );

    final updated = List<WorkoutItem>.from(state.value.workouts)..add(newWorkout);
    state.value = state.value.copyWith(workouts: updated);
  }

  void resetAll() {
    final resetWorkouts = state.value.workouts
        .map((w) => w.copyWith(isCompleted: false))
        .toList();
    state.value = state.value.copyWith(workouts: resetWorkouts);
  }

  void dispose() {
    state.dispose();
  }
}
