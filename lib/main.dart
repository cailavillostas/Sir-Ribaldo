import 'package:flutter/material.dart';
import 'home_page.dart';
void main() {
  runApp(MyApp());
}

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          title: 'Book Viewer',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.lightBlue, // LIGHT BLUE!
            useMaterial3: true,
            colorScheme: ColorScheme.light(
              primary: Colors.lightBlue,
              secondary: Colors.lightBlueAccent,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              secondary: Colors.blueAccent,
            ),
          ),
          themeMode: currentTheme,
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
