import 'package:dio/dio.dart';

const APIBASEURL = 'http://127.0.0.1:8000/api';

final dioClient = Dio(BaseOptions(
  baseUrl: APIBASEURL,
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  },
));
