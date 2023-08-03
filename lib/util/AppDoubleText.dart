import 'package:channel_connect/util/app_color.dart';
import 'package:flutter/material.dart';

class AppDoubleTextWidget extends StatelessWidget {
  final String parameter;
  final String smallText;
  const AppDoubleTextWidget({
    Key? key,
    required this.parameter,
    required this.smallText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.33,
          child: Text(
            parameter,
            style:
                TextStyle(color: Color.fromARGB(164, 68, 67, 67), fontSize: 13),
          ),
        ),
        SizedBox(
          width: 50,
          // width: MediaQuery.of(context).size.width * 0.18,
        ),
        Container(
          child: Flexible(
            child: Column(
              children: [
                Text(
                  smallText,
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.mainColor,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
