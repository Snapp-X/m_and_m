import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme({Brightness brightness = Brightness.light}) {
  final baseTheme =
      (brightness == Brightness.light ? ThemeData.light() : ThemeData.dark())
          .textTheme;

  final textTheme = GoogleFonts.nunitoTextTheme(baseTheme).copyWith();

  return ThemeData(
    primarySwatch: Colors.blue,
    brightness: brightness,
    fontFamily: 'SfProDisplay',
    textTheme: textTheme.copyWith(
      headlineLarge: GoogleFonts.zillaSlab(
        fontSize: 100,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      displayMedium: textTheme.displayMedium?.merge(
        const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 48,
          vertical: 20,
        ),
        minimumSize: const Size(200, 100),
        textStyle: textTheme.bodyLarge?.copyWith(
          fontSize: 40,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    ),
  );
}
