import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/login/login_cubit.dart';
import '../../features/auth/presentation/bloc/register/register_cubit.dart';
import '../../features/auth/presentation/bloc/register/register_draft.dart';
import '../../features/auth/presentation/bloc/verify_code/verify_code_cubit.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/home/presentation/screens/home_placeholder_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../di/injection_container.dart';

/// Every screen address in one place, so nobody types a path by hand.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
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
        builder: (context, state) => BlocProvider(
          create: (_) => RegisterCubit(sl()),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        // Without the form data (for example after a restart) there is
        // nothing to verify, so go back to the form.
        redirect: (context, state) =>
            state.extra is RegisterDraft ? null : AppRoutes.register,
        builder: (context, state) {
          final draft = state.extra! as RegisterDraft;
          return BlocProvider(
            create: (_) => VerifyCodeCubit(
              draft: draft,
              registerUser: sl(),
              requestCode: sl(),
            ),
            child: VerifyEmailScreen(email: draft.email),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePlaceholderScreen(),
      ),
    ],
  );
}