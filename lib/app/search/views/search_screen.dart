import 'dart:async';

import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stuverse_app/app/core/models/product.dart';
import 'package:stuverse_app/app/core/models/product_category.dart';
import 'package:stuverse_app/app/core/widgets/product_card.dart';
import 'package:stuverse_app/app/core/widgets/svg_asset_image.dart';
import 'package:stuverse_app/utils/app_images.dart';
import 'package:stuverse_app/utils/common_utils.dart';

import '../cubit/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen(
      {super.key,
      required this.categoryList,
      this.selectedCategoryList = const []});
  final List<ProductCategory> categoryList;
  final List<ProductCategory> selectedCategoryList;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _debounceTimer;

  @override
  void initState() {
    _selectedCategoryList.addAll(widget.selectedCategoryList);
    print(_selectedCategoryList);
    if (_selectedCategoryList.isNotEmpty) {
      context.read<SearchCubit>().searchProduct(
          categoryList: _selectedCategoryList.map((e) => e.id).toList(),
          searchQuery: _searchController.text.trim());
    }

    super.initState();
  }

  void _performSearch() {
    final searchQuery = _searchController.text.trim();

    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final categoryIds = _selectedCategoryList.map((e) => e.id).toList();

      context.read<SearchCubit>().searchProduct(
            categoryList: categoryIds,
            searchQuery: searchQuery,
          );
    });
  }

  late List<ProductCategory> _selectedCategoryList = [];
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: "home_search",
          child: Material(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  _performSearch();
                },
                decoration: InputDecoration(
                  hintText: "Search for products",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      FilledButton(
                        child: const Icon(Icons.filter_alt_outlined),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                          const EdgeInsets.all(0),
                        )),
                        onPressed: () {
                          openFilterDialog();
                        },
                      ),
                      if (_selectedCategoryList.isNotEmpty)
                        Positioned(
                          top: -8,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              _selectedCategoryList.length.toString(),
                              style: theme.textTheme.bodyMedium!.copyWith(
                                  color: theme.colorScheme.onError,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  fillColor: theme.colorScheme.onInverseSurface,
                ),
              ),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          BlocConsumer<SearchCubit, SearchState>(
            listener: (context, state) {
              if (state is SearchError) {
                CommonUtils.showSnackbar(context,
                    message: state.message, isError: true);
              }
            },
            builder: (context, state) {
              if (state is SearchInitial) {
                return Column(
                  children: [
                    Center(
                        child: SvgAssetImage(
                      assetName: AppImages.search,
                      height: 200,
                      color: theme.colorScheme.primary,
                    )),
                    const SizedBox(height: 20),
                    Text(
                      "Find your products",
                      style: theme.textTheme.titleSmall,
                    ),
                  ],
                );
              }
              if (state is SearchLoaded) {
                if (state.productList.isEmpty) {
                  return Column(
                    children: [
                      Center(
                          child: SvgAssetImage(
                        assetName: AppImages.empty,
                        height: 200,
                        color: theme.colorScheme.primary,
                      )),
                      const SizedBox(height: 20),
                      Text(
                        "No products found",
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  );
                }

                return Expanded(
                    child: Padding(
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
                ));
              }
              return Center(
                  child: LoadingAnimationWidget.beat(
                      color: theme.colorScheme.primary, size: 30));
            },
          ),
        ],
      ),
    );
  }

  void openFilterDialog() async {
    await FilterListDialog.display<ProductCategory>(
      context,
      listData: widget.categoryList,
      selectedListData: _selectedCategoryList,
      choiceChipLabel: (category) => category!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (categry, query) {
        return categry.name.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          _selectedCategoryList = List.from(list!);
        });
        context.read<SearchCubit>().searchProduct(
            categoryList: _selectedCategoryList.map((e) => e.id).toList(),
            searchQuery: _searchController.text.trim());
        Navigator.pop(context);
      },
      themeData: FilterListThemeData(context,
          backgroundColor: Theme.of(context).colorScheme.surface,
          headerTheme: const HeaderThemeData(),
          controlButtonBarTheme: ControlButtonBarThemeData(
            context,
            backgroundColor: Theme.of(context).colorScheme.surface,
            controlButtonTheme: ControlButtonThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              primaryButtonBackgroundColor:
                  Theme.of(context).colorScheme.primary,
              primaryButtonTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          choiceChipTheme: ChoiceChipThemeData(
            selectedBackgroundColor:
                Theme.of(context).colorScheme.secondaryContainer,
            backgroundColor: Theme.of(context).colorScheme.background,
            selectedTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          )),
    );
  }
}
