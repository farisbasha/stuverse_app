part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

class HomeLoaded extends HomeState {
  final List<ProductCategory> categoryList;
  final List<Product> productList;

  HomeLoaded({
    required this.categoryList,
    required this.productList,
  });
}
