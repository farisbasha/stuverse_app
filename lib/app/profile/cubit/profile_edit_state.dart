part of 'profile_edit_cubit.dart';

@immutable
abstract class ProfileEditState {}

class ProfileEditInitial extends ProfileEditState {}

class ProfileEditLoading extends ProfileEditState {}

class ProfileEditError extends ProfileEditState {
  final String message;

  ProfileEditError(this.message);
}

class ProfileEditSuccess extends ProfileEditState {
  final User user;

  ProfileEditSuccess({
    required this.user,
  });
}
