import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/main_screen.dart';
import 'package:frontend/provider/screen_state.dart';

void main() {
  runApp(const TailorCMS());
}

class TailorCMS extends StatelessWidget {
  const TailorCMS({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScreenState(),
      child: MaterialApp(
        title: 'Tailor CMS',
        theme: ThemeData(
          primaryColor: const Color(0xFF2D5B7A), // Main blue
          secondaryHeaderColor: const Color(0xFF4CAF50), // Green
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color(0xFF2196F3),
          ),
          fontFamily: 'Roboto',
        ),
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
