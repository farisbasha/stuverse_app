import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stuverse_app/app/auth/cubit/auth_cubit.dart';
import 'package:stuverse_app/app/auth/views/login_screen.dart';
import 'package:stuverse_app/app/core/views/main_page.dart';
import 'package:stuverse_app/app/core/widgets/svg_asset_image.dart';
import 'package:stuverse_app/utils/app_images.dart';
import 'package:stuverse_app/utils/common_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    context.read<AuthCubit>().checkIfUserIsLoggedIn();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          CommonUtils.navigatePushReplacement(context, const MainPage());
        } else if (state is AuthUserNotLoaded) {
          CommonUtils.navigatePushReplacement(context, const LoginScreen());
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgAssetImage(
                assetName: AppImages.splash,
                color: Theme.of(context).colorScheme.primary,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.fitWidth),
            const SizedBox(height: 40),
            Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Theme.of(context).colorScheme.onBackground,
                size: 40,
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
