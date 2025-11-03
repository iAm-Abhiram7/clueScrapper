import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../shared/services/hive_service.dart';
import '../../core/constants/storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Application router configuration using GoRouter
class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static final _secureStorage = const FlutterSecureStorage();

  /// Check if user is logged in
  static Future<bool> _isLoggedIn() async {
    try {
      final isLoggedIn = await _secureStorage.read(
        key: StorageKeys.isLoggedInKey,
      );
      return isLoggedIn == 'true';
    } catch (e) {
      debugPrint('AppRouter: Error checking login status - $e');
      return false;
    }
  }

  /// Create and configure the router
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: splash,
      debugLogDiagnostics: true,
      routes: [
        // Splash/Initial Route
        GoRoute(
          path: splash,
          builder: (context, state) => const _SplashScreen(),
        ),

        // Login Screen
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),

        // Signup Screen
        GoRoute(
          path: signup,
          name: 'signup',
          builder: (context, state) => const SignupScreen(),
        ),

        // Home Screen (Protected)
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
          redirect: (context, state) async {
            final isLoggedIn = await _isLoggedIn();
            if (!isLoggedIn) {
              return login;
            }
            return null; // No redirect needed
          },
        ),

        // TODO: Add chat, report, and other routes in future phases
      ],

      // Global redirect for authentication
      redirect: (context, state) async {
        final isLoggedIn = await _isLoggedIn();
        final isOnAuthPage =
            state.matchedLocation == login ||
            state.matchedLocation == signup ||
            state.matchedLocation == splash;

        // If not logged in and not on auth page, redirect to login
        if (!isLoggedIn && !isOnAuthPage) {
          return login;
        }

        // If logged in and on auth page, redirect to home
        if (isLoggedIn && isOnAuthPage && state.matchedLocation != splash) {
          return home;
        }

        return null; // No redirect needed
      },

      // Error builder
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(login),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple splash screen with loading indicator
class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Wait a bit for splash screen visibility
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Check authentication status and navigate
    final secureStorage = const FlutterSecureStorage();
    final isLoggedIn = await secureStorage.read(key: StorageKeys.isLoggedInKey);

    if (!mounted) return;

    if (isLoggedIn == 'true') {
      context.go(AppRouter.home);
    } else {
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics, size: 80, color: Color(0xFF3E5C76)),
            SizedBox(height: 24),
            Text(
              'ClueScraper',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B1B1B),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'AI-Powered Forensic Analysis',
              style: TextStyle(fontSize: 14, color: Color(0xFF2F2F2F)),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3E5C76)),
            ),
          ],
        ),
      ),
    );
  }
}
