import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';

/// Temporary Phase 0 screen that proves theme, fonts, RTL and localization
/// work together. Phase 1 replaces it with the real splash screen.
class HelloScreen extends StatelessWidget {
  const HelloScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.appName, style: text.displaySmall),
              const SizedBox(height: AppSpacing.s),
              Text(l10n.appTagline, style: text.titleLarge),
              const SizedBox(height: AppSpacing.xxl),
              Text(l10n.loginHeading, style: text.headlineSmall),
              const SizedBox(height: AppSpacing.s),
              Text(l10n.loginSubtitle, style: text.bodyLarge),
              const SizedBox(height: AppSpacing.l),
              Container(
                width: double.infinity,
                padding: const EdgeInsetsDirectional.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.m),
                ),
                child: Text(
                  l10n.privacyNotice,
                  style: text.bodySmall?.copyWith(
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {},
                  child: Text(l10n.loginButton),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.secondary,
                    foregroundColor: colors.onSecondary,
                  ),
                  onPressed: () {},
                  child: Text(l10n.createAccountAction),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}