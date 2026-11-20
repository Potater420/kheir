import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_spacing.dart';

/// A row of digit boxes, as designed in Figma. One invisible text field
/// does the typing, so paste, backspace and the one-time-code autofill work.
class OtpCodeField extends StatefulWidget {
  const OtpCodeField({
    required this.controller,
    required this.length,
    super.key,
    this.hasError = false,
    this.onCompleted,
  });

  final TextEditingController controller;
  final int length;
  final bool hasError;
  final ValueChanged<String>? onCompleted;

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: Listenable.merge([widget.controller, _focusNode]),
      builder: (context, _) {
        final text = widget.controller.text;
        final activeIndex = text.length.clamp(0, widget.length - 1);

        return Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(widget.length, (index) {
                final isActive = _focusNode.hasFocus && index == activeIndex;
                final borderColor = widget.hasError
                    ? scheme.error
                    : isActive
                        ? scheme.primary
                        : scheme.outlineVariant;
                return Container(
                  width: 56,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.m),
                    border: Border.all(
                      color: borderColor,
                      width: isActive ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    index < text.length ? text[index] : '',
                    style: theme.textTheme.headlineSmall,
                  ),
                );
              }),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0,
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  showCursor: false,
                  enableInteractiveSelection: false,
                  keyboardType: TextInputType.number,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(widget.length),
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  onChanged: (value) {
                    if (value.length == widget.length) {
                      widget.onCompleted?.call(value);
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}