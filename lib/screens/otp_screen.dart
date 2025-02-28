import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../services/otp_verifi.dart';
import 'otp_verifed.dart';


class OTPVerificationScreen extends StatefulWidget {
  final String mobileNumber;

  const OTPVerificationScreen({Key? key, required this.mobileNumber})
      : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isError = false;

  bool _isLoading = false;

  void _validateOTP() async {
    if (_otpController.text.isEmpty || _otpController.text.length < 4) {
      setState(() {
        _isError = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool isVerified =
        await OTPService.verifyOTP(widget.mobileNumber, _otpController.text);

    setState(() {
      _isLoading = false;
      _isError = !isVerified;
    });

    if (isVerified) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OTPVerifiedScreen()),
      );
    } else {
      //_showErrorDialog("Invalid OTP. Please try again.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
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

  void _clearOTP() {
    setState(() {
      _otpController.clear();
      _isError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.07),
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            Container(
              height: 2,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.03),
            Text(
              "OTP",
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            RichText(
              text: TextSpan(
                text: "You will shortly receive a message on ",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: widget.mobileNumber,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " with a code to proceed."),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.035),
            Center(
              child: Pinput(
                length: 4,
                controller: _otpController,
                defaultPinTheme: PinTheme(
                  width: screenWidth * 0.15,
                  height: screenWidth * 0.15,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: _isError ? Colors.red : Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onChanged: (value) {
                  if (_isError && value.length == 4) {
                    setState(() {
                      _isError = false;
                    });
                  }
                },
              ),
            ),
            if (_isError)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    "Please enter a valid OTP",
                    style: TextStyle(
                        color: Colors.red, fontSize: screenWidth * 0.035),
                  ),
                ),
              ),
            SizedBox(height: screenHeight * 0.015),
            Center(
              child: TextButton(
                onPressed: _clearOTP,
                child: Text(
                  "Clear",
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.07,
              child: OutlinedButton(
                 onPressed:   _validateOTP,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: (_isLoading)
                    ? CircularProgressIndicator(color: Colors.black)
                    : Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
            SizedBox(height: screenHeight * 0.025),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Resend voice OTP",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
