import 'package:channel_connect/page/home/component/pickerSelectionWidget.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home_view.dart';

class SelectYearMonthDialog extends StatefulWidget {
  const SelectYearMonthDialog({
    Key? key,
    // required this.selectedDateTime,
  }) : super(key: key);
  //final Function(DateTime) selectedDateTime;

  @override
  State<SelectYearMonthDialog> createState() => _SelectYearMonthDialogState();
}

class _SelectYearMonthDialogState extends State<SelectYearMonthDialog> {
  // int selectedYear = 0;
   int selectedMonth = 0;

  // List<String> monthList = Utility.getMonthList();
  // List<int> yearList = Utility.yearList();
  List<DateTime> monthList = [];

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
     final now = DateTime.now();
    for (var i = 0; i < 12; i++) {
      final date = DateTime(now.year, now.month + i, now.day);
      monthList.add(date);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Select Month",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          width: double.maxFinite,
          height: 200,
          child: Stack(
            children: [
              CupertinoPicker(
                backgroundColor: Colors.white,
                squeeze: 0.8,
                //offAxisFraction: 5.0,
                // diameterRatio: 0.5,
                itemExtent: 30,
                magnification: 1.0,
                useMagnifier: false,

                looping: true,
                selectionOverlay: Container(),
                //magnification: 1.5,
                scrollController: FixedExtentScrollController(initialItem: 0),

                children: List.generate(
                    monthList.length,
                    (index) => Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(Utility.getMonthName(
                              monthList[index]
                                  .month)),
                        )),
                onSelectedItemChanged: (value) {
                  setState(() {
                    selectedMonth = value;
                    // _selectedValue = value;
                  });
                },
              ),
              PickerSelectionWidget()
            ],
          ),
        ),
        Container(
          // padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("CANCEL")),
              TextButton(
                  onPressed: () {
                    print(
                        "selected month $selectedMonth");
                    Navigator.pop(context,
                        DateTime(monthList[selectedMonth].year, monthList[selectedMonth].month, 1));
                  },
                  child: Text("OK")),
            ],
          ),
        )
      ],
    );
  }
}
