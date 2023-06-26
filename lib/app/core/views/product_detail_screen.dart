import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stuverse_app/app/ads/views/boost_ad_screen.dart';
import 'package:stuverse_app/app/auth/cubit/auth_cubit.dart';
import 'package:stuverse_app/app/chat/cubit/chat_home_cubit.dart';
import 'package:stuverse_app/app/chat/views/chat_screen.dart';
import 'package:stuverse_app/app/core/cubit/main_page_cubit.dart';
import 'package:stuverse_app/app/core/views/main_page.dart';
import 'package:stuverse_app/app/core/views/product_add_edit_screen.dart';
import 'package:stuverse_app/utils/common_utils.dart';

import '../cubit/report/report_cubit.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthCubit>().state as AuthSuccess).user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          if (user.id == product.seller.id)
            IconButton(
              onPressed: () {
                CommonUtils.navigatePush(
                    context, ProductAddEditScreen(product: product));
              },
              icon: Icon(Icons.edit),
            )
          else
            FilledButton.icon(
                label: Text("Report",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.error),
                  padding: MaterialStateProperty.all(EdgeInsets.all(8)),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return BlocConsumer<ReportCubit, ReportState>(
                          listener: (context, state) {
                            if (state is ReportSuccess) {
                              CommonUtils.showSnackbar(context,
                                  message: "Reported successfully");
                              Navigator.of(context).pop();
                            }
                            if (state is ReportError) {
                              CommonUtils.showSnackbar(context,
                                  message: state.message, isError: true);
                              Navigator.of(context).pop();
                            }
                          },
                          builder: (context, state) {
                            return IgnorePointer(
                              ignoring: state is ReportLoading,
                              child: AlertDialog(
                                title: Text("Report"),
                                content: Text(
                                    "Are you sure you want to report this user?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel")),
                                  TextButton(
                                      onPressed: () {
                                        context.read<ReportCubit>().reportUser(
                                              reporter: (context
                                                      .read<AuthCubit>()
                                                      .state as AuthSuccess)
                                                  .user
                                                  .id,
                                              seller: product.seller.id,
                                            );
                                      },
                                      child: state is ReportLoading
                                          ? LoadingAnimationWidget.bouncingBall(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 20)
                                          : Text("Report")),
                                ],
                              ),
                            );
                          },
                        );
                      });
                },
                icon: Icon(
                  Icons.report,
                  size: 17,
                )),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: product.id,
                        child: Material(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image:
                                      CachedNetworkImageProvider(product.image),
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              product.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "₹ ${product.price}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: product.categories
                            .map((e) => Chip(
                                  label: Text(e.name),
                                ))
                            .toList(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        product.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Posted on",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              )),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        CommonUtils.formatRealisticDate(product.createdAt),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (product.seller.id != user.id)
                        Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.onInverseSurface,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: CachedNetworkImageProvider(
                                      product.seller.image),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.seller.firstName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        product.seller.city +
                                            ", " +
                                            product.seller.district,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Year Joined : " +
                                            CommonUtils.getYear(
                                                product.seller.dateJoined),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      if (product
                                          .seller.institutionName.isNotEmpty)
                                        Text(
                                          product.seller.institutionName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (user.id != product.seller.id)
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: BlocConsumer<ChatHomeCubit, ChatHomeState>(
                      listener: (context, state) {
                        if (state is ChatProductError) {
                          CommonUtils.showSnackbar(context,
                              message: state.message, isError: true);
                        }
                        if (state is ChatProductSuccess) {
                          context
                              .read<ChatHomeCubit>()
                              .getConversationList(userId: user.id);

                          CommonUtils.navigatePush(
                              context,
                              ChatScreen(
                                conversation: state.conversation,
                              ));
                        }
                      },
                      builder: (context, state) {
                        if (state is ChatProductLoading) {
                          return Center(
                            child: LoadingAnimationWidget.bouncingBall(
                                color: Theme.of(context).colorScheme.primary,
                                size: 20),
                          );
                        }
                        return FilledButton.icon(
                          icon: Icon(Icons.chat),
                          label: Text("Chat"),
                          onPressed: () {
                            context.read<ChatHomeCubit>().getConversation(
                                  product: product,
                                  userId: user.id,
                                );
                          },
                        );
                      },
                    ),
                  ),
                  if (product.seller.showContact)
                    SizedBox(
                      width: 10,
                    ),
                  if (product.seller.showContact)
                    Expanded(
                      child: FilledButton.icon(
                        icon: Icon(Icons.call),
                        label: Text("Call"),
                        onPressed: () {
                          CommonUtils.launchPhone(
                              context, product.seller.mobile);
                        },
                      ),
                    ),
                ],
              ),
            )
          else
            FilledButton.icon(
              icon: Icon(FontAwesomeIcons.moneyBill),
              label: Text("Boost Ad"),
              onPressed: () {
                CommonUtils.showDialogbox(context,
                    title: "Sorry",
                    subtitle: "Feature not available yet",
                    isError: true);

                // CommonUtils.navigatePush(
                //     context,
                //     BoostAdScreen(
                //       product: product,
                //     ));
              },
            ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
