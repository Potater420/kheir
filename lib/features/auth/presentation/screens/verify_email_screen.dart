import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/localized_messages.dart';
import '../../../../core/widgets/inline_notice.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_session/auth_session_cubit.dart';
import '../bloc/verify_code/verify_code_cubit.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/otp_code_field.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({required this.email, super.key});

  final String email;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _codeController = TextEditingController();
  Timer? _timer;
  int _secondsLeft = AppConfig.otpResendSeconds;
  bool _showIncomplete = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  /// Starts the resend countdown. Call it inside setState (or initState).
  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = AppConfig.otpResendSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) timer.cancel();
      setState(() => _secondsLeft = _secondsLeft <= 1 ? 0 : _secondsLeft - 1);
    });
  }

  String get _countdownText {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final code = _codeController.text;
    if (code.length != AppConfig.otpLength) {
      setState(() => _showIncomplete = true);
      return;
    }
    setState(() => _showIncomplete = false);
    unawaited(context.read<VerifyCodeCubit>().submit(code));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isBusy = context.select<VerifyCodeCubit, bool>(
      (cubit) => cubit.state.isBusy,
    );
    final isSubmitting = context.select<VerifyCodeCubit, bool>(
      (cubit) => cubit.state.isSubmitting,
    );

    return BlocListener<VerifyCodeCubit, VerifyCodeState>(
      listener: (context, state) {
        switch (state.status) {
          case VerifyCodeStatus.success:
            context.read<AuthSessionCubit>().signedIn(state.user!);
            context.go(AppRoutes.home);
          case VerifyCodeStatus.resent:
            _codeController.clear();
            setState(_startTimer);
          case VerifyCodeStatus.failure:
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(failureMessage(l10n, state.failure!))),
              );
          case VerifyCodeStatus.initial:
          case VerifyCodeStatus.submitting:
          case VerifyCodeStatus.resending:
            break;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AuthAppBar(title: l10n.verifyTitle),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.m,
                    AppSpacing.xl,
                    AppSpacing.l,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSpacing.xl),
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
                            LucideIcons.mail,
                            size: 48,
                            color: scheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.l),
                      Text(
                        l10n.verifyHeading,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.s),
                      Text(
                        l10n.verifyInstruction(
                          AppConfig.otpLength,
                          widget.email,
                        ),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      OtpCodeField(
                        controller: _codeController,
                        length: AppConfig.otpLength,
                        hasError: _showIncomplete,
                        onCompleted: (_) => _submit(),
                      ),
                      if (_showIncomplete) ...[
                        const SizedBox(height: AppSpacing.s),
                        Text(
                          l10n.verifyIncomplete,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.l),
                      Center(
                        child: _secondsLeft > 0
                            ? Text(
                                l10n.verifyResendIn(_countdownText),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              )
                            : TextButton(
                                onPressed: isBusy
                                    ? null
                                    : () => unawaited(
                                          context
                                              .read<VerifyCodeCubit>()
                                              .resend(),
                                        ),
                                child: Text(l10n.verifyResend),
                              ),
                      ),
                      const SizedBox(height: AppSpacing.m),
                      TextButton(
                        onPressed: context.pop,
                        child: Text(l10n.verifyChangeEmail),
                      ),
                      const SizedBox(height: AppSpacing.l),
                      InlineNotice(message: l10n.verifySecurityNotice),
                    ],
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
                  label: l10n.verifyConfirm,
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