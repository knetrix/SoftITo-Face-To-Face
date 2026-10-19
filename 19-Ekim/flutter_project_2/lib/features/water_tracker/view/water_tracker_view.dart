import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../controller/water_tracker_controller.dart';
import '../models/water_log.dart';

class WaterTrackerView extends StatelessWidget {
  const WaterTrackerView({required this.controller, super.key});

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WaterProgressCard(controller: controller),
              const SizedBox(height: 16),
              _WaterActionButtons(onAdd: controller.addWater),
              const SizedBox(height: 20),
              _WaterHistorySection(logs: controller.logs),
            ],
          ),
        );
      },
    );
  }
}

class _WaterProgressCard extends StatelessWidget {
  const _WaterProgressCard({required this.controller});

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    final progress = controller.progressRatio;
    final percent = (progress * 100).toInt();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'GÜNLÜK SU HEDEFİ',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${controller.totalConsumedMl} / ${controller.dailyGoalMl} ml',
              style: const TextStyle(
                color: AppColors.neonCyan,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
              backgroundColor: AppColors.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.neonCyan,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '%$percent Tamamlandı',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaterActionButtons extends StatelessWidget {
  const _WaterActionButtons({required this.onAdd});

  final void Function(int amount) onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton(250, '250 ml'),
        const SizedBox(width: 8),
        _buildButton(500, '500 ml'),
        const SizedBox(width: 8),
        _buildButton(750, '750 ml'),
      ],
    );
  }

  Widget _buildButton(int ml, String label) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceVariant,
          foregroundColor: AppColors.neonCyan,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => onAdd(ml),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _WaterHistorySection extends StatelessWidget {
  const _WaterHistorySection({required this.logs});

  final List<WaterLog> logs;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'Henüz su kaydı girilmedi.',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Günün Kayıtları',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length > 5 ? 5 : logs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final log = logs[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '+${log.amountMl} ml',
                    style: const TextStyle(
                      color: AppColors.neonCyan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
