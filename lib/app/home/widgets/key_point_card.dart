import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stuverse_app/app/core/widgets/svg_asset_image.dart';

class KeyPointCard extends StatelessWidget {
  const KeyPointCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.backgroundColor,
    required this.color,
    required this.textColor,
  });

  final String title;
  final String imageUrl;
  final Color backgroundColor;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        height: MediaQuery.of(context).size.height * 0.17,
        width: double.infinity,
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                flex: 3,
                child: Lottie.asset(
                  imageUrl,
                ))
          ],
        ));
  }
}
