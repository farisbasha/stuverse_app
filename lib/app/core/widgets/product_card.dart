import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stuverse_app/app/core/views/product_detail_screen.dart';
import 'package:stuverse_app/utils/common_utils.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Hero(
      tag: product.id,
      child: GestureDetector(
        onTap: () {
          CommonUtils.navigatePush(
              context, ProductDetailScreen(product: product));
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: theme.colorScheme.onInverseSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: product.isBoosted
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.onSurface.withOpacity(0.06),
              ),
              boxShadow: [
                BoxShadow(
                    color: theme.colorScheme.onSurface.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Center(
                      child: LoadingAnimationWidget.inkDrop(
                          color: theme.colorScheme.primary, size: 20),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "₹ ${product.price}",
                            style: theme.textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            product.title,
                            style: theme.textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${product.seller.city}, ${product.seller.district}",
                            style: theme.textTheme.labelSmall!.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (product.isBoosted)
                      Positioned(
                        top: -15,
                        left: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: theme.colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(8)),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 12,
                                color: theme.colorScheme.onTertiary,
                              ),
                              Text(
                                "Featured",
                                style: theme.textTheme.labelSmall!.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onTertiary),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
