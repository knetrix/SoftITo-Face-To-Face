import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WaterQuickAddWidget extends StatelessWidget {
  final ValueChanged<int> onAddWater;
  final VoidCallback onReset;

  const WaterQuickAddWidget({
    super.key,
    required this.onAddWater,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hızlı Su Ekle',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickAddButton(
                amount: 200,
                label: 'Bardak',
                icon: Icons.local_cafe,
                onTap: () => onAddWater(200),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _QuickAddButton(
                amount: 330,
                label: 'Kutu',
                icon: Icons.sports_bar,
                onTap: () => onAddWater(330),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _QuickAddButton(
                amount: 500,
                label: 'Şişe',
                icon: Icons.local_drink,
                onTap: () => onAddWater(500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => onAddWater(250),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('+250 ml Ekle'),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.restart_alt, size: 20),
              label: const Text('Sıfırla'),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final int amount;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.amount,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.neonCyan, size: 22),
            const SizedBox(height: 4),
            Text(
              '+$amount ml',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
