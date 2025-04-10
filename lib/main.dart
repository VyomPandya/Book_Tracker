import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_tracker/screens/home_screen.dart';
import 'package:book_tracker/providers/book_provider.dart';
import 'package:book_tracker/providers/reading_goal_provider.dart';
import 'package:book_tracker/providers/theme_provider.dart';
import 'package:book_tracker/themes/app_theme.dart';
import 'package:book_tracker/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Create providers
  final themeProvider = ThemeProvider();
  final bookProvider = BookProvider();
  final readingGoalProvider = ReadingGoalProvider();
  
  // Initialize providers
  await bookProvider.init();
  await readingGoalProvider.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => bookProvider),
        ChangeNotifierProvider(create: (_) => readingGoalProvider),
      ],
      child: const BookTrackerApp(),
    ),
  );
}

class BookTrackerApp extends StatelessWidget {
  const BookTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Book Tracker',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
