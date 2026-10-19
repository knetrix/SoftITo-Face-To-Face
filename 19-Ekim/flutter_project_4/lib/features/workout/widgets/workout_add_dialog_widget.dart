import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WorkoutAddDialogWidget extends StatelessWidget {
  final void Function(String title, String category, int duration, int calories) onAdd;

  const WorkoutAddDialogWidget({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final durationController = TextEditingController(text: '20');
    final calController = TextEditingController(text: '150');
    String selectedCategory = 'Kardiyo';

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Yeni Egzersiz Ekle'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Egzersiz Adı',
                hintText: 'Örn: İp Atlama',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Süre (dakika)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: calController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tahmini Kalori (kcal)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            final title = titleController.text.trim();
            final duration = int.tryParse(durationController.text) ?? 20;
            final cal = int.tryParse(calController.text) ?? 150;
            if (title.isNotEmpty) {
              onAdd(title, selectedCategory, duration, cal);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}
