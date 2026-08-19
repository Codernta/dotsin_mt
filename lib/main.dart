import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/sensors/sensor_service.dart';
import 'core/theme/health_theme.dart';
import 'features/body_explore/data/repositories/organ_repository.dart';
import 'features/body_explore/presentation/bloc/body_explore_bloc.dart';
import 'features/insights/data/repositories/insights_repository.dart';
import 'features/insights/presentation/bloc/insights_bloc.dart';
import 'features/overview/data/repositories/health_overview_repository.dart';
import 'features/overview/presentation/bloc/overview_bloc.dart';
import 'features/recommendations/data/repositories/recommendations_repository.dart';
import 'features/recommendations/presentation/bloc/recommendations_bloc.dart';
import 'features/sensor_hub/presentation/bloc/sensors_bloc.dart';
import 'features/shell/presentation/cubit/navigation_cubit.dart';
import 'features/shell/presentation/screens/app_shell_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set immersive dark status bar & navigation bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final sensorService = SensorService();

  runApp(HealthDataHubApp(sensorService: sensorService));
}

class HealthDataHubApp extends StatelessWidget {
  final SensorService sensorService;

  const HealthDataHubApp({super.key, required this.sensorService});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HealthOverviewRepository>(
          create: (_) => HealthOverviewRepositoryImpl(),
        ),
        RepositoryProvider<OrganRepository>(
          create: (_) => OrganRepositoryImpl(),
        ),
        RepositoryProvider<InsightsRepository>(
          create: (_) => InsightsRepositoryImpl(),
        ),
        RepositoryProvider<RecommendationsRepository>(
          create: (_) => RecommendationsRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NavigationCubit>(
            create: (_) => NavigationCubit(),
          ),
          BlocProvider<SensorsBloc>(
            create: (_) => SensorsBloc(sensorService: sensorService)
              ..add(StartSensorStreamEvent()),
          ),
          BlocProvider<OverviewBloc>(
            create: (context) => OverviewBloc(
              repository: context.read<HealthOverviewRepository>(),
            )..add(LoadOverviewEvent()),
          ),
          BlocProvider<BodyExploreBloc>(
            create: (context) => BodyExploreBloc(
              repository: context.read<OrganRepository>(),
            )..add(LoadOrgansEvent()),
          ),
          BlocProvider<InsightsBloc>(
            create: (context) => InsightsBloc(
              repository: context.read<InsightsRepository>(),
            )..add(LoadInsightsEvent()),
          ),
          BlocProvider<RecommendationsBloc>(
            create: (context) => RecommendationsBloc(
              repository: context.read<RecommendationsRepository>(),
            )..add(LoadRecommendationsEvent()),
          ),
        ],
        child: MaterialApp(
          title: 'Health Data Hub',
          debugShowCheckedModeBanner: false,
          theme: HealthTheme.lightTheme,
          darkTheme: HealthTheme.darkTheme,
          themeMode: ThemeMode.dark,
          home: const AppShellScreen(),
        ),
      ),
    );
  }
}
