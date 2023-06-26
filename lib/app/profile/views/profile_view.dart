// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stuverse_app/app/auth/auth.dart';
import 'package:stuverse_app/app/auth/cubit/auth_cubit.dart';
import 'package:stuverse_app/app/auth/models/user.dart';
import 'package:stuverse_app/app/core/views/product_add_edit_screen.dart';
import 'package:stuverse_app/utils/common_utils.dart';

import '../cubit/profile_edit_cubit.dart';
import 'profile_edit_screen.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    User user = (context.read<AuthCubit>().state as AuthSuccess).user;
    return BlocListener<ProfileEditCubit, ProfileEditState>(
      listener: (context, state) {
        if (state is ProfileEditSuccess) {
          setState(() {
            user = state.user;
          });
        }
      },
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: CachedNetworkImageProvider(user.image),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                user.firstName,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          Column(
            children: [
              ProfileTile(
                title: "My Profile",
                icon: Icons.person,
                onTap: () {
                  CommonUtils.navigatePush(context, ProfileEditScreen());
                },
              ),
              ProfileTile(
                title: "Add Product",
                icon: Icons.add,
                onTap: () {
                  CommonUtils.navigatePush(context, ProductAddEditScreen());
                },
              ),
              // ProfileTile(
              //   title: "Boost Product",
              //   icon: FontAwesomeIcons.moneyBill,
              //   onTap: () {
              //     CommonUtils.navigatePush(context, ProductAddEditScreen());
              //   },
              // ),
              ProfileTile(
                  title: "Logout",
                  icon: Icons.logout,
                  onTap: () {
                    CommonUtils.navigatePushReplacementAll(
                        context, LoginScreen());
                    context.read<AuthCubit>().logout();
                  }),
            ],
          )
        ]),
      )),
    );
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(title),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        tileColor: Theme.of(context).colorScheme.onInverseSurface,
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
        onTap: onTap,
      ),
    );
  }
}
