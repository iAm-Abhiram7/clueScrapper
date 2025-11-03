import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'config/router/app_router.dart';
import 'shared/services/hive_service.dart';
import 'shared/services/gemini_service.dart';
import 'shared/services/image_picker_service.dart';
import 'core/constants/api_keys.dart';
import 'core/utils/app_logger.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/signup_user.dart';
import 'features/home/presentation/providers/navigation_provider.dart';
import 'features/chat/presentation/providers/chat_provider.dart';
import 'features/report/presentation/providers/report_provider.dart';
import 'features/report/data/repositories/report_repository_impl.dart';

/// Main entry point for ClueScraper application
void main() async {
  // Catch Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    AppLogger.error(
      'Flutter Framework Error',
      details.exception,
      details.stack,
    );
    // TODO: Send to crash reporting service (Firebase Crashlytics, Sentry)
  };

  // Catch Dart errors outside Flutter
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error('Uncaught Dart Error', error, stack);
    // TODO: Send to crash reporting service
    return true;
  };

  // Run app in guarded zone to catch async errors
  runZonedGuarded(
    () async {
      // Ensure Flutter binding is initialized
      WidgetsFlutterBinding.ensureInitialized();

      AppLogger.info('ClueScraper starting...');

      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

      // Initialize Hive database
      AppLogger.info('Initializing Hive database...');
      final hiveService = HiveService();
      await hiveService.init();
      AppLogger.success('Hive database initialized');

      // Initialize services
      AppLogger.info('Initializing services...');
      final geminiService = GeminiService(ApiKeys.geminiApiKey);
      final imagePickerService = ImagePickerService();
      AppLogger.success('Services initialized');

      runApp(
        ClueScraper(
          hiveService: hiveService,
          geminiService: geminiService,
          imagePickerService: imagePickerService,
        ),
      );

      AppLogger.success('ClueScraper launched successfully');
    },
    (error, stack) {
      AppLogger.error('Zoned Error', error, stack);
      // TODO: Send to crash reporting service
    },
  );
}

/// Root widget for ClueScraper application
class ClueScraper extends StatelessWidget {
  final HiveService hiveService;
  final GeminiService geminiService;
  final ImagePickerService imagePickerService;

  const ClueScraper({
    super.key,
    required this.hiveService,
    required this.geminiService,
    required this.imagePickerService,
  });

  @override
  Widget build(BuildContext context) {
    // Setup dependency injection
    final authLocalDataSource = AuthLocalDataSource(hiveService: hiveService);
    final authRepository = AuthRepositoryImpl(
      localDataSource: authLocalDataSource,
    );
    final loginUseCase = LoginUser(authRepository);
    final signupUseCase = SignupUser(authRepository);
    return MultiProvider(
      providers: [
        // Services
        Provider<HiveService>.value(value: hiveService),
        Provider<GeminiService>.value(value: geminiService),
        Provider<ImagePickerService>.value(value: imagePickerService),

        // Auth Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: loginUseCase,
            signupUseCase: signupUseCase,
            repository: authRepository,
          )..loadCurrentUser(),
        ),

        // Navigation Provider
        ChangeNotifierProvider(create: (_) => NavigationProvider()),

        // Chat Provider
        ChangeNotifierProvider(
          create: (_) => ChatProvider(
            hiveService: hiveService,
            geminiService: geminiService,
            imagePickerService: imagePickerService,
          ),
        ),

        // Report Provider
        ChangeNotifierProvider(
          create: (_) => ReportProvider(
            ReportRepositoryImpl(hiveService.reportBox),
            geminiService,
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'ClueScraper',
        debugShowCheckedModeBanner: false,

        // Theme configuration
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.light, // TODO: Add theme mode preference in future
        // Router configuration
        routerConfig: AppRouter.createRouter(),
      ),
    );
  }
}
