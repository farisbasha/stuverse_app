part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}

class SearchLoaded extends SearchState {
  final List<Product> productList;

  SearchLoaded({
    required this.productList,
  });
}
