import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/core/services/api_endpoint.dart';
import 'package:stuverse_app/utils/api_client.dart';

part 'ai_desc_state.dart';

class AiDescCubit extends Cubit<AiDescState> {
  AiDescCubit() : super(AiDescInitial());
  double _temprature = 0.8;

  void generateDesc({
    String title = "",
    required String description,
  }) async {
    emit(AiDescLoading());

    try {
      _temprature = _temprature + 0.02;
      if (_temprature > 0.98) {
        _temprature = 0.8;
      }
      final resp = await dioClient.post(
        generateDescAPIUrl,
        data: {
          "name": title,
          "description": description,
          "temperature": _temprature,
        },
      );
      emit(AiDescLoaded(
          description:
              resp.data['result'].toString().replaceAll(RegExp(r'\s+'), ' ')));
    } on DioException catch (e) {
      print(e.toString());
      if (e.response != null) {
        print(e.response);
        emit(AiDescError("Oops! Something went wrong. Please try again later"));
      }
    } catch (e) {
      print(e.toString());
      emit(AiDescError("Oops! Something went wrong. Please try again later"));
    }
  }
}
