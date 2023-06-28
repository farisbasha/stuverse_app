import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/core/services/api_endpoint.dart';
import 'package:stuverse_app/utils/api_client.dart';

part 'product_add_edit_state.dart';

class ProductAddEditCubit extends Cubit<ProductAddEditState> {
  ProductAddEditCubit() : super(ProductAddEditInitial());

  void addProduct({
    required String title,
    required String description,
    required String price,
    required File image,
    required List<int> categoryIds,
    required int sellerId,
    required bool isActive,
  }) async {
    emit(ProductAddEditLoading());
    try {
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'price': price,
        'image': await MultipartFile.fromFile(image.path),
        'categories': categoryIds,
        'seller': sellerId,
        'is_active': isActive,
      });
      await dioClient.post(
        productAddAPIUrl,
        data: formData,
      );
      emit(ProductAddEditSuccess());
    } on DioException catch (e) {
      print(e);
      if (e.response != null) {
        print(e.response);
      }
      emit(ProductAddEditError(
          "Oops! Something went wrong. Please try again later"));
    } catch (e) {
      print(e);
      emit(ProductAddEditError(
          "Client Error: Oops! Something went wrong. Please try again later"));
    }
  }

  void editProduct({
    required int id,
    required String title,
    required String description,
    required String price,
    File? image,
    required List<int> categoryIds,
    required int sellerId,
    required bool isActive,
  }) async {
    emit(ProductAddEditLoading());
    try {
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'price': price,
        'categories': categoryIds,
        'seller': sellerId,
        'is_active': isActive,
      });
      if (image != null) {
        formData.files
            .add(MapEntry('image', await MultipartFile.fromFile(image.path)));
      }

      await dioClient.patch(
        productEditDeleteAPIUrl.replaceFirst('<id>', id.toString()),
        data: formData,
      );
      emit(ProductAddEditSuccess());
    } on DioException catch (e) {
      print(e);
      if (e.response != null) {
        print(e.response);
      }
      emit(ProductAddEditError(
          "Oops! Something went wrong. Please try again later"));
    } catch (e) {
      print(e);
      emit(ProductAddEditError(
          "Client Error: Oops! Something went wrong. Please try again later"));
    }
  }
}
