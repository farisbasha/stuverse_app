import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stuverse_app/app/core/widgets/svg_asset_image.dart';
import 'package:stuverse_app/utils/app_images.dart';
import 'package:stuverse_app/utils/common_utils.dart';

import '../cubit/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController(text: "20ncs10@meaec.edu.in");
  final _passwordController = TextEditingController(text: "1234");
  final _firstNameController = TextEditingController(text: "Siddharth");
  final _mobileController = TextEditingController(text: "1234567890");
  final _cityController = TextEditingController(text: "Manjeri");
  final _districtController = TextEditingController(text: "Malappuram");
  final _institutionNameController =
      TextEditingController(text: "MEA Engineering College");
  final _formKey = GlobalKey<FormState>();
  bool isPassworHidden = true;

  File? _image;
  final _picker = ImagePicker();

  Future getImage({
    required ImageSource source,
  }) async {
    final pickedFile = await _picker.pickImage(
        source: source, imageQuality: 80, maxHeight: 400, maxWidth: 400);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthRegisterFailure) {
            CommonUtils.showSnackbar(context,
                message: state.message, isError: true);
          }
          if (state is AuthRegisterSuccess) {
            CommonUtils.navigatePop(context);
            CommonUtils.showDialogbox(context,
                title: "Registration Successful",
                subtitle: "Please activate your account from your email",
                isError: false);
          }
        },
        builder: (context, state) {
          return IgnorePointer(
            ignoring: state is AuthRegisterLoading,
            child: Form(
              key: _formKey,
              child: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 600),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Register',
                              style: textTheme.headlineLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Already have an account?',
                                  style: textTheme.bodyMedium,
                                ),
                                TextButton(
                                  onPressed: () {
                                    CommonUtils.navigatePop(context);
                                  },
                                  child: const Text('Sign In'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: Icon(Icons.camera_alt),
                                              title: Text("Camera"),
                                              onTap: () {
                                                getImage(
                                                    source: ImageSource.camera);
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.photo),
                                              title: Text("Gallery"),
                                              onTap: () {
                                                getImage(
                                                    source:
                                                        ImageSource.gallery);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor:
                                        theme.colorScheme.primaryContainer,
                                    backgroundImage: _image != null
                                        ? FileImage(_image!)
                                        : const AssetImage(
                                                AppImages.defaultUser)
                                            as ImageProvider,
                                    child: ClipOval(
                                      child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: theme
                                                  .colorScheme.background
                                                  .withOpacity(0.7),
                                            ),
                                            height: 20,
                                            width: double.infinity,
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: 15,
                                              color: theme
                                                  .colorScheme.onBackground,
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Name is required';
                                      }

                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.person),
                                      labelText: 'First Name',
                                      hintText: 'First name',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
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
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _mobileController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Mobile is required';
                                }
                                final mobileRegex = RegExp(r'^[0-9]{10}$');
                                if (!mobileRegex.hasMatch(value)) {
                                  return 'Invalid mobile number';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                labelText: 'Mobile',
                                hintText: 'Enter your mobile number',
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _cityController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'City is required';
                                      }

                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.location_city),
                                      labelText: 'City',
                                      hintText: 'Enter your city',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: TextFormField(
                                    controller: _districtController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'District is required';
                                      }

                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.location_city),
                                      labelText: 'District',
                                      hintText: 'Enter your District',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _institutionNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Institution Name is required';
                                }

                                return null;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.school),
                                labelText: 'Institution Name',
                                hintText: 'Enter your institution name',
                              ),
                            ),
                            const SizedBox(height: 14),
                            StatefulBuilder(
                                builder: (context, setPasswordVisibility) {
                              return TextFormField(
                                  controller: _passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Password is required';
                                    }

                                    return null;
                                  },
                                  obscureText: isPassworHidden,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.key),
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.visibility),
                                      onPressed: () {
                                        setPasswordVisibility(() {
                                          isPassworHidden = !isPassworHidden;
                                        });
                                      },
                                    ),
                                  ));
                            }),
                            const SizedBox(height: 14),
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 50,
                                child: FilledButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().registerUser(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          firstName: _firstNameController.text,
                                          mobile: _mobileController.text,
                                          city: _cityController.text,
                                          district: _districtController.text,
                                          institutionName:
                                              _institutionNameController.text,
                                          image: _image);
                                    }
                                  },
                                  child: state is AuthRegisterLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        )
                                      : Text(
                                          'Submit',
                                          style: textTheme.titleMedium!
                                              .copyWith(
                                                  color: theme
                                                      .colorScheme.onPrimary),
                                        ),
                                ),
                              ),
                            ),
                            SvgAssetImage(
                              height: 300,
                              width: 300,
                              assetName: AppImages.signup,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
