import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/chat/services/api_endpoints.dart';
import 'package:stuverse_app/app/core/models/product.dart';
import 'package:stuverse_app/utils/api_client.dart';

import '../model/conversation.dart';

part 'chat_home_state.dart';

class ChatHomeCubit extends Cubit<ChatHomeState> {
  ChatHomeCubit() : super(ChatHomeInitial());

  void getConversationList({
    required int userId,
  }) async {
    emit(ChatHomeLoading());
    try {
      final senderResp =
          await dioClient.get("$conversationListAPIUrl?sender=$userId");
      final data = senderResp.data;

      final List<Conversation> sendConversations = [];
      final List<Conversation> receiveConversations = [];
      for (var item in data) {
        final conversation = Conversation.fromJson(item);

        sendConversations.add(conversation);
      }
      final recvResp =
          await dioClient.get("$conversationListAPIUrl?receiver=$userId");
      for (var item in recvResp.data) {
        final conversation = Conversation.fromJson(item);

        receiveConversations.add(conversation);
      }
      print("Send: $sendConversations");
      print("Recv: $receiveConversations");
      emit(ChatHomeLoaded(
        sendConversations: sendConversations,
        receiveConversations: receiveConversations,
      ));
    } on DioException catch (e) {
      print(e.response?.data ?? e.message);
      emit(ChatHomeError("Something went wrong!"));
    } catch (e) {
      print(e.toString());
      emit(ChatHomeError("Something went wrong!"));
    }
  }

  void getConversation({
    required int userId,
    required Product product,
  }) async {
    emit(ChatProductLoading());
    try {
      final resp = await dioClient.post(conversationGetAPIUrl, data: {
        "sender": userId,
        "receiver": product.seller.id,
        "product": product.id,
      });
      final data = resp.data;
      emit(ChatProductSuccess(Conversation.fromJson(data)));
    } on DioException catch (e) {
      print(e.response?.data ?? e.message);
      emit(ChatHomeError("Something went wrong!"));
    } catch (e) {
      print(e.toString());
      emit(ChatHomeError("Something went wrong!"));
    }
  }

  void readConversation({
    required int conversationId,
  }) async {
    try {
      await dioClient.post(
          conversationReadAPIUrl.replaceFirst(
              '<id>', conversationId.toString()),
          data: {
            "conversation": conversationId,
          });
    } on DioException catch (e) {
      print(e.response?.data ?? e.message);
    } catch (e) {
      print(e.toString());
    }
  }
}
