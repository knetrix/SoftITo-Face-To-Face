import 'package:flutter/material.dart';

import '../models/water_log.dart';

class WaterHistoryList extends StatelessWidget {
  final List<WaterLog> logs;

  const WaterHistoryList({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    final mutedColor = isDark
        ? const Color(0xFF6E7681)
        : const Color(0xFF8C959F);
    final secondaryTextColor = isDark
        ? const Color(0xFF8B949E)
        : const Color(0xFF656D76);
    final titleColor = isDark
        ? const Color(0xFFF0F6FC)
        : const Color(0xFF1F2328);
    final cardBg = isDark ? const Color(0xFF161B22) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF30363D)
        : const Color(0xFFD0D7DE);

    if (logs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Text(
          'Bugün henüz su kaydı eklenmedi.',
          style: TextStyle(color: mutedColor, fontSize: 13),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Text(
            'BUGÜNKÜ KAYITLAR',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final log = logs[index];
            final hour = log.timestamp.hour.toString().padLeft(2, '0');
            final minute = log.timestamp.minute.toString().padLeft(2, '0');

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.water_drop, color: primaryColor, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        '+${log.amountMl} ml Su Eklendi',
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$hour:$minute',
                    style: TextStyle(color: secondaryTextColor, fontSize: 12),
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
