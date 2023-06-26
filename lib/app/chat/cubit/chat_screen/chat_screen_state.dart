part of 'chat_screen_cubit.dart';

@immutable
abstract class ChatScreenState {}

class ChatScreenInitial extends ChatScreenState {}

class ChatScreenLoading extends ChatScreenState {}

class ChatScreenError extends ChatScreenState {
  final String message;

  ChatScreenError(this.message);
}

class ChatScreenSuccess extends ChatScreenState {}
