import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../services/otp_send.dart';
import 'otp_screen.dart';


class MobileNumberFieldScreen extends StatefulWidget {
  @override
  _MobileNumberFieldScreenState createState() =>
      _MobileNumberFieldScreenState();
}

class _MobileNumberFieldScreenState extends State<MobileNumberFieldScreen> {
  TextEditingController _mobileController = TextEditingController();
  bool _isError = false;
  bool _isValidNumber = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }
   Future<void> _sendOtpRequest() async {
  String mobileNumber = _mobileController.text.trim();

  setState(() {
    _isLoading = true;
  });

  try {
    String? otp = await ApiOtpService.sendOtp(mobileNumber);

    if (otp != null) {
      print("*************");
      print("Your OTP: $otp");

      // Show custom OTP notification from the top
      _showTopNotification("Your OTP: $otp");

      // Navigate to OTP Verification Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(mobileNumber: mobileNumber),
        ),
      );
    } else {
      _showErrorDialog("Failed to send OTP. Please try again.");
    }
  } catch (e) {
    print("Error: $e");
    _showErrorDialog("Something went wrong. Please check your internet connection.");
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

// Function to show a custom top notification
void _showTopNotification(String message) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50, // Adjust the position from the top
      left: MediaQuery.of(context).size.width * 0.1,
      right: MediaQuery.of(context).size.width * 0.1,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }


  void _validateAndProceed() {
    String mobileNumber = _mobileController.text.trim();
    if (mobileNumber.length == 10) {
      setState(() {
        _isError = false;
      });
      _sendOtpRequest();
    } else {
      setState(() {
        _isError = true;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.03),
            Text(
              "Enter your mobile number to get OTP",
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "Mobile Number",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isError ? Colors.red : Colors.grey.shade400,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    child: Text(
                      "+91",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(fontSize: screenWidth * 0.045),
                      decoration: InputDecoration(
                        hintText: "Enter mobile number",
                        counterText: "",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isError = false;
                          _isValidNumber = value.length == 10;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_isError)
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  "Please enter a valid 10-digit number",
                  style: TextStyle(
                      color: Colors.red, fontSize: screenWidth * 0.035),
                ),
              ),
            SizedBox(height: screenHeight * 0.08),
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.07,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _validateAndProceed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.black)
                    : Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: _isValidNumber ? Colors.black : Colors.grey.shade400,
                        ),
                      ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "By clicking, I accept the ",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: screenWidth * 0.035,
                  ),
                  children: [
                    TextSpan(
                      text: "terms of service ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "and ",
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextSpan(
                      text: "privacy policy",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
