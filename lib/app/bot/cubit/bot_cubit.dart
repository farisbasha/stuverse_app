import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stuverse_app/utils/api_client.dart';

import '../models/bot_message.dart';
import '../services/api_endpoint.dart';

part 'bot_state.dart';

class BotCubit extends Cubit<BotState> {
  BotCubit() : super(BotInitial());

  void fetchBotMessages({required int userId}) async {
    emit(BotLoading());
    try {
      final resp = await dioClient
          .get(botGetMessagesAPIUrl.replaceFirst("<id>", userId.toString()));
      final List<BotMessage> messageList = [
        for (var message in resp.data) BotMessage.fromJson(message)
      ];
      emit(BotLoaded(
        messageList: messageList,
      ));
    } on DioException catch (e) {
      print(e.response ?? e.toString());
      emit(BotError("Unable to fetch data. Please try again later."));
    } catch (e) {
      emit(BotError("Oops! Something went wrong. Please try again later"));
    }
  }

  void sendMessageToBot({
    required String question,
    required int user,
  }) async {
    emit(BotLoading());
    try {
      final resp = await dioClient.post(botSendAPIUrl, data: {
        "question": question,
        "user": user,
      });
      print(resp.data);
      final listResp = await dioClient
          .get(botGetMessagesAPIUrl.replaceFirst("<id>", user.toString()));
      final List<BotMessage> messageList = [
        for (var message in listResp.data) BotMessage.fromJson(message)
      ];
      emit(BotLoaded(
        messageList: messageList,
      ));
    } on DioException catch (e) {
      print(e.response ?? e.toString());
      emit(BotError("Unable to fetch data. Please try again later."));
    } catch (e) {
      emit(BotError("Oops! Something went wrong. Please try again later"));
    }
  }
}
