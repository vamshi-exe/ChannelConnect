import 'dart:ui';

import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/model/report_response_data.dart';
import 'package:channel_connect/page/report/report_viewmodel.dart';
import 'package:channel_connect/page/report_details/report_details_page.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/app_image.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class ReportView extends StatefulWidget {
  const ReportView({Key? key}) : super(key: key);

  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  _showSearchBottomSheet(BuildContext context, ReportViewModel model) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => ReportSearchWidget(
            type: model.selectedType,
            fromDate: model.selectedFromDate,
            toDate: model.selectedToDate,
            guestName: model.selectedGuestName,
            bookingNo: model.selectedBookingNo,
            onResetClicked: () {
              Navigator.pop(context);
              model.resetClicked();
            },
            onApplyClicked: (String type, DateTime from, DateTime to,
                String guest, String booking) {
              Navigator.pop(context);
              model.applyClicked(type, from, to, guest, booking);
            }));
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<AppRepo>(context, listen: false);
    return ViewModelBuilder<ReportViewModel>.reactive(
      viewModelBuilder: () => ReportViewModel(),
      onModelReady: (model) => model.intiData(context, repo),
      builder: (context, model, child) => Container(
          child: (!model.loading)
              ? (!model.error)
                  ? Column(
                      children: [
                        Container(
                          width: double.maxFinite,
                          color: AppColors.mainColor.withOpacity(0.8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Booking Report",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      model.getFromToDateFormatedText(
                                          model.selectedFromDate == null
                                              ? model.defaultStartDate
                                              : model.selectedFromDate!,
                                          model.selectedToDate == null
                                              ? model.defaultEndDate
                                              : model.selectedToDate!),
                                      // "",

                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.whiteColor),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    _showSearchBottomSheet(context, model);
                                  },
                                  child: Icon(
                                    Icons.search,
                                    color: AppColors.whiteColor,
                                  ))
                            ],
                          ),
                        ),
                        Expanded(
                          child: (model.reportList.isNotEmpty)
                              ? Scrollbar(
                                  child: ListView.separated(
                                    itemCount: model.reportList.length,
                                    separatorBuilder: (context, index) =>
                                        Container(
                                      height: 1,
                                      color: AppColors.grey500,
                                    ),
                                    itemBuilder: (_, index) {
                                      return ReportRowWidget(
                                        report: model.reportList[index],
                                        onItemClicked: () {
                                          Utility.pushToNext(
                                              context,
                                              ReportDetailsPage(
                                                booking:
                                                    model.reportList[index],
                                              ));
                                        },
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      "No Bookings available for selected criteria",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              SOMETHING_WRONG_TEXT,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  model.intiData(context, repo);
                                },
                                child: Text("Retry"))
                          ],
                        ),
                      ),
                    )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}

class ReportSearchWidget extends StatefulWidget {
  const ReportSearchWidget({
    Key? key,
    required this.type,
    required this.guestName,
    required this.bookingNo,
    required this.fromDate,
    required this.toDate,
    required this.onResetClicked,
    required this.onApplyClicked,
  }) : super(key: key);

  final String? type, guestName, bookingNo;
  final DateTime? fromDate, toDate;
  final Function() onResetClicked;
  final Function(String, DateTime, DateTime, String, String) onApplyClicked;

  @override
  State<ReportSearchWidget> createState() => _ReportSearchWidgetState();
}

class _ReportSearchWidgetState extends State<ReportSearchWidget> {
  final _dateFromController = TextEditingController();
  final _dateToController = TextEditingController();
  final _bookingNoController = TextEditingController();
  final _guestNameController = TextEditingController();
  final _bookingCheckInDropDownList = ["Booking Date", "Check In Date"];

  String _selectedBookingSlot = "Booking Date";
  int _selectedType = 1;
  DateTime? fromDateTime, toDateTime;
  bool _fromDateError = false;
  bool _toDateError = false;

  @override
  void initState() {
    _selectedBookingSlot = widget.type!;
    if (widget.type != null) {
      _selectedType = widget.type == "Booking Date" ? 1 : 2;
    }
    fromDateTime = widget.fromDate;
    toDateTime = widget.toDate;
    _guestNameController.text = widget.guestName ?? "";
    _bookingNoController.text = widget.bookingNo ?? "";
    if (widget.fromDate != null) {
      _dateFromController.text = Utility.formattedDeviceDate(widget.fromDate!);
      _dateToController.text = Utility.formattedDeviceDate(widget.toDate!);
    }
    super.initState();
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    DateTime? dateTime = DateTime.now();
    if (isFrom) {
      dateTime = fromDateTime;
    } else {
      dateTime = toDateTime;
    }
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (!isFrom)? dateTime ?? fromDateTime!:dateTime??DateTime.now(),
        firstDate: (!isFrom) ? fromDateTime! : DateTime(2010, 1),
        lastDate: (_selectedType == 2)
            ? DateTime(DateTime.now().year + 5)
            : DateTime.now());
    if (picked != null && picked != dateTime) {
      if (isFrom) {
        fromDateTime = picked;
        _dateFromController.text = Utility.formattedDeviceDate(picked);
        toDateTime = null;
        _dateToController.text = "";
        setState(() {});
       // _selectDate(context, false);
      } else {
        toDateTime = picked;
        _dateToController.text = Utility.formattedDeviceDate(picked);
        setState(() {});
      }
      //setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top + 25;
    return Container(
      height: MediaQuery.of(context).size.height * 0.93,
      padding: MediaQuery.of(context).viewInsets,
      // color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: AppColors.mainColor,
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Text(
                    "Search Option",
                    style: TextStyle(fontSize: 18, color: AppColors.whiteColor),
                  ),
                )),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                  color: AppColors.whiteColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              //shrinkWrap: true,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                    visualDensity: VisualDensity.compact,
                                    //contentPadding: const EdgeInsets.all(0),
                                    value: 1,
                                    groupValue: _selectedType,
                                    onChanged: (int? value) {
                                      setState(() {
                                        _selectedType = value!;
                                        fromDateTime = null;
                                        toDateTime = null;
                                        _dateFromController.text = "";
                                        _dateToController.text = "";
                                      });
                                    },
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedType = 1;
                                            fromDateTime = null;
                                        toDateTime = null;
                                        _dateFromController.text = "";
                                        _dateToController.text = "";
                                        });
                                      },
                                      child: Text("Booking Date",
                                          style: TextStyle(
                                              color: AppColors.blackText,
                                              fontSize: 14))),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                    //dense: true,
                                    visualDensity: VisualDensity.compact,
                                    // contentPadding: const EdgeInsets.all(0),
                                    value: 2,
                                    groupValue: _selectedType,
                                    onChanged: (int? value) {
                                      setState(() {
                                        _selectedType = value!;
                                          fromDateTime = null;
                                        toDateTime = null;
                                        _dateFromController.text = "";
                                        _dateToController.text = "";
                                      });
                                    },
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedType = 2;
                                            fromDateTime = null;
                                        toDateTime = null;
                                        _dateFromController.text = "";
                                        _dateToController.text = "";
                                        });
                                      },
                                      child: Text(
                                        "Check-in Date",
                                        style: TextStyle(
                                            color: AppColors.blackText,
                                            fontSize: 14),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                                //  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      _selectDate(context, true);
                                    },
                                    child: TextField(
                                      controller: _dateFromController,
                                      //  textAlign: TextAlign.center,
                                      enabled: false,
                                      style: TextStyle(fontSize: 13),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 0),
                                        hintText: "From Date",
                                        // errorText: _fromDateError
                                        //     ? "Please Select valid Date"
                                        //     : null,
                                        errorStyle: TextStyle(
                                            fontSize: 9,
                                            color: AppColors.redAccent),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.mainColor),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.mainColor),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.mainColor,
                                              width: 0.8),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.calendar_today,
                                          color: AppColors.mainColor,
                                        ),
                                      ),
                                    ),
                                  )),
                                  Container(
                                    // color: AppColors.redAccent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text("To"),
                                  ),
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      if (fromDateTime != null) {
                                        _selectDate(context, false);
                                      }
                                    },
                                    child: TextField(
                                      controller: _dateToController,
                                      // textAlign: TextAlign.center,
                                      enabled: false,
                                      style: TextStyle(fontSize: 13),
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 0),
                                          hintText: "To Date",
                                          // errorText: _toDateError
                                          //     ? "Please Select valid Date"
                                          //     : null,
                                          errorStyle: TextStyle(
                                              fontSize: 9,
                                              color: AppColors.redAccent),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.mainColor),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.mainColor),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.mainColor,
                                                width: 0.8),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.calendar_today,
                                            color: AppColors.mainColor,
                                          )),
                                    ),
                                  )),
                                ]),
                            Visibility(
                              visible: _fromDateError || _toDateError,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        _fromDateError
                                            ? "Please Select valid date"
                                            : "",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.redAccent),
                                      )),
                                      Container(
                                        // color: AppColors.redAccent,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "To",
                                          style: TextStyle(
                                              color: Colors.transparent),
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(
                                        _toDateError
                                            ? "Please Select valid date"
                                            : "",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.redAccent),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            ),
                            Row(children: [
                              Expanded(
                                  child: TextField(
                                controller: _guestNameController,
                                //textAlign: TextAlign.center,
                                // enabled: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  label: Text("Guest Name"),
                                  //  labelStyle: TextStyle(color: AppColors.mainColor),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.mainColor),
                                      borderRadius: BorderRadius.circular(8)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.mainColor),
                                      borderRadius: BorderRadius.circular(8)),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.mainColor, width: 0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // prefixIcon: Icon(
                                  //   Icons.calendar_today_outlined,
                                  //   color: AppColors.mainColor,
                                  // )
                                ),
                              )),
                            ]),
                            SizedBox(
                              height: 15,
                            ),
                            Row(children: [
                              Expanded(
                                  child: TextField(
                                controller: _bookingNoController,
                                //textAlign: TextAlign.center,
                                // enabled: false,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: "Booking No",
                                  //  labelStyle: TextStyle(color: AppColors.mainColor),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.mainColor),
                                      borderRadius: BorderRadius.circular(8)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.mainColor),
                                      borderRadius: BorderRadius.circular(8)),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.mainColor, width: 0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // prefixIcon: Icon(
                                  //   Icons.calendar_today_outlined,
                                  //   color: AppColors.mainColor,
                                  // )
                                ),
                              )),
                            ]),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                      onPressed: widget.onResetClicked,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      color: AppColors.grey300,
                                      child: Text("Reset")),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: MaterialButton(
                                      onPressed: () {
                                        setState(() {
                                          _fromDateError =
                                              _dateFromController.text.isEmpty;
                                          _toDateError =
                                              _dateToController.text.isEmpty;
                                          if (fromDateTime != null &&
                                              toDateTime != null) {
                                            final valid = fromDateTime!
                                                .isAfter(toDateTime!);
                                            _fromDateError = valid;
                                            _toDateError = valid;
                                          }
                                        });
                                        if (!_fromDateError && !_toDateError) {
                                          widget.onApplyClicked(
                                              _bookingCheckInDropDownList[
                                                  _selectedType - 1],
                                              fromDateTime!,
                                              toDateTime!,
                                              _guestNameController.text,
                                              _bookingNoController.text);
                                        }
                                      },
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      color: AppColors.highLightColor,
                                      textColor: AppColors.whiteColor,
                                      child: Text("Apply")),
                                ),
                              ],
                            ),
                            //  SizedBox(
                            //   height: 10,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReportRowWidget extends StatelessWidget {
  const ReportRowWidget({
    Key? key,
    required this.report,
    required this.onItemClicked,
  }) : super(key: key);
  final HotelReservation report;
  final Function() onItemClicked;

  @override
  Widget build(BuildContext context) {
    PersonName personName = report.resGuests!.resGuest![0].profiles!
        .profileInfo!.profile!.customer!.personName!;
    final givenName = personName.givenName;
    final name = personName.surname;
    final bookingId = report.uniqueID!.iD;
    final bookedDate = report.createDateTime!;
    final timeSpan = report.roomStays!.roomStay![0].timeSpan;
    final checkIn = report.roomStays!.roomStay![0].timeSpan!.start;
    final date = bookedDate.replaceAll(".0", "");
    //print("date is $date");
    final formatedBookedTime = Utility.parseServerDateTime(date);
    return InkWell(
      onTap: onItemClicked,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Image.asset(
              report.getImage(),
              width: 40,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$givenName  $name",
                  style: TextStyle(
                      color: AppColors.grey700,
                      fontWeight: FontWeight.w700,
                      fontSize: 13),
                ),
                const SizedBox(
                  height: 8,
                ),
                DefaultTextStyle(
                    style:
                        TextStyle(fontSize: 12, color: AppColors.greyDarkColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Booking ID : $bookingId",
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Booked on : ${Utility.formattedServerDateTime(formatedBookedTime)}",
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Check in : $checkIn (${timeSpan!.getDuration()} Night)",
                        )
                      ],
                    )),
                SizedBox(
                  height: 5,
                ),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    onPressed: () {},
                    color: report.resStatus! == "Cancel"
                        ? AppColors.calenderRedColor
                        : AppColors.reportButtonColor,
                    child: Text(report.resStatus! == "Cancel"
                        ? report.resStatus!
                        : 'Confirmed'))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
