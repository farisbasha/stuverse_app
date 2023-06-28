import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/ads/cubit/ads_cubit.dart';
import 'package:stuverse_app/app/auth/cubit/auth_cubit.dart';
import 'package:stuverse_app/app/auth/models/user.dart';
import 'package:stuverse_app/app/core/widgets/product_card.dart';
import 'package:stuverse_app/utils/common_utils.dart';

class UserAdsView extends StatefulWidget {
  const UserAdsView({super.key});

  @override
  State<UserAdsView> createState() => _UserAdsViewState();
}

class _UserAdsViewState extends State<UserAdsView>
    with SingleTickerProviderStateMixin {
  late final User _user;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _user = (context.read<AuthCubit>().state as AuthSuccess).user;
    context.read<AdsCubit>().getUserProductAds(
          userId: _user.id.toString(),
        );

    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdsCubit, AdsState>(
      listener: (context, state) {
        if (state is AdsError) {
          CommonUtils.showSnackbar(context,
              message: state.message,
              isError: true,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: "Retry",
                onPressed: () {
                  context.read<AdsCubit>().getUserProductAds(
                        userId: _user.id.toString(),
                      );
                },
              ));
        }
      },
      builder: (context, state) {
        if (state is AdsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AdsLoaded) {
          final activeAds = state.adsList.where((ad) => ad.isActive).toList();
          final inactiveAds =
              state.adsList.where((ad) => !ad.isActive).toList();

          return SafeArea(
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Active Ads'),
                    Tab(text: 'Inactive Ads'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Display active ads
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: activeAds.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            final ad = activeAds[index];
                            return ProductCard(product: ad);
                          },
                        ),
                      ),

                      // Display inactive ads
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: inactiveAds.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            final ad = inactiveAds[index];
                            return ProductCard(product: ad);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(); // Placeholder for other states
        }
      },
    );
  }
}
