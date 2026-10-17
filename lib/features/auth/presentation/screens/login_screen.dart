import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/localized_messages.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/inline_notice.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_session/auth_session_cubit.dart';
import '../bloc/login/login_cubit.dart';
import '../widgets/auth_app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    unawaited(
      context.read<LoginCubit>().submit(
            email: _emailController.text,
            password: _passwordController.text,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isSubmitting = context.select<LoginCubit, bool>(
      (cubit) => cubit.state.isSubmitting,
    );

    String? Function(String?) validatorFor(
      ValidationError? Function(String?) rule,
    ) {
      return (value) {
        final error = rule(value);
        return error == null ? null : validationMessage(l10n, error);
      };
    }

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          context.read<AuthSessionCubit>().signedIn(state.user!);
          context.go(AppRoutes.home);
        } else if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(failureMessage(l10n, state.failure!)),
              ),
            );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AuthAppBar(title: l10n.loginTitle),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.m,
                    AppSpacing.xl,
                    AppSpacing.l,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.xxl),
                        Center(
                          child: Container(
                            width: 104,
                            height: 104,
                            decoration: BoxDecoration(
                              color: scheme.primaryContainer,
                              borderRadius: BorderRadius.circular(
                                AppRadius.medallion,
                              ),
                            ),
                            child: Icon(
                              LucideIcons.heartHandshake,
                              size: 52,
                              color: scheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        Text(
                          l10n.loginHeading,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppSpacing.s),
                        Text(
                          l10n.loginSubtitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        AppTextField(
                          label: l10n.emailLabel,
                          controller: _emailController,
                          icon: LucideIcons.mail,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          validator: validatorFor(Validators.email),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        AppTextField(
                          label: l10n.passwordLabel,
                          controller: _passwordController,
                          icon: LucideIcons.lock,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          validator: validatorFor(Validators.passwordRequired),
                          onSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: AppSpacing.s),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.m,
                              ),
                            ),
                            // Wired up when the forgot-password phase is built.
                            onPressed: () {},
                            child: Text(l10n.forgotPassword),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s),
                        InlineNotice(message: l10n.privacyNotice),
                        const SizedBox(height: AppSpacing.l),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.noAccountPrompt,
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => context.push(AppRoutes.register),
                              child: Text(l10n.createAccountAction),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: scheme.surface,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.m,
                ),
                child: PrimaryButton(
                  label: l10n.loginButton,
                  isLoading: isSubmitting,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
