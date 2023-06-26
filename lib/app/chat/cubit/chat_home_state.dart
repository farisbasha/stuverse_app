part of 'chat_home_cubit.dart';

@immutable
abstract class ChatHomeState {}

class ChatHomeInitial extends ChatHomeState {}

class ChatHomeLoading extends ChatHomeState {}

class ChatProductLoading extends ChatHomeState {}

class ChatProductError extends ChatHomeState {
  final String message;

  ChatProductError(this.message);
}

class ChatProductSuccess extends ChatHomeState {
  final Conversation conversation;

  ChatProductSuccess(this.conversation);
}

class ChatHomeError extends ChatHomeState {
  final String message;

  ChatHomeError(this.message);
}

class ChatHomeLoaded extends ChatHomeState {
  final List<Conversation> sendConversations;
  final List<Conversation> receiveConversations;

  ChatHomeLoaded({
    required this.sendConversations,
    required this.receiveConversations,
  });
}
