import 'dart:io';

import 'package:dio/dio.dart';

bool isDev = true;

final APIBASEURL = isDev
    ? Platform.isAndroid
        ? "http://10.0.2.2:8000/api/"
        : "http://127.0.0.1:8000/api/"
    : 'http://64.227.152.85:8000/api/';

final dioClient = Dio(BaseOptions(
  baseUrl: APIBASEURL,
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  },
));
