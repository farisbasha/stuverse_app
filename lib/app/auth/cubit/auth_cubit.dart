import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stuverse_app/utils/api_client.dart';
import 'package:stuverse_app/utils/secrets.dart';

import '../models/user.dart';
import '../services/api_endpoints.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void loginUser({required String email, required String password}) async {
    emit(AuthLoginLoading());
    try {
      final resp = await dioClient.post(
        loginApiUrl,
        data: {
          'username': email,
          'password': password,
        },
      );
      final user = User.fromJson(resp.data);
      emit(AuthSuccess(user));
      storeUserTokenOnDevice(user.token);
      setFcmToken(user: user);
    } on DioException catch (e) {
      final response = e.response;
      if (response == null) {
        print(e.toString());
        emit(AuthLoginFailure("Server Error"));
      } else {
        print(e.response?.data ?? "No data");
        if (response.data != null) {
          if (response.statusCode == 401) {
            emit(AuthLoginFailure(response.data['detail']));
            return;
          }
        }

        return emit(AuthLoginFailure("Invalid Credentials"));
      }
    } catch (e) {
      print(e.toString());
      emit(AuthLoginFailure("Client Error"));
    }
  }

  void sendResetPassLink({required String email}) async {
    emit(AuthResetPasswordLoading());
    try {
      await dioClient.post(
        resetPasswordApiUrl,
        data: {
          'email': email,
        },
      );
      emit(AuthResetPasswordSuccess());
    } on DioException catch (e) {
      final response = e.response;
      if (response == null) {
        print(e.toString());
        emit(AuthResetPasswordFailure("Server Error"));
      } else {
        if (response.data != null) {
          if (response.statusCode == 404) {
            emit(AuthResetPasswordFailure("User not found"));
            return;
          }
        }
        emit(AuthResetPasswordFailure("Unable to send reset link"));
      }
    } catch (e) {
      print(e.toString());
      emit(AuthResetPasswordFailure("Client Error"));
    }
  }

  void registerUser({
    required String firstName,
    required String email,
    required String password,
    required String mobile,
    required String city,
    required String district,
    required String institutionName,
    File? image,
  }) async {
    emit(AuthRegisterLoading());

    try {
      final formData = FormData.fromMap({
        'first_name': firstName,
        'email': email,
        'password': password,
        'mobile': mobile,
        'city': city,
        'district': district,
        'institution_name': institutionName,
      });
      if (image != null) {
        formData.files
            .add(MapEntry('image', await MultipartFile.fromFile(image.path)));
      }

      await dioClient.post(
        registerApiUrl,
        data: formData,
      );

      emit(AuthRegisterSuccess());
    } on DioException catch (e) {
      final response = e.response;
      if (response == null) {
        print(e.toString());
        emit(AuthRegisterFailure("Server Error"));
      } else {
        if (response.data != null) {
          if (response.statusCode == 400) {
            emit(AuthRegisterFailure("User already exists"));
            return;
          }
        }
        emit(AuthRegisterFailure("Unable to register user"));
      }
    } catch (e) {
      print(e.toString());
      emit(AuthRegisterFailure("Client Error"));
    }
  }

  void getUserDataUsingToken({
    required String token,
  }) async {
    emit(AuthUserLoading());

    try {
      final resp = await dioClient.get(profileApiUrl,
          options: Options(headers: {
            "Authorization": "Token $token",
          }));

      final userData = resp.data;
      userData["token"] = token;
      final user = User.fromJson(userData);
      emit(AuthSuccess(user));
      setFcmToken(user: user);
    } catch (_) {
      print("Unable to get user data using token");
      emit(AuthUserNotLoaded());
    }
  }

  void storeUserTokenOnDevice(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  void removeUserTokenFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }

  void logout() {
    removeUserTokenFromDevice();
    emit(AuthInitial());
  }

  void checkIfUserIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token != null) {
      getUserDataUsingToken(token: token);
    } else {
      emit(AuthUserNotLoaded());
    }
  }

  void updateAuthUser(User user) {
    emit(AuthSuccess(user));
  }

  void setFcmToken({
    required User user,
  }) async {
    try {
      String platform = 'android';
      if (kIsWeb) {
        platform = 'web';
      } else {
        if (Platform.isIOS) {
          // iOS-specific code
          platform = 'ios';
        }
      }

      String? fcmToken = await FirebaseMessaging.instance
          .getToken(vapidKey: kIsWeb ? vapidFcmKey : null);

      if (fcmToken == null) {
        print("FCM Token is null");
        return;
      }

      final resp = await dioClient.post(
        registerFCMAPI,
        data: {
          'name': user.username,
          'registration_id': fcmToken,
          'type': platform,
        },
        options: Options(
          headers: {
            'Authorization': 'Token ${user.token}',
          },
        ),
      );

      print(resp.data);
      print("FCM Token set successfully");
    } on DioException catch (e) {
      final response = e.response;
      if (response == null) {
        print(e.toString());
      } else {
        print(e.response!.data);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
