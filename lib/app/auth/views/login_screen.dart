import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/auth/views/register_screen.dart';
import 'package:stuverse_app/app/core/cubit/core_cubit.dart';
import 'package:stuverse_app/app/core/views/main_page.dart';
import 'package:stuverse_app/app/core/widgets/svg_asset_image.dart';
import 'package:stuverse_app/utils/app_images.dart';
import 'package:stuverse_app/utils/common_utils.dart';

import '../cubit/auth_cubit.dart';
import 'reset_pass_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: "20ncs10@meaec.edu.in");
  final _passwordController = TextEditingController(text: "1234");
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_4),
            onPressed: () {
              context.read<CoreCubit>().toggleThemeMode();
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 600),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Sign In',
                      style: textTheme.headlineLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'No account?',
                          style: textTheme.bodyLarge,
                        ),
                        TextButton(
                          onPressed: () {
                            CommonUtils.navigatePush(
                                context, const RegisterScreen());
                          },
                          child: const Text('Make account'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        }
                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        labelText: 'Email',
                        hintText: 'Enter your email address',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }

                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.key),
                        labelText: 'Password',
                        hintText: 'Enter your password',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        CommonUtils.navigatePush(
                            context, const ResetPassScreen());
                      },
                      child: const Text('Reset Password?'),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 50,
                        child: FilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().loginUser(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                            }
                          },
                          child: BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is AuthSuccess) {
                                CommonUtils.showSnackbar(context,
                                    message: "Login Successful");
                                CommonUtils.navigatePushReplacement(
                                    context, const MainPage());
                              }
                              if (state is AuthLoginFailure) {
                                CommonUtils.showSnackbar(context,
                                    message: state.message, isError: true);
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthLoginLoading) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                );
                              }
                              return Text(
                                'Sign In',
                                style: textTheme.titleMedium!.copyWith(
                                    color: theme.colorScheme.onPrimary),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 10,
                      child: SvgAssetImage(
                        assetName: AppImages.deliveries,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
