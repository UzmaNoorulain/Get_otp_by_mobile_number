import 'dart:convert';
import 'package:dio/dio.dart';

import '../utils/constant.dart';

class OTPService {
  static Future<bool> verifyOTP(String mobileNumber, String otp) async {
    try {
      final response = await DioClient.dio.get(
        '/api/v1/auth/verify-otp',
        queryParameters: {
          'mobile_no': mobileNumber,
          'otp': otp,
        },
      );

      print("Status Code: ${response.statusCode}, OTP: $otp");
      print("Response Body: ${response.data}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        if (data.containsKey("message")) {
          String message = data["message"];
          print("Message: $message");

          if (message == "OTP verified successfully") {
            return true;
          } else {
            throw Exception(message);
          }
        } else {
          throw Exception("Unexpected response format.");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      return false;
    }
  }
}
