import 'package:dio/dio.dart';

import '../utils/constant.dart';

class ApiOtpService {
  static Future<String?> sendOtp(String mobileNumber) async {
    try {
      String url = "/api/v1/auth/otp/$mobileNumber";

      Response response = await DioClient.dio.get(url);

      if (response.statusCode == 200) {
        print("Response Data: ${response.data}");

        String otp = response.data["otp"];
        return otp;
      } else {
        print("Failed to send OTP: ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}