import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/core/services/api_endpoint.dart';
import 'package:stuverse_app/utils/api_client.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());

  void reportUser({
    required int reporter,
    required int seller,
  }) async {
    emit(ReportLoading());

    try {
      await dioClient.post(reportUserAPIUrl, data: {
        "reporter": reporter,
        "reported_user": seller,
      });
      emit(ReportSuccess());
    } on DioException catch (e) {
      if (e.response != null) {
        if ((e.response?.statusCode ?? 403) == 400) {
          return emit(ReportError("You have already reported this user"));
        }
      }
      emit(ReportError("Oops! Something went wrong. Please try again later"));
    }
  }
}
