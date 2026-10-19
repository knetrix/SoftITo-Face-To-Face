import 'package:flutter/foundation.dart';
import '../models/water_log.dart';

class WaterTrackerController extends ChangeNotifier {
  WaterTrackerController({this.dailyGoalMl = 3000});

  final int dailyGoalMl;
  final List<WaterLog> _logs = [];

  List<WaterLog> get logs => List.unmodifiable(_logs);

  int get totalConsumedMl =>
      _logs.fold(0, (sum, item) => sum + item.amountMl);

  double get progressRatio =>
      dailyGoalMl == 0 ? 0.0 : (totalConsumedMl / dailyGoalMl).clamp(0.0, 1.0);

  void addWater(int amountMl) {
    if (amountMl <= 0) return;
    _logs.insert(
      0,
      WaterLog(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        amountMl: amountMl,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void reset() {
    _logs.clear();
    notifyListeners();
  }
}
