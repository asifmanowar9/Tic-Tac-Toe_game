import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/flame.dart';
import 'screens/main_menu_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    // Set preferred orientations (mobile only)
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Initialize Flame device settings (mobile only)
    await Flame.device.fullScreen();
    await Flame.device.setPortrait();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flame Tic Tac Toe',
      theme: AppTheme.getTheme(),
      debugShowCheckedModeBanner: false,
      home: const MainMenuScreen(),
    );
  }
}
