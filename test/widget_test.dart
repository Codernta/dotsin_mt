import 'package:dots_in/core/sensors/sensor_service.dart';
import 'package:dots_in/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('HealthDataHubApp smoke test and tab navigation verification', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final sensorService = SensorService();

    await tester.pumpWidget(HealthDataHubApp(sensorService: sensorService));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Title presence
    expect(find.text('Health Data Hub'), findsWidgets);

    // Verify Active Tab Label
    expect(find.text('Overview'), findsWidgets);

    // Verify Bento Header
    expect(find.text('Your Health'), findsOneWidget);

    // Tap on the Explore tab icon (accessibility_new_rounded)
    await tester.tap(find.byIcon(Icons.accessibility_new_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Explore Screen appears
    expect(find.text('Explore Your Health'), findsOneWidget);
    expect(find.text('Health'), findsWidgets);

    // Tap on Insights tab icon (insights_rounded)
    await tester.tap(find.byIcon(Icons.insights_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Insights Screen appears
    expect(find.text('Your Health Insights'), findsOneWidget);
    expect(find.text('Your Strengths'), findsOneWidget);

    // Tap on Protocols tab icon (checklist_rounded)
    await tester.tap(find.byIcon(Icons.checklist_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Protocols Screen appears
    expect(find.text('Personalized Protocols'), findsOneWidget);
    expect(find.text("Today's Protocols"), findsOneWidget);

    sensorService.dispose();
  });
}
