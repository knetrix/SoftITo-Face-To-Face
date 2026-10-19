import 'package:flutter/material.dart';

class WaterProgressCard extends StatelessWidget {
  final int currentWater;
  final int dailyGoal;

  const WaterProgressCard({
    super.key,
    required this.currentWater,
    required this.dailyGoal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = (currentWater / dailyGoal).clamp(0.0, 1.0);
    final percentage = (progress * 100).toInt();

    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;
    final primaryTextColor = isDark ? Colors.white : Colors.black87;
    final trackColor = isDark
        ? const Color(0xFF21262D)
        : const Color(0xFFE1E4E8);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'GÜNLÜK SU HEDEFİ',
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 170,
                  height: 170,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 14,
                    backgroundColor: trackColor,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$currentWater',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    Text(
                      '/ $dailyGoal ml',
                      style: TextStyle(fontSize: 14, color: secondaryTextColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '%$percentage Tamamlandı',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
