import 'package:channel_connect/model/response_status.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:flutter/material.dart';

class StatusDialogWidget extends StatelessWidget {
  const StatusDialogWidget({
    Key? key,
    required this.title,
    required this.name,
    required this.code,
    required this.statusList,
    required this.failedList,
  }) : super(key: key);
  final String name, code, title;
  final List<ResponseStatus> statusList;
  final List<ResponseStatus> failedList;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final count = statusList.length + failedList.length;
    double height =  0.0;
    if (count == 1) {
      height = 0.3;
    } else if (count == 2) {
      height = 0.35;
    } else if (count == 3) {
      height = 0.4;
    } else if (count == 4) {
      height = 0.45;
    } else if (count == 5) {
      height = 0.5;
    } else if (count == 6) {
      height = 0.55;
    } else if (count == 7) {
      height = 0.6;
    } else if (count == 8) {
      height = 0.65;
    }  else if (count == 9) {
      height = 0.7;
    } else {
      height = 0.8;
    }
    return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        content: Container(
          height: size.height * height,
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                color: AppColors.mainColor,
                child: Column(
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "$title",
                            style: TextStyle(
                                fontSize: 18, color: AppColors.whiteColor),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            //visualDensity: VisualDensity.compact,
                            color: AppColors.whiteColor,
                            icon: Icon(Icons.cancel))
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: AppColors.grey200,
                padding: const EdgeInsets.symmetric(vertical: 15),
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$name",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ListView(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(
                              //   height: 5,
                              // ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                    statusList.length,
                                    (index) => ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          //  dense: true,
                                          visualDensity: VisualDensity.compact,
                                          title: Text(
                                              statusList[index].channelName!),
                                          trailing: Icon(
                                            Icons.check_circle,
                                            color: AppColors.calenderGreenColor,
                                          ),
                                        )),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                    failedList.length,
                                    (index) => ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          //  dense: true,
                                          visualDensity: VisualDensity.compact,
                                          title: Text(
                                              "${failedList[index].channelName}"),
                                          trailing: Icon(
                                            Icons.cancel,
                                            color: AppColors.redAccent,
                                          ),
                                        )),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     TextButton(
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //         child: Text("ClOSE"))
              //   ],
              // )
            ],
          ),
        ));
  }
}
