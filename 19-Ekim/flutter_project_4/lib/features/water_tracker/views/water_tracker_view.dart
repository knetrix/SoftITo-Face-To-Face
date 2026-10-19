import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';
import '../models/water_tracker_model.dart';
import '../widgets/water_history_list_widget.dart';
import '../widgets/water_progress_widget.dart';
import '../widgets/water_quick_add_widget.dart';

class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WaterTrackerModel>(
      valueListenable: controller.state,
      builder: (context, data, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WaterProgressWidget(
                currentWaterMl: data.currentWaterMl,
                dailyGoalMl: data.dailyGoalMl,
                progress: data.progress,
                isGoalReached: data.isGoalReached,
              ),
              const SizedBox(height: 20),
              WaterQuickAddWidget(
                onAddWater: controller.addWater,
                onReset: controller.resetWater,
              ),
              const SizedBox(height: 24),
              WaterHistoryListWidget(
                history: data.intakeHistory,
              ),
            ],
          ),
        );
      },
    );
  }
}
