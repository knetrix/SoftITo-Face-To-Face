import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WaterProgressWidget extends StatelessWidget {
  final int currentWaterMl;
  final int dailyGoalMl;
  final double progress;
  final bool isGoalReached;

  const WaterProgressWidget({
    super.key,
    required this.currentWaterMl,
    required this.dailyGoalMl,
    required this.progress,
    required this.isGoalReached,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 170,
                  height: 170,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 14,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isGoalReached ? AppColors.neonLime : AppColors.neonCyan,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isGoalReached ? Icons.check_circle : Icons.water_drop,
                      color: isGoalReached ? AppColors.neonLime : AppColors.neonCyan,
                      size: 36,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$currentWaterMl',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '/ $dailyGoalMl ml',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              isGoalReached
                  ? 'Tebrikler! Günlük su hedefine ulaştın.'
                  : '%${(progress * 100).toInt()} tamamlandı',
              style: TextStyle(
                color: isGoalReached ? AppColors.neonLime : AppColors.neonCyan,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
