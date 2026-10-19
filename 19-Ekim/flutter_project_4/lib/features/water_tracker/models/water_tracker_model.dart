import 'package:flutter/foundation.dart';

@immutable
class WaterTrackerModel {
  final int currentWaterMl;
  final int dailyGoalMl;
  final List<int> intakeHistory;

  const WaterTrackerModel({
    required this.currentWaterMl,
    required this.dailyGoalMl,
    this.intakeHistory = const [],
  });

  double get progress =>
      dailyGoalMl > 0 ? (currentWaterMl / dailyGoalMl).clamp(0.0, 1.0) : 0.0;

  bool get isGoalReached => currentWaterMl >= dailyGoalMl;

  WaterTrackerModel copyWith({
    int? currentWaterMl,
    int? dailyGoalMl,
    List<int>? intakeHistory,
  }) {
    return WaterTrackerModel(
      currentWaterMl: currentWaterMl ?? this.currentWaterMl,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      intakeHistory: intakeHistory ?? this.intakeHistory,
    );
  }

  factory WaterTrackerModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackerModel(
      currentWaterMl: json['currentWaterMl'] as int? ?? 0,
      dailyGoalMl: json['dailyGoalMl'] as int? ?? 2500,
      intakeHistory: (json['intakeHistory'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentWaterMl': currentWaterMl,
      'dailyGoalMl': dailyGoalMl,
      'intakeHistory': intakeHistory,
    };
  }
}
