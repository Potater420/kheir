import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

/// A checkbox with its text that takes part in a Form: validate() shows
/// the error under it when the box is not ticked.
class TermsCheckbox extends StatelessWidget {
  const TermsCheckbox({
    required this.label,
    required this.validator,
    super.key,
  });

  final String label;
  final String? Function(bool?) validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return FormField<bool>(
      initialValue: false,
      validator: validator,
      builder: (field) {
        final checked = field.value ?? false;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => field.didChange(!checked),
              borderRadius: BorderRadius.circular(AppRadius.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: checked,
                    onChanged: (value) => field.didChange(value ?? false),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                  ),
                ],
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
    );
  }
}
