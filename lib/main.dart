import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'services/database_service.dart';
import 'services/auth_service.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'data/exercise_library.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive database
  await DatabaseService.initialize();
  
  // Initialize exercise library (save to database if first time)
  await _initializeExercises();
  
  runApp(
    const ProviderScope(
      child: GymTrackerApp(),
    ),
  );
}

Future<void> _initializeExercises() async {
  final exerciseBox = DatabaseService.exercisesBox;
  
  // If no exercises exist, add the predefined ones
  if (exerciseBox.isEmpty) {
    for (final exercise in ExerciseLibrary.predefinedExercises) {
      await exerciseBox.add(exercise);
    }
  }
}

class GymTrackerApp extends ConsumerStatefulWidget {
  const GymTrackerApp({Key? key}) : super(key: key);

  @override
  ConsumerState<GymTrackerApp> createState() => _GymTrackerAppState();
}

class _GymTrackerAppState extends ConsumerState<GymTrackerApp> {
  bool _isCheckingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await ref.read(authProvider.notifier).checkAuth();
    setState(() {
      _isCheckingAuth = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Gym Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: _isCheckingAuth
          ? const _SplashScreen()
          : authState.isAuthenticated
              ? const HomeScreen()
              : const LoginScreen(),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
