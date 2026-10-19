import 'package:flutter/material.dart';

/// Örnek Feature Model: İmmutable Su Takip Modeli
@immutable
class WaterTrackerModel {
  final int currentWaterMl;
  final int dailyGoalMl;

  const WaterTrackerModel({
    required this.currentWaterMl,
    required this.dailyGoalMl,
  });

  WaterTrackerModel copyWith({int? currentWaterMl, int? dailyGoalMl}) {
    return WaterTrackerModel(
      currentWaterMl: currentWaterMl ?? this.currentWaterMl,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
    );
  }

  factory WaterTrackerModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackerModel(
      currentWaterMl: json['currentWaterMl'] as int? ?? 0,
      dailyGoalMl: json['dailyGoalMl'] as int? ?? 2000,
    );
  }

  Map<String, dynamic> toJson() {
    return {'currentWaterMl': currentWaterMl, 'dailyGoalMl': dailyGoalMl};
  }
}

/// Örnek Feature Controller: ValueNotifier tabanlı hafif durum yöneticisi
class WaterTrackerController {
  final ValueNotifier<WaterTrackerModel> state =
      ValueNotifier<WaterTrackerModel>(
        const WaterTrackerModel(currentWaterMl: 0, dailyGoalMl: 2000),
      );

  void addWater([int amountMl = 250]) {
    state.value = state.value.copyWith(
      currentWaterMl: state.value.currentWaterMl + amountMl,
    );
  }

  void resetWater() {
    state.value = state.value.copyWith(currentWaterMl: 0);
  }

  void dispose() {
    state.dispose();
  }
}

/// Örnek Feature View: Ağır setState yerine ValueListenableBuilder ile reaktif görünüm
class WaterTrackerSampleScreen extends StatefulWidget {
  const WaterTrackerSampleScreen({super.key});

  @override
  State<WaterTrackerSampleScreen> createState() =>
      _WaterTrackerSampleScreenState();
}

class _WaterTrackerSampleScreenState extends State<WaterTrackerSampleScreen> {
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
      appBar: AppBar(title: const Text('Su Takip')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ValueListenableBuilder<WaterTrackerModel>(
            valueListenable: _controller.state,
            builder: (context, data, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WaterProgressIndicatorWidget(
                    currentWater: data.currentWaterMl,
                    goalWater: data.dailyGoalMl,
                  ),
                  const SizedBox(height: 24),
                  WaterActionButtonsWidget(
                    onAddPressed: () => _controller.addWater(250),
                    onResetPressed: _controller.resetWater,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Modüler Alt Widget 1: İlerleme Göstergesi (build metodu 40 satırı geçmez, const destekler)
class WaterProgressIndicatorWidget extends StatelessWidget {
  final int currentWater;
  final int goalWater;

  const WaterProgressIndicatorWidget({
    super.key,
    required this.currentWater,
    required this.goalWater,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = goalWater > 0
        ? (currentWater / goalWater).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              '$currentWater / $goalWater ml',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: progress, minHeight: 12),
          ],
        ),
      ),
    );
  }
}

/// Modüler Alt Widget 2: Aksiyon Butonları
class WaterActionButtonsWidget extends StatelessWidget {
  final VoidCallback onAddPressed;
  final VoidCallback onResetPressed;

  const WaterActionButtonsWidget({
    super.key,
    required this.onAddPressed,
    required this.onResetPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: onAddPressed,
          icon: const Icon(Icons.add),
          label: const Text('+250 ml Ekle'),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: onResetPressed,
          icon: const Icon(Icons.refresh),
          label: const Text('Sıfırla'),
        ),
      ],
    );
  }
}
