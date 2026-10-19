import 'package:flutter_test/flutter_test.dart';
import 'package:susadam_v2/features/water_tracker/controllers/water_tracker_controller.dart';
import 'package:susadam_v2/features/workout/controllers/workout_controller.dart';
import 'package:susadam_v2/main.dart';

void main() {
  group('WaterTrackerController Tests', () {
    test('Initial state should have 0 current water', () {
      final controller = WaterTrackerController();
      expect(controller.state.value.currentWaterMl, 0);
      expect(controller.state.value.dailyGoalMl, 2500);
      expect(controller.state.value.isGoalReached, false);
      controller.dispose();
    });

    test('addWater should increment current water and intake history', () {
      final controller = WaterTrackerController();
      controller.addWater(250);
      expect(controller.state.value.currentWaterMl, 250);
      expect(controller.state.value.intakeHistory.length, 1);
      expect(controller.state.value.intakeHistory.first, 250);

      controller.addWater(500);
      expect(controller.state.value.currentWaterMl, 750);
      expect(controller.state.value.intakeHistory.length, 2);
      controller.dispose();
    });

    test('resetWater should clear water and history', () {
      final controller = WaterTrackerController();
      controller.addWater(500);
      controller.resetWater();
      expect(controller.state.value.currentWaterMl, 0);
      expect(controller.state.value.intakeHistory.isEmpty, true);
      controller.dispose();
    });
  });

  group('WorkoutController Tests', () {
    test('toggleWorkoutCompletion should toggle isCompleted', () {
      final controller = WorkoutController();
      final firstId = controller.state.value.workouts.first.id;
      expect(controller.state.value.workouts.first.isCompleted, false);

      controller.toggleWorkoutCompletion(firstId);
      expect(controller.state.value.workouts.first.isCompleted, true);
      expect(controller.state.value.totalCaloriesBurned > 0, true);

      controller.toggleWorkoutCompletion(firstId);
      expect(controller.state.value.workouts.first.isCompleted, false);
      controller.dispose();
    });
  });

  testWidgets('SusadamApp smoke test renders dashboard and title', (WidgetTester tester) async {
    await tester.pumpWidget(const SusadamApp());
    expect(find.text('Susadım v2'), findsOneWidget);
    expect(find.text('Su Takibi'), findsOneWidget);
    expect(find.text('Egzersiz'), findsOneWidget);
  });
}
