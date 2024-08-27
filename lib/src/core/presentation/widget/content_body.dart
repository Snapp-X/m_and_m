import 'package:flutter/material.dart';

class ContentBody extends StatelessWidget {
  const ContentBody({
    super.key,
    required this.title,
    required this.description,
    this.buttonText,
    this.customWidget,
    this.onPressed,
    required this.lightColor,
    required this.darkColor,
  });

  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onPressed;

  final Widget? customWidget;

  final Color lightColor;
  final Color darkColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: darkColor,
              ),
        ),
        SizedBox(
          width: 860,
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: darkColor,
                  fontSize: 30,
                ),
          ),
        ),
        const SizedBox(height: 46),
        if (customWidget != null) ...[
          customWidget!,
          const SizedBox(height: 120),
        ],
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: darkColor,
            foregroundColor: lightColor,
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(buttonText ?? 'START'),
              const SizedBox(width: 16),
              const Icon(
                Icons.east_rounded,
                size: 48,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
