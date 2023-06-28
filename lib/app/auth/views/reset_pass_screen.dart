import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/auth/cubit/auth_cubit.dart';
import 'package:stuverse_app/app/core/widgets/svg_asset_image.dart';
import 'package:stuverse_app/utils/app_images.dart';
import 'package:stuverse_app/utils/common_utils.dart';

class ResetPassScreen extends StatefulWidget {
  const ResetPassScreen({super.key});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  final _emailController = TextEditingController(text: "20ncs10@meaec.edu.in");

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Scaffold(
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
                    const Spacer(flex: 2),
                    Text(
                      'Reset password',
                      style: textTheme.headlineLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Enter your email address to reset your password',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Sign in?'),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 50,
                        child: FilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().sendResetPassLink(
                                  email: _emailController.text);
                            }
                          },
                          child: BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is AuthResetPasswordSuccess) {
                                CommonUtils.showSnackbar(
                                  context,
                                  message: 'Reset link sent to your email',
                                );
                                Navigator.pop(context);
                              } else if (state is AuthResetPasswordFailure) {
                                CommonUtils.showSnackbar(context,
                                    message: state.message, isError: true);
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthResetPasswordLoading) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                );
                              }
                              return Text(
                                'Send Link',
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
                        assetName: AppImages.forgot,
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
