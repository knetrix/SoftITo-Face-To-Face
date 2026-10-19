import 'package:flutter/foundation.dart';

@immutable
class WorkoutItem {
  final String id;
  final String title;
  final String category;
  final int durationMinutes;
  final int caloriesBurned;
  final bool isCompleted;

  const WorkoutItem({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.isCompleted = false,
  });

  WorkoutItem copyWith({
    String? id,
    String? title,
    String? category,
    int? durationMinutes,
    int? caloriesBurned,
    bool? isCompleted,
  }) {
    return WorkoutItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory WorkoutItem.fromJson(Map<String, dynamic> json) {
    return WorkoutItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'Genel',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      caloriesBurned: json['caloriesBurned'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'isCompleted': isCompleted,
    };
  }
}

@immutable
class WorkoutModel {
  final List<WorkoutItem> workouts;
  final int dailyCalorieGoal;

  const WorkoutModel({
    required this.workouts,
    required this.dailyCalorieGoal,
  });

  int get totalCaloriesBurned => workouts
      .where((w) => w.isCompleted)
      .fold(0, (sum, w) => sum + w.caloriesBurned);

  int get totalActiveMinutes => workouts
      .where((w) => w.isCompleted)
      .fold(0, (sum, w) => sum + w.durationMinutes);

  double get calorieProgress => dailyCalorieGoal > 0
      ? (totalCaloriesBurned / dailyCalorieGoal).clamp(0.0, 1.0)
      : 0.0;

  WorkoutModel copyWith({
    List<WorkoutItem>? workouts,
    int? dailyCalorieGoal,
  }) {
    return WorkoutModel(
      workouts: workouts ?? this.workouts,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
    );
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      workouts: (json['workouts'] as List<dynamic>?)
              ?.map((e) => WorkoutItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dailyCalorieGoal: json['dailyCalorieGoal'] as int? ?? 500,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workouts': workouts.map((w) => w.toJson()).toList(),
      'dailyCalorieGoal': dailyCalorieGoal,
    };
  }
}
