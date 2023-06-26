import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:stuverse_app/app/core/models/product.dart';
import 'package:stuverse_app/utils/api_client.dart';

import '../services/api_endpoints.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  void searchProduct({
    String searchQuery = "",
    List<int> categoryList = const [],
  }) async {
    emit(SearchLoading());

    try {
      final Map<String, dynamic> queryParameters = {};
      if (searchQuery.isNotEmpty) {
        queryParameters['search'] = searchQuery;
      }
      if (categoryList.isNotEmpty) {
        queryParameters['categories'] = categoryList;
      }

      final productResp = await dioClient.get(productFilterAPIUrl,
          queryParameters: queryParameters);
      final List<Product> filteredList = [
        for (var product in productResp.data) Product.fromJson(product)
      ];
      emit(SearchLoaded(productList: filteredList));
    } on DioException catch (e) {
      print(e.response);
      emit(SearchError("Unable to fetch data. Please try again later."));
    } catch (e) {
      emit(SearchError("Oops! Something went wrong. Please try again later"));
    }
  }
}
