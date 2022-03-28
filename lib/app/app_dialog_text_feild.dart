import 'package:channel_connect/util/app_color.dart';
import 'package:flutter/material.dart';

class AppDialogTextFeild extends StatelessWidget {
  const AppDialogTextFeild({Key? key, required this.controller, this.errorText})
      : super(key: key);
  final TextEditingController controller;

  //final bool error;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          isDense: true,
          errorText:errorText,
          errorMaxLines: 2,
          errorStyle: TextStyle(fontSize: 10),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.mainColor, width: 1.5),
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.mainColor, width: 1.5),
              borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
