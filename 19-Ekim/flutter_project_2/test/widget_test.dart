import 'package:flutter_test/flutter_test.dart';
import 'package:susadim_app/features/water_tracker/controller/water_tracker_controller.dart';
import 'package:susadim_app/features/workout/controller/workout_controller.dart';
import 'package:susadim_app/features/workout/models/workout_item.dart';
import 'package:susadim_app/main.dart';

void main() {
  testWidgets('SusadimApp smoke test and navigation verify', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SusadimApp());

    expect(find.text('SUSADIM • FITNESS & SU'), findsOneWidget);
    expect(find.text('GÜNLÜK SU HEDEFİ'), findsOneWidget);
    expect(find.text('Su Takibi'), findsOneWidget);
    expect(find.text('Antrenman'), findsOneWidget);
  });

  test('WaterTrackerController adds water log correctly', () {
    final controller = WaterTrackerController(dailyGoalMl: 2000);
    expect(controller.totalConsumedMl, 0);

    controller.addWater(500);
    expect(controller.totalConsumedMl, 500);
    expect(controller.progressRatio, 0.25);
    expect(controller.logs.length, 1);
  });

  test('WorkoutController handles adding and removing workouts', () {
    final controller = WorkoutController();
    final initialCount = controller.workouts.length;

    const item = WorkoutItem(
      id: 'test_1',
      title: 'Test Workout',
      durationMinutes: 15,
      caloriesBurned: 100,
      category: WorkoutCategory.cardio,
    );

    controller.addWorkout(item);
    expect(controller.workouts.length, initialCount + 1);

    controller.removeWorkout('test_1');
    expect(controller.workouts.length, initialCount);
  });
}
