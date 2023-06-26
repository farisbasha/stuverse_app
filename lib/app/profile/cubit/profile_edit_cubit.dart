import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/auth/models/user.dart';
import 'package:stuverse_app/app/profile/services/api_endpoints.dart';
import 'package:stuverse_app/utils/api_client.dart';

part 'profile_edit_state.dart';

class ProfileEditCubit extends Cubit<ProfileEditState> {
  ProfileEditCubit() : super(ProfileEditInitial());

  void updateUserProfile({
    required User user,
    required String firstName,
    required String email,
    required String mobile,
    required String city,
    required String district,
    required String institutionName,
    required bool showContact,
    File? image,
  }) async {
    emit(ProfileEditLoading());

    try {
      final formData = FormData.fromMap({
        'first_name': firstName,
        'email': email,
        'show_contact': showContact,
        'mobile': mobile,
        'city': city,
        'district': district,
        'institution_name': institutionName,
      });
      if (image != null) {
        formData.files
            .add(MapEntry('image', await MultipartFile.fromFile(image.path)));
      }

      final resp = await dioClient.patch(
        updateProfileAPIUrl,
        options: Options(
          headers: {
            'Authorization': 'Token ${user.token}',
          },
        ),
        data: formData,
      );
      final userData = resp.data;

      userData['token'] = user.token;

      emit(ProfileEditSuccess(user: User.fromJson(userData)));
    } on DioException catch (e) {
      final response = e.response;
      if (response == null) {
        print(e.toString());
        emit(ProfileEditError("Server Error"));
      } else {
        if (response.data != null) {
          if (response.statusCode == 400) {
            emit(ProfileEditError("User with that email already exists"));
            return;
          }
        }
        print(e.response);
        emit(ProfileEditError("Unable to update user"));
      }
    } catch (e) {
      print(e.toString());
      emit(ProfileEditError("Client Error"));
    }
  }
}
