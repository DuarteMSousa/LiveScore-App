import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  // static ColorScheme lightScheme() {
  //   return const ColorScheme(
  //     brightness: Brightness.light,
  //     primary: Color(4289003538),
  //     surfaceTint: Color(4290645018),
  //     onPrimary: Color(4294967295),
  //     primaryContainer: Color(4292815917),
  //     onPrimaryContainer: Color(4294967295),
  //     secondary: Color(4284309343),
  //     onSecondary: Color(4294967295),
  //     secondaryContainer: Color(4294967295),
  //     onSecondaryContainer: Color(4283914329),
  //     tertiary: Color(4278913803),
  //     onTertiary: Color(4294967295),
  //     tertiaryContainer: Color(4281084972),
  //     onTertiaryContainer: Color(4290427064),
  //     error: Color(4290386458),
  //     onError: Color(4294967295),
  //     errorContainer: Color(4294957782),
  //     onErrorContainer: Color(4282449922),
  //     surface: Color(4294834424),
  //     onSurface: Color(4280032027),
  //     onSurfaceVariant: Color(4284235837),
  //     outline: Color(4287721324),
  //     outlineVariant: Color(4293246393),
  //     shadow: Color(4278190080),
  //     scrim: Color(4278190080),
  //     inverseSurface: Color(4281413680),
  //     inversePrimary: Color(4294948012),
  //     primaryFixed: Color(4294957782),
  //     onPrimaryFixed: Color(4282449923),
  //     primaryFixedDim: Color(4294948012),
  //     onPrimaryFixedVariant: Color(4287823887),
  //     secondaryFixed: Color(4293059298),
  //     onSecondaryFixed: Color(4279901212),
  //     secondaryFixedDim: Color(4291217095),
  //     onSecondaryFixedVariant: Color(4282730311),
  //     tertiaryFixed: Color(4293255905),
  //     onTertiaryFixed: Color(4279966492),
  //     tertiaryFixedDim: Color(4291348165),
  //     onTertiaryFixedVariant: Color(4282861382),
  //     surfaceDim: Color(4292729304),
  //     surfaceBright: Color(4294834424),
  //     surfaceContainerLowest: Color(4294967295),
  //     surfaceContainerLow: Color(4294439922),
  //     surfaceContainer: Color(4294045164),
  //     surfaceContainerHigh: Color(4293650407),
  //     surfaceContainerHighest: Color(4293255905),
  //   );
  // }

  // ThemeData light() {
  //   return theme(lightScheme());
  // }

  static ColorScheme darkScheme() {
    return const ColorScheme(
        brightness: Brightness.dark,
        primary: Color.fromRGBO(229, 49, 49, 1),
        onPrimary: Color.fromRGBO(47, 47, 47, 1),
        secondary: Color.fromRGBO(31, 31, 31, 1),
        onSecondary: Color.fromRGBO(255, 255, 255, 1),
        error: Color.fromRGBO(255, 1, 1, 1),
        onError:  Color.fromRGBO(255, 255, 255, 1),
        surface: Color.fromRGBO(47, 47, 47, 1),
        onSurface: Color.fromRGBO(255, 255, 255, 1));
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
