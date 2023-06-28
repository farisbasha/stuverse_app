import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:stuverse_app/app/auth/models/user.dart';
import 'package:stuverse_app/utils/app_images.dart';

import 'key_point_card.dart';

class KeyCarousel extends StatelessWidget {
  const KeyCarousel({
    super.key,
    required this.user,
    required this.theme,
  });

  final User user;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: [
          KeyPointCard(
            title: "Hi ${user.firstName}👋",
            imageUrl: AppImages.marketLottie,
            backgroundColor: theme.colorScheme.error,
            color: theme.colorScheme.onError,
            textColor: theme.colorScheme.background,
          ),
          KeyPointCard(
            title: "🔥The best place to find your needs",
            imageUrl: AppImages.educationLottie,
            backgroundColor: theme.colorScheme.tertiary,
            color: theme.colorScheme.onPrimary,
            textColor: theme.colorScheme.onPrimary,
          ),
          KeyPointCard(
            title: "👥Direct deals with the sellers🤝",
            imageUrl: AppImages.deliveryLottie,
            backgroundColor: theme.colorScheme.secondary,
            color: theme.colorScheme.inversePrimary,
            textColor: theme.colorScheme.onSecondary,
          ),
        ],
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.17,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(seconds: 2),
          autoPlayCurve: Curves.easeInOut,
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          viewportFraction: 0.76,
        ));
  }
}
