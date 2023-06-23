// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:stuverse_app/app/core/cubit/core_cubit.dart';
import 'package:stuverse_app/app/home/views/home_view.dart';

final selectedIndex = ValueNotifier<int>(0);

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeView(),
    ];

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
            ? const EdgeInsets.only(top: 10, bottom: 30, left: 20, right: 20)
            : EdgeInsets.all(8),
        child: GNav(
          gap: 3,
          tabBackgroundColor: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.all(16),
          onTabChange: (index) => selectedIndex.value = index,
          tabs: [
            GButton(
              icon: Icons.home,
              text: "Home",
              iconActiveColor: Theme.of(context).colorScheme.onPrimary,
              textColor: Theme.of(context).colorScheme.onPrimary,
            ),
            GButton(
              icon: Icons.search,
              text: "Search",
              iconActiveColor: Theme.of(context).colorScheme.onPrimary,
              textColor: Theme.of(context).colorScheme.onPrimary,
            ),
            GButton(
              icon: Icons.message,
              text: "Chat",
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
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: selectedIndex,
            builder: (context, value, _) {
              return pages[selectedIndex.value];
            }),
      ),
    );
  }
}
