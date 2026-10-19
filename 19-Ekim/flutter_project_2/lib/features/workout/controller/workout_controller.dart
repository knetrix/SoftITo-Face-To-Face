import 'package:flutter/foundation.dart';
import '../models/workout_item.dart';

class WorkoutController extends ChangeNotifier {
  final List<WorkoutItem> _workouts = [
    const WorkoutItem(
      id: '1',
      title: 'Gece Koşusu',
      durationMinutes: 30,
      caloriesBurned: 280,
      category: WorkoutCategory.cardio,
    ),
    const WorkoutItem(
      id: '2',
      title: 'Bench Press & Göğüs',
      durationMinutes: 45,
      caloriesBurned: 320,
      category: WorkoutCategory.strength,
    ),
  ];

  List<WorkoutItem> get workouts => List.unmodifiable(_workouts);

  int get totalCalories =>
      _workouts.fold(0, (sum, item) => sum + item.caloriesBurned);

  int get totalMinutes =>
      _workouts.fold(0, (sum, item) => sum + item.durationMinutes);

  void addWorkout(WorkoutItem item) {
    _workouts.insert(0, item);
    notifyListeners();
  }

  void removeWorkout(String id) {
    _workouts.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
