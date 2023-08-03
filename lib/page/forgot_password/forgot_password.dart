import 'dart:convert';

import 'package:channel_connect/network/Url_list.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/app_image.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formGlobalKey = GlobalKey<FormState>();
  bool loading = true;
  // late InAppWebViewController _webViewController;
  TextEditingController emailController = TextEditingController();
  String _responseMessage = "";
  Future<void> sendForgotPasswordRequest() async {
    final String apiUrl =
        "http://203.109.97.241:8080/ChannelController/PropertyDetails?req=reset";
    String email = emailController.text;
    Map<String, dynamic> requestBody = {
      "OTA_ResetPassword": {
        "Username": email,
      }
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final snackbar =
            SnackBar(content: Text('Mail sent to registered mail'));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Center(child: CircularProgressIndicator());
        Future.delayed(Duration(seconds: 2), () {
          Utility.pushToLogin(context);
        });
        print(response.body);
        print(response.statusCode);
        print('sent succesfully');
      } else {
        final snackbar = SnackBar(content: Text('Please enter a valid mail'));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        print(response.body);
        print(response.statusCode);
        print('Failed to send password reset request.');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _responseMessage = "An error occurred. Please try again later.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.mainColor,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(AppImages.loginHeader)],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    'FORGOT PASSWORD?',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                height: 0.8,
                color: AppColors.blackColor,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Please enter your registered e-mail id below and we will send you a link to reset your password',
              ),
              SizedBox(
                height: 10,
              ),
              const Text("Email ID"),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: formGlobalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !EmailValidator.validate(value, true)) {
                          return "Please Enter Valid Username";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        isDense: false,
                        suffixIcon: Icon(Icons.person),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.grey500, width: 1.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: MaterialButton(
                        onPressed: () {
                          if (formGlobalKey.currentState!.validate())
                            sendForgotPasswordRequest();
                        },
                        textColor: AppColors.whiteColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        height: 42,
                        minWidth: double.maxFinite,
                        color: AppColors.buttonColor,
                        child: Text("SEND EMAIL"),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Utility.pushToLogin(context);
                        },
                        child: Text(
                          "Back to login",
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
