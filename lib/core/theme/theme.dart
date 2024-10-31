import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class ThemedMaterialApp extends StatelessWidget {
  final Widget? home;
  const ThemedMaterialApp({super.key, this.home});

  static final _defaultLightColorScheme =
      ColorScheme.fromSeed(seedColor: Colors.blue);

  static final _defaultDarkColorScheme =
      ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          fontFamily: 'Nunito',
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          fontFamily: 'Nunito',
        ),
        themeMode: ThemeMode.dark,
        color: Theme.of(context).colorScheme.surface,
        home: home,
      );
    });
  }
}
