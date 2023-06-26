part of 'product_add_edit_cubit.dart';

@immutable
abstract class ProductAddEditState {}

class ProductAddEditInitial extends ProductAddEditState {}

class ProductAddEditLoading extends ProductAddEditState {}

class ProductAddEditError extends ProductAddEditState {
  final String message;

  ProductAddEditError(this.message);
}

class ProductAddEditSuccess extends ProductAddEditState {}
