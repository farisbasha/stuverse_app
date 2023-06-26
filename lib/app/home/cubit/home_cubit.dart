import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/core/models/product.dart';

import 'package:stuverse_app/app/core/models/product_category.dart';
import 'package:stuverse_app/app/home/services/api_endpoints.dart';
import 'package:stuverse_app/utils/api_client.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void fetchHomeData() async {
    emit(HomeLoading());

    try {
      final categoryResp = await dioClient.get(categoryAPIUrl);
      final List<ProductCategory> categoryList = [
        for (var category in categoryResp.data)
          ProductCategory.fromJson(category)
      ];
      final productResp = await dioClient.get(productAPIUrl);
      final List<Product> productList = [
        for (var product in productResp.data) Product.fromJson(product)
      ];
      emit(HomeLoaded(
        categoryList: categoryList,
        productList: productList,
      ));
    } on DioException catch (_) {
      emit(HomeError("Unable to fetch data. Please try again later."));
    } catch (e) {
      emit(HomeError("Oops! Something went wrong. Please try again later"));
    }
  }
}
