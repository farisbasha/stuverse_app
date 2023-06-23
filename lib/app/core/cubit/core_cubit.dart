import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeType { light, dark, system }

class CoreCubit extends Cubit<ThemeMode> {
  CoreCubit() : super(ThemeMode.system) {
    _loadThemeMode();
    _loadIsFirstTime();
  }

  bool _isFirstTime = true;

  bool get isFirstTime => _isFirstTime;

  Future<void> _loadIsFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (_isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }
    emit(state);
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeType = prefs.getString('themeModeType') ?? 'system';
    switch (themeModeType) {
      case 'light':
        emit(ThemeMode.light);
        break;
      case 'dark':
        emit(ThemeMode.dark);
        break;
      default:
        emit(ThemeMode.system);
        break;
    }
  }

  Future<void> setThemeMode(ThemeModeType themeModeType) async {
    final prefs = await SharedPreferences.getInstance();
    switch (themeModeType) {
      case ThemeModeType.light:
        emit(ThemeMode.light);
        await prefs.setString('themeModeType', 'light');
        break;
      case ThemeModeType.dark:
        emit(ThemeMode.dark);
        await prefs.setString('themeModeType', 'dark');
        break;
      default:
        emit(ThemeMode.system);
        await prefs.remove('themeModeType');
        break;
    }
  }

  void toggleThemeMode() {
    switch (state) {
      case ThemeMode.light:
        setThemeMode(ThemeModeType.dark);
        break;
      case ThemeMode.dark:
        setThemeMode(ThemeModeType.light);
        break;
      default:
        setThemeMode(ThemeModeType.dark);
        break;
    }
  }
}
