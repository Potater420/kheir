import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/app_spacing.dart';

/// A form field with its label above it, as designed in Figma.
/// Set [isPassword] to get a show/hide toggle.
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    required this.controller,
    required this.icon,
    super.key,
    this.validator,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscured,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          validator: widget.validator,
          onFieldSubmitted: widget.onSubmitted,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            filled: true,
            fillColor: scheme.surface,
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: AppSpacing.m + 2,
                end: AppSpacing.s,
              ),
              child: Icon(
                widget.icon,
                size: 20,
                color: scheme.onSurfaceVariant,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () => setState(() => _obscured = !_obscured),
                    tooltip: _obscured ? l10n.showPassword : l10n.hidePassword,
                    icon: Icon(
                      _obscured ? LucideIcons.eye : LucideIcons.eyeOff,
                      size: 20,
                      color: scheme.onSurfaceVariant,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsetsDirectional.fromSTEB(
              0,
              AppSpacing.m + 2,
              AppSpacing.m + 2,
              AppSpacing.m + 2,
            ),
            errorMaxLines: 3,
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: scheme.error,
            ),
            border: border(scheme.outline),
            enabledBorder: border(scheme.outline),
            disabledBorder: border(scheme.outline),
            focusedBorder: border(scheme.primary, 1.5),
            errorBorder: border(scheme.error),
            focusedErrorBorder: border(scheme.error, 1.5),
          ),
        ),
      ],
    );
  }
}
