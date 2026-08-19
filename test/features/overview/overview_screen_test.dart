import 'package:dots_in/core/sensors/sensor_service.dart';
import 'package:dots_in/features/overview/data/repositories/health_overview_repository.dart';
import 'package:dots_in/features/overview/presentation/bloc/overview_bloc.dart';
import 'package:dots_in/features/overview/presentation/screens/overview_screen.dart';
import 'package:dots_in/features/sensor_hub/presentation/bloc/sensors_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('OverviewScreen renders correctly with OverviewBloc', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final sensorService = SensorService();
    final repo = HealthOverviewRepositoryImpl();

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<SensorsBloc>(
              create: (_) => SensorsBloc(sensorService: sensorService)
                ..add(StartSensorStreamEvent()),
            ),
            BlocProvider<OverviewBloc>(
              create: (_) => OverviewBloc(repository: repo)..add(LoadOverviewEvent()),
            ),
          ],
          child: const OverviewScreen(),
        ),
      ),
    );

    // Initial loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Advance past async repository delay (150ms) + animations
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify bento header and cards
    expect(find.text('Your Health'), findsOneWidget);
    expect(find.text('Good morning, Alex'), findsOneWidget);
    expect(find.text('Heart'), findsOneWidget);
    expect(find.text('Lungs'), findsOneWidget);

    sensorService.dispose();
  });
}
