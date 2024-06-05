import 'package:neumorphic_ui/neumorphic_ui.dart';

ThemeData buildTheme({Brightness brightness = Brightness.light}) {
  return ThemeData(
    primarySwatch: Colors.blue,
    brightness: brightness,
    fontFamily: 'SfProDisplay',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 100,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      displayMedium: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 48,
          vertical: 20,
        ),
        minimumSize: const Size(200, 100),
        textStyle: const TextStyle(
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
