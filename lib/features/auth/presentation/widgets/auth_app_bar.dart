import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_spacing.dart';

/// The title bar of the auth screens. The back button only appears when
/// there is a screen to go back to.
class AuthAppBar extends StatelessWidget {
  const AuthAppBar({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        child: Row(
          children: [
            if (context.canPop())
              IconButton(
                onPressed: context.pop,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                icon: Icon(
                  isRtl ? LucideIcons.chevronRight : LucideIcons.chevronLeft,
                ),
              )
            else
              const SizedBox(width: AppSpacing.s),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
