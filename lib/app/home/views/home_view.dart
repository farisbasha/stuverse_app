import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:stuverse_app/app/auth/cubit/auth_cubit.dart';
import 'package:stuverse_app/app/core/widgets/product_card.dart';
import 'package:stuverse_app/app/search/views/search_screen.dart';

import 'package:stuverse_app/utils/common_utils.dart';

import '../cubit/home_cubit.dart';
import '../widgets/category_chip.dart';
import '../widgets/key_carousel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().fetchHomeData();
    });

    final theme = Theme.of(context);
    final user = (context.read<AuthCubit>().state as AuthSuccess).user;
    return SafeArea(
        child: RefreshIndicator(
      onRefresh: () async {
        context.read<HomeCubit>().fetchHomeData();
      },
      displacement: 10,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KeyCarousel(user: user, theme: theme),
            const SizedBox(height: 20),
            BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is HomeError) {
                  CommonUtils.showSnackbar(context,
                      message: state.message,
                      isError: true,
                      duration: const Duration(seconds: 5),
                      action: SnackBarAction(
                        label: "Retry",
                        onPressed: () {
                          context.read<HomeCubit>().fetchHomeData();
                        },
                      ));
                }
              },
              builder: (context, state) {
                if (state is HomeLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Categories",
                            style: theme.textTheme.headlineSmall!
                                .copyWith(fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(width: 15),
                            for (final category in state.categoryList)
                              CategoryChip(
                                category: category,
                                onPressed: () {
                                  CommonUtils.navigatePush(
                                      context,
                                      SearchScreen(
                                        selectedCategoryList: [category],
                                        categoryList: state.categoryList,
                                      ));
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          CommonUtils.navigatePush(
                              context,
                              SearchScreen(
                                categoryList: state.categoryList,
                              ));
                        },
                        child: Hero(
                          tag: "home_search",
                          child: Material(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  hintText: "Search for products",
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: FilledButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(0),
                                      ),
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                        (states) => theme.colorScheme.primary
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child:
                                        const Icon(Icons.filter_alt_outlined),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fillColor: theme.colorScheme.onInverseSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.productList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            final product = state.productList[index];
                            return ProductCard(product: product);
                          },
                        ),
                      ),
                    ],
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: Center(
                    child: LoadingAnimationWidget.inkDrop(
                        color: theme.colorScheme.primary, size: 30),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ));
  }
}
