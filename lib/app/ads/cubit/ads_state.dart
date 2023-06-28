part of 'ads_cubit.dart';

@immutable
abstract class AdsState {}

class AdsInitial extends AdsState {}

class AdsLoading extends AdsState {}

class AdsError extends AdsState {
  final String message;

  AdsError(this.message);
}

class AdsLoaded extends AdsState {
  final List<Product> adsList;

  AdsLoaded({
    required this.adsList,
  });
}
