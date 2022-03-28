import 'package:flutter/material.dart';


class PickerSelectionWidget extends StatelessWidget {
  const PickerSelectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 1,
            color: Colors.pink,
            width: 100,
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            height: 1,
            color: Colors.pink,
            width: 100,
          ),
        ],
      ),
    );
  }
}