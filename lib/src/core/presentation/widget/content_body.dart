import 'package:flutter/material.dart';

class ContentBody extends StatelessWidget {
  const ContentBody({
    super.key,
    required this.title,
    required this.description,
    this.buttonText,
    this.onPressed,
    required this.lightColor,
    required this.darkColor,
  });

  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onPressed;

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
        Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: darkColor,
              ),
        ),
        const SizedBox(height: 46),
        FilledButton(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 48,
              vertical: 20,
            ),
            backgroundColor: darkColor,
            foregroundColor: lightColor,
            minimumSize: const Size(200, 100),
            textStyle: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
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
