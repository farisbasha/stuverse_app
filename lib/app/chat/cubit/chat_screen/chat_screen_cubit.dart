import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:stuverse_app/utils/api_client.dart';

import '../../services/api_endpoints.dart';

part 'chat_screen_state.dart';

class ChatScreenCubit extends Cubit<ChatScreenState> {
  ChatScreenCubit() : super(ChatScreenInitial());

  void sendMessage({
    required int sender,
    required int convId,
    required String message,
  }) async {
    emit(ChatScreenLoading());
    try {
      await dioClient.post(sendMessageAPIUrl, data: {
        "sender": sender,
        "id": convId,
        "message": message,
      });
      emit(ChatScreenSuccess());
    } on DioException catch (e) {
      print(e.response?.data ?? e.message);
      emit(ChatScreenError("Something went wrong!"));
    } catch (e) {
      print(e.toString());
      emit(ChatScreenError("Something went wrong!"));
    }
  }
}
