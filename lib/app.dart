import 'package:flutter/material.dart';

import 'core/l10n/generated/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/presentation/screens/hello_screen.dart';

class KheirApp extends StatefulWidget {
  const KheirApp({super.key});

  @override
  State<KheirApp> createState() => _KheirAppState();
}

class _KheirAppState extends State<KheirApp> with WidgetsBindingObserver {
  late Locale _locale = _resolve(
    WidgetsBinding.instance.platformDispatcher.locale,
  );

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.light(_locale),
      home: const HelloScreen(),
    );
  }
}