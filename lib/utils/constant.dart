import 'package:dio/dio.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://eccomerce-backend-i6av.onrender.com',
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(minutes: 30000),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
}