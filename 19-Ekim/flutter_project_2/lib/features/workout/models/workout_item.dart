enum WorkoutCategory {
  cardio('Kardiyo'),
  strength('Kuvvet Antrenmanı'),
  flexibility('Esneme & Yoga');

  const WorkoutCategory(this.displayName);
  final String displayName;
}

class WorkoutItem {
  const WorkoutItem({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.category,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final int caloriesBurned;
  final WorkoutCategory category;
}
