import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection_container.dart';
import 'core/l10n/generated/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_session/auth_session_cubit.dart';

class KheirApp extends StatefulWidget {
  const KheirApp({super.key});

  @override
  State<KheirApp> createState() => _KheirAppState();
}

class _KheirAppState extends State<KheirApp> with WidgetsBindingObserver {
  late Locale _locale = _resolve(
    WidgetsBinding.instance.platformDispatcher.locale,
  );

  /// Created once. A new router on every rebuild would reset navigation.
  final GoRouter _router = createRouter();

  /// English is the default. Arabic is used when the device language is Arabic.
  static Locale _resolve(Locale device) {
    final isSupported = AppLocalizations.supportedLocales.any(
      (locale) => locale.languageCode == device.languageCode,
    );
    return isSupported ? Locale(device.languageCode) : const Locale('en');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _router.dispose();
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    setState(() {
      _locale = _resolve(WidgetsBinding.instance.platformDispatcher.locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthSessionCubit(
        getCurrentUser: sl(),
        logoutUser: sl(),
      ),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        locale: _locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: AppTheme.light(_locale),
        routerConfig: _router,
      ),
    );
  }
}
