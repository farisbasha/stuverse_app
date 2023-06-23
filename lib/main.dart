import 'package:flutter/material.dart';
import 'package:stuverse_app/app/auth/auth.dart';
import 'package:stuverse_app/utils/app_theme.dart';
import 'package:stuverse_app/utils/common_utils.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const LoginScreen(),
    );
  }
}
