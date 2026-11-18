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
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_session/auth_session_cubit.dart';
import '../bloc/register/register_cubit.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/terms_checkbox.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    unawaited(
      context.read<RegisterCubit>().submit(
            fullName: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            phone: _phoneController.text,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isSubmitting = context.select<RegisterCubit, bool>(
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

    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.success) {
          // Firebase signs the new account in automatically, so the app
          // can go straight to the home screen.
          context.read<AuthSessionCubit>().signedIn(state.user!);
          context.go(AppRoutes.home);
        } else if (state.status == RegisterStatus.failure) {
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
              AuthAppBar(title: l10n.registerTitle),
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
                        Text(
                          l10n.registerSubtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AppTextField(
                          label: l10n.fullNameLabel,
                          controller: _nameController,
                          icon: LucideIcons.user,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                          validator: validatorFor(Validators.fullName),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        AppTextField(
                          label: l10n.phoneLabel,
                          controller: _phoneController,
                          icon: LucideIcons.phone,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          validator: validatorFor(Validators.phoneOptional),
                        ),
                        const SizedBox(height: AppSpacing.l),
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
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.newPassword],
                          validator: validatorFor(Validators.passwordStrong),
                        ),
                        const SizedBox(height: AppSpacing.s),
                        Text(
                          l10n.passwordRequirements,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        AppTextField(
                          label: l10n.confirmPasswordLabel,
                          controller: _confirmController,
                          icon: LucideIcons.lock,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.newPassword],
                          validator: validatorFor(
                            (value) => Validators.confirmPassword(
                              _passwordController.text,
                              value,
                            ),
                          ),
                          onSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        TermsCheckbox(
                          label: l10n.termsConsent,
                          validator: (accepted) {
                            final error = Validators.termsAccepted(
                              accepted: accepted ?? false,
                            );
                            return error == null
                                ? null
                                : validationMessage(l10n, error);
                          },
                        ),
                        const SizedBox(height: AppSpacing.m),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.haveAccountPrompt,
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => context.go(AppRoutes.login),
                              child: Text(l10n.loginAction),
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
                  label: l10n.registerButton,
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
