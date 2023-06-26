part of 'ai_desc_cubit.dart';

@immutable
abstract class AiDescState {}

class AiDescInitial extends AiDescState {}

class AiDescLoading extends AiDescState {}

class AiDescError extends AiDescState {
  final String message;

  AiDescError(this.message);
}

class AiDescLoaded extends AiDescState {
  final String description;

  AiDescLoaded({
    required this.description,
  });
}
