import 'package:channel_connect/page/forgot_password/forgot_password.dart';
import 'package:channel_connect/page/login/login_viewmodel.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/app_image.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formGlobalKey = GlobalKey<FormState>();

  bool isObsecure = true;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (_, model, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: AppColors.mainColor,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(AppImages.loginHeader)],
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView(
            shrinkWrap: true,
            //crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ))),
              Container(
                width: double.maxFinite,
                height: 0.8,
                color: AppColors.blackColor,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text("Username"),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: formGlobalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: model.usernameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Valid Username";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        isDense: false,
                        suffixIcon: Icon(Icons.person),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.grey500, width: 1.0),
                        ),
                        //hintText: "rucha.betigeri@avenues.info",
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text("Password"),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: model.passwordController,
                      obscureText: isObsecure,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Valid Password";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        isDense: false,
                        suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                isObsecure = !isObsecure;
                              });
                            },
                            child: Icon(isObsecure
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.grey500, width: 1.0),
                        ),
                        //hintText: "test@123",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                  child: TextButton(
                onPressed: () {
                  Utility.pushToNext(context, ForgotPasswordPage());
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      color: AppColors.grey500,
                      decoration: TextDecoration.underline),
                ),
              )),
              const SizedBox(
                height: 5,
              ),
              MaterialButton(
                onPressed: () {
                  if (formGlobalKey.currentState!.validate()) {
                    model.loginUser(context);
                  }
                },
                textColor: AppColors.whiteColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                height: 42,
                minWidth: double.maxFinite,
                color: AppColors.buttonColor,
                child: Text("LOGIN"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
