import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/ads/services/api_endpoint.dart';
import 'package:stuverse_app/app/core/models/product.dart';
import 'package:stuverse_app/utils/api_client.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  AdsCubit() : super(AdsInitial());

  void getUserProductAds({
    required String userId,
  }) async {
    emit(AdsLoading());

    try {
      final productResp = await dioClient
          .get(userProductAdsAPIUrl.replaceFirst('<id>', userId));
      final List<Product> productList = [
        for (var product in productResp.data) Product.fromJson(product)
      ];
      emit(AdsLoaded(
        adsList: productList,
      ));
    } on DioException catch (e) {
      print(e.response ?? e.toString());
      emit(AdsError("Unable to fetch data. Please try again later."));
    } catch (e) {
      emit(AdsError("Oops! Something went wrong. Please try again later"));
    }
  }
}
