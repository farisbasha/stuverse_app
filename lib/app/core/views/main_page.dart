// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:stuverse_app/app/ads/views/user_ads_view.dart';
import 'package:stuverse_app/app/chat/views/chat_screen.dart';
import 'package:stuverse_app/app/chat/views/chat_view.dart';

import 'package:stuverse_app/app/core/cubit/core_cubit.dart';
import 'package:stuverse_app/app/home/views/home_view.dart';
import 'package:stuverse_app/app/profile/views/profile_view.dart';
import 'package:stuverse_app/utils/app_images.dart';

import '../cubit/main_page_cubit.dart';
import '../../bot/views/chat_bot_dialogue.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    context.read<MainPageCubit>().updateSelectedIndex(0);
    FirebaseMessaging.onMessage.listen((message) {
      print(message);
      if (message.notification != null) {
        if (!ChatScreen.isActive) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("You have a new message!"),
            ),
          );
        }
      }
    });
    super.initState();
  }

  final pages = [
    HomeView(),
    ChatView(),
    UserAdsView(),
    ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageCubit, int>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Stuverse"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.brightness_4),
                onPressed: () {
                  context.read<CoreCubit>().toggleThemeMode();
                },
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
            padding: Platform.isIOS
                ? const EdgeInsets.only(
                    top: 10, bottom: 30, left: 20, right: 20)
                : EdgeInsets.all(8),
            child: GNav(
              selectedIndex: state,
              gap: 3,
              tabBackgroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.all(16),
              onTabChange: (index) =>
                  context.read<MainPageCubit>().updateSelectedIndex(index),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                  iconActiveColor: Theme.of(context).colorScheme.onPrimary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),
                GButton(
                  icon: Icons.chat,
                  text: "Chat",
                  iconActiveColor: Theme.of(context).colorScheme.onPrimary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),
                GButton(
                  icon: Icons.ad_units,
                  text: "My Ads",
                  iconActiveColor: Theme.of(context).colorScheme.onPrimary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),
                GButton(
                  icon: Icons.person,
                  text: "Profile",
                  iconActiveColor: Theme.of(context).colorScheme.onPrimary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          ),
          body: SafeArea(child: pages[state]),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
            ),
            child: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
                onPressed: () {
                  showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        return ChatBotDialogue();
                      });
                },
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(AppImages.bot),
                      // Positioned(
                      //   top: -5,
                      //   right: -5,
                      //   child: Icon(
                      //     Icons.chat,
                      //     color: Theme.of(context).colorScheme.onError,
                      //     size: 20,
                      //   ),
                      // ),
                    ],
                  ),
                ))),
          ),
        );
      },
    );
  }
}
