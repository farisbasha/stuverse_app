import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/auth/auth.dart';
import 'package:stuverse_app/app/auth/cubit/auth_cubit.dart';
import 'package:stuverse_app/app/core/cubit/core_cubit.dart';
import 'package:stuverse_app/utils/common_utils.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            context.read<AuthCubit>().logout();
            CommonUtils.navigatePushReplacementAll(context, LoginScreen());
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
