import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/login/login_cubit.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_placeholder_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../di/injection_container.dart';
import '../l10n/generated/app_localizations.dart';

/// Every screen address in one place, so nobody types a path by hand.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
}

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => BlocProvider(
          create: (_) => LoginCubit(sl()),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        // Placeholder until the register screen is built in the next branch.
        builder: (context, state) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text(AppLocalizations.of(context).registerTitle),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePlaceholderScreen(),
      ),
    ],
  );
}
