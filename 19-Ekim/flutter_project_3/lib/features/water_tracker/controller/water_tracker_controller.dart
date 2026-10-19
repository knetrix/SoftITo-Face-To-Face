import 'package:flutter/foundation.dart';
import '../models/water_log.dart';

class WaterTrackerController {
  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  final ValueNotifier<List<WaterLog>> logs = ValueNotifier<List<WaterLog>>([]);
  final int dailyGoalWater = 2500;

  void addWater(int amountMl) {
    if (amountMl <= 0) return;
    currentWater.value += amountMl;
    final newLog = WaterLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
    );
    logs.value = [newLog, ...logs.value];
  }

  void resetWater() {
    currentWater.value = 0;
    logs.value = [];
  }

  void dispose() {
    currentWater.dispose();
    logs.dispose();
  }
}
