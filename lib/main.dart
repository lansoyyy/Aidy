import 'package:flutter/material.dart';

import 'utils/colors.dart';
import 'widgets/text_widget.dart';
import 'screens/home_screen.dart';
import 'screens/listen_screen.dart';
import 'screens/post_recording_screen.dart';
import 'screens/summary_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      routes: {
        '/': (context) => const HomeScreen(),
        '/listen': (context) => const ListenScreen(),
        '/post_recording': (context) => const PostRecordingScreen(),
        '/summary': (context) => const SummaryScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
