import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'config/router/app_router.dart';
import 'shared/services/hive_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/signup_user.dart';

/// Main entry point for ClueScraper application
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

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
  final hiveService = HiveService();
  await hiveService.init();

  runApp(ClueScraper(hiveService: hiveService));
}

/// Root widget for ClueScraper application
class ClueScraper extends StatelessWidget {
  final HiveService hiveService;

  const ClueScraper({super.key, required this.hiveService});

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
        // Auth Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: loginUseCase,
            signupUseCase: signupUseCase,
            repository: authRepository,
          )..loadCurrentUser(),
        ),

        // TODO: Add ChatProvider, ReportProvider in future phases
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
