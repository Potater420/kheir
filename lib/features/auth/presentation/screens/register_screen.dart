import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/localized_messages.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/inline_notice.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/auth_app_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    // The email-code step and the API call are added in the register branch.
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    String? Function(String?) validatorFor(
      ValidationError? Function(String?) rule,
    ) {
      return (value) {
        final error = rule(value);
        return error == null ? null : validationMessage(l10n, error);
      };
    }

    return Scaffold(
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
                        textAlign: TextAlign.center,
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
                      InlineNotice(message: l10n.passwordRequirements),
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
                      const SizedBox(height: AppSpacing.m),
                      FormField<bool>(
                        initialValue: false,
                        validator: (accepted) {
                          final error = Validators.termsAccepted(
                            accepted: accepted ?? false,
                          );
                          return error == null
                              ? null
                              : validationMessage(l10n, error);
                        },
                        builder: (field) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: field.value ?? false,
                                onChanged: field.didChange,
                                title: Text(
                                  l10n.termsConsent,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              if (field.hasError)
                                Text(
                                  field.errorText!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.error,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.l),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.haveAccountPrompt,
                            style: theme.textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: context.pop,
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
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}