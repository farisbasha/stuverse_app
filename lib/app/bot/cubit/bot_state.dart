part of 'bot_cubit.dart';

@immutable
abstract class BotState {}

class BotInitial extends BotState {}

class BotLoading extends BotState {}

class BotError extends BotState {
  final String message;

  BotError(this.message);
}

class BotLoaded extends BotState {
  final List<BotMessage> messageList;

  BotLoaded({
    required this.messageList,
  });
}
