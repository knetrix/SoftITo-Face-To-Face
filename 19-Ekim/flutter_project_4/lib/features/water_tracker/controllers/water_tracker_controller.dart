import 'package:flutter/foundation.dart';
import '../models/water_tracker_model.dart';

class WaterTrackerController {
  final ValueNotifier<WaterTrackerModel> state =
      ValueNotifier<WaterTrackerModel>(
    const WaterTrackerModel(currentWaterMl: 0, dailyGoalMl: 2500),
  );

  void addWater(int amountMl) {
    if (amountMl <= 0) return;
    final current = state.value;
    final newAmount = current.currentWaterMl + amountMl;
    final updatedHistory = List<int>.from(current.intakeHistory)..add(amountMl);

    state.value = current.copyWith(
      currentWaterMl: newAmount,
      intakeHistory: updatedHistory,
    );
  }

  void resetWater() {
    state.value = state.value.copyWith(
      currentWaterMl: 0,
      intakeHistory: [],
    );
  }

  void updateDailyGoal(int newGoalMl) {
    if (newGoalMl < 500) return;
    state.value = state.value.copyWith(dailyGoalMl: newGoalMl);
  }

  void dispose() {
    state.dispose();
  }
}
