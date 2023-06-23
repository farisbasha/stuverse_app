part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthUserNotLoaded extends AuthState {}

class AuthUserLoading extends AuthState {}

class AuthLoginLoading extends AuthState {}

class AuthLoginFailure extends AuthState {
  final String message;

  AuthLoginFailure(this.message);
}

class AuthResetPasswordLoading extends AuthState {}

class AuthResetPasswordFailure extends AuthState {
  final String message;

  AuthResetPasswordFailure(this.message);
}

class AuthResetPasswordSuccess extends AuthState {}

class AuthRegisterLoading extends AuthState {}

class AuthRegisterFailure extends AuthState {
  final String message;

  AuthRegisterFailure(this.message);
}

class AuthRegisterSuccess extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);
}
