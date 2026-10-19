import 'package:flutter/material.dart';

class QuickAddWaterGrid extends StatelessWidget {
  final ValueChanged<int> onAddWater;

  const QuickAddWaterGrid({super.key, required this.onAddWater});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAddButton(
            amountMl: 200,
            label: 'Bardak (200ml)',
            icon: Icons.local_drink,
            onTap: () => onAddWater(200),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAddButton(
            amountMl: 500,
            label: 'Şişe (500ml)',
            icon: Icons.water_drop,
            onTap: () => onAddWater(500),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAddButton(
            amountMl: 750,
            label: 'Matara (750ml)',
            icon: Icons.fitness_center,
            onTap: () => onAddWater(750),
          ),
        ),
      ],
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final int amountMl;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.amountMl,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    final bgColor = isDark ? const Color(0xFF161B22) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF30363D)
        : const Color(0xFFD0D7DE);
    final titleColor = isDark
        ? const Color(0xFFF0F6FC)
        : const Color(0xFF1F2328);
    final subtitleColor = isDark
        ? const Color(0xFF8B949E)
        : const Color(0xFF656D76);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: primaryColor, size: 26),
            const SizedBox(height: 8),
            Text(
              '+$amountMl ml',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10, color: subtitleColor),
            ),
          ],
        ),
      ),
    );
  }
}
