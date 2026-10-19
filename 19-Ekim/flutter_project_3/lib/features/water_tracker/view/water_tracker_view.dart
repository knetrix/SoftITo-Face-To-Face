import 'package:flutter/material.dart';

import '../../../core/theme/theme_controller.dart';
import '../controller/water_tracker_controller.dart';
import '../models/water_log.dart';
import '../widgets/quick_add_water_grid.dart';
import '../widgets/water_history_list.dart';
import '../widgets/water_progress_card.dart';

class WaterTrackerView extends StatefulWidget {
  const WaterTrackerView({super.key});

  @override
  State<WaterTrackerView> createState() => _WaterTrackerViewState();
}

class _WaterTrackerViewState extends State<WaterTrackerView> {
  late final WaterTrackerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WaterTrackerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SUSADIM v1'),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.instance.themeModeNotifier,
            builder: (context, themeMode, _) {
              final isDark = themeMode == ThemeMode.dark;
              return IconButton(
                tooltip: isDark ? 'Aydınlık Moda Geç' : 'Karanlık Moda Geç',
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: ThemeController.instance.toggleTheme,
              );
            },
          ),
          IconButton(
            tooltip: 'Sıfırla',
            icon: const Icon(Icons.refresh),
            onPressed: _controller.resetWater,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ValueListenableBuilder<int>(
                valueListenable: _controller.currentWater,
                builder: (context, currentWater, _) {
                  return WaterProgressCard(
                    currentWater: currentWater,
                    dailyGoal: _controller.dailyGoalWater,
                  );
                },
              ),
              const SizedBox(height: 16),
              QuickAddWaterGrid(onAddWater: _controller.addWater),
              const SizedBox(height: 20),
              ValueListenableBuilder<List<WaterLog>>(
                valueListenable: _controller.logs,
                builder: (context, logs, _) {
                  return WaterHistoryList(logs: logs);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
