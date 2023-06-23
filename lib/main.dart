import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/auth/auth.dart';
import 'package:stuverse_app/app/core/cubit/core_cubit.dart';
import 'package:stuverse_app/app/core/views/splash_screen.dart';
import 'package:stuverse_app/utils/app_theme.dart';
import 'package:stuverse_app/bloc_providers.dart';

import 'bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  bootstrap(() => const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviderList,
      child: const MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.select((CoreCubit cubit) => cubit.state),
      home: const SplashScreen(),
    );
  }
}
