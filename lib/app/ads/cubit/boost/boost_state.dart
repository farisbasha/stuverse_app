part of 'boost_cubit.dart';

@immutable
abstract class BoostState {}

class BoostInitial extends BoostState {}

class BoostLoading extends BoostState {}

class BoostError extends BoostState {
  final String message;

  BoostError(this.message);
}

class BoostSuccess extends BoostState {}
