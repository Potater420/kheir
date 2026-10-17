import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/bloc/auth_session/auth_session_cubit.dart';

/// Temporary screen shown after login. The real home screen replaces it
/// in a later phase.
class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final name = context.select<AuthSessionCubit, String>(
      (cubit) => cubit.state.user?.fullName ?? '',
    );

    return BlocListener<AuthSessionCubit, AuthSessionState>(
      listenWhen: (previous, current) =>
          current.status == AuthSessionStatus.unauthenticated,
      listener: (context, state) => context.go(AppRoutes.login),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  l10n.homePlaceholderTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                if (name.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                ],
                const SizedBox(height: AppSpacing.s),
                Text(
                  l10n.homePlaceholderMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(),
                PrimaryButton(
                  label: l10n.logoutButton,
                  onPressed: () => context.read<AuthSessionCubit>().signOut(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
