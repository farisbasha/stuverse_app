import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stuverse_app/app/auth/cubit/auth_cubit.dart';
import 'package:stuverse_app/app/auth/models/user.dart';

import 'package:stuverse_app/utils/common_utils.dart';

import '../cubit/profile_edit_cubit.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late User _user;
  @override
  void initState() {
    super.initState();
    _user = (context.read<AuthCubit>().state as AuthSuccess).user;
    _emailController.text = _user.email;
    _firstNameController.text = _user.firstName;
    _mobileController.text = _user.mobile;
    _cityController.text = _user.city;
    _districtController.text = _user.district;
    _institutionNameController.text = _user.institutionName;
    _showContact = _user.showContact;
  }

  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _institutionNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _showContact = false;

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
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: BlocConsumer<ProfileEditCubit, ProfileEditState>(
        listener: (context, state) {
          if (state is ProfileEditError) {
            CommonUtils.showSnackbar(context,
                message: state.message, isError: true);
          }
          if (state is ProfileEditSuccess) {
            CommonUtils.navigatePop(context);
            CommonUtils.showSnackbar(
              context,
              message: "Profile Updated Successfully",
            );
            _user = state.user;
            context.read<AuthCubit>().updateAuthUser(state.user);
          }
        },
        builder: (context, state) {
          return IgnorePointer(
            ignoring: state is ProfileEditLoading,
            child: Form(
              key: _formKey,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const Text("Camera"),
                                          onTap: () {
                                            getImage(
                                                source: ImageSource.camera);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.photo),
                                          title: const Text("Gallery"),
                                          onTap: () {
                                            getImage(
                                                source: ImageSource.gallery);
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
                                    : NetworkImage(_user.image)
                                        as ImageProvider,
                                child: ClipOval(
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.background
                                              .withOpacity(0.7),
                                        ),
                                        height: 20,
                                        width: double.infinity,
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 15,
                                          color: theme.colorScheme.onBackground,
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
                        //A tick box to whether to show contact details or not
                        StatefulBuilder(builder: (context, setShowContact) {
                          return Row(
                            children: [
                              Checkbox(
                                value: _showContact,
                                onChanged: (value) {
                                  setShowContact(() {
                                    _showContact = value!;
                                  });
                                },
                              ),
                              const Expanded(
                                child: Text(
                                    "Tick this box to show your mobile number on product ads"),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 14),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 50,
                            child: FilledButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<ProfileEditCubit>()
                                      .updateUserProfile(
                                          user: _user,
                                          showContact: _showContact,
                                          email: _emailController.text,
                                          firstName: _firstNameController.text,
                                          mobile: _mobileController.text,
                                          city: _cityController.text,
                                          district: _districtController.text,
                                          institutionName:
                                              _institutionNameController.text,
                                          image: _image);
                                }
                              },
                              child: state is ProfileEditLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    )
                                  : Text(
                                      'Submit',
                                      style: textTheme.titleMedium!.copyWith(
                                          color: theme.colorScheme.onPrimary),
                                    ),
                            ),
                          ),
                        ),
                      ],
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
