import 'package:flutter/material.dart';

import 'utils/colors.dart';

void main() {
  runApp(const BlindlyApp());
}

class BlindlyApp extends StatelessWidget {
  const BlindlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aidy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Regular',
        scaffoldBackgroundColor: background,
      ),
      initialRoute: '/',
      routes: {},
      debugShowCheckedModeBanner: false,
    );
  }
}
