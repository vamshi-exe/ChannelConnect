import 'dart:ui';

import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/model/report_response_data.dart';
import 'package:channel_connect/page/report_details/report_details_viewmodel.dart';
import 'package:channel_connect/prefrence_util/Prefs.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/app_image.dart';
import 'package:channel_connect/util/common_pattern.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class ReportDetailsPage extends StatefulWidget {
  const ReportDetailsPage({Key? key, required this.booking}) : super(key: key);

  final HotelReservation booking;

  @override
  _ReportDetailsPageState createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  _buildBookingId() {
    final id = widget.booking.uniqueID!.iD;
    final bookedDate = widget.booking.createDateTime!;
    final formatedBookedTime = Utility.parseServerDateTime(bookedDate);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          Image.asset(
            widget.booking.getImage(),
            width: 35,
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Booking #"),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "$id",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.booking.resStatus! == "Commit"
                    ? "Confirmed"
                    : widget.booking.resStatus! == "Modify"
                        ? "Modified"
                        : widget.booking.resStatus!,
                style: TextStyle(
                    color: widget.booking.resStatus! == "Cancel"
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "${Utility.formattedServerDate(formatedBookedTime)}",
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.green),
              )
            ],
          ),
        ],
      ),
    );
  }

  buildBookingDateCheckPayStatus() {
    final id = widget.booking.uniqueID!.iD;
    final bookedDate = widget.booking.createDateTime!;
    final formatedBookedTime = Utility.parseServerDateTime(bookedDate);
    final timespan = widget.booking.roomStays!.roomStay![0].timeSpan!;
    final checkIn = widget.booking.roomStays!.roomStay![0].timeSpan!.start;
    final formatedCheckInTime = Utility.parseServerDate(checkIn!);
    final totalBookingAmount =
        widget.booking.resGlobalInfo!.total!.totalBookingAmount!;
    final currencyCode = widget.booking.resGlobalInfo!.total!.currencyCode!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          _buildTitleDescRowWidget("Booking Date | Time",
              "${Utility.formattedServerDateTime(formatedBookedTime)}"),
          SizedBox(
            height: 8,
          ),
          _buildTitleDescRowWidget("Check-In (Nights)",
              "${Utility.formattedServerDate(formatedCheckInTime)} (${timespan.getDuration()} Night)"),
          SizedBox(
            height: 8,
          ),
          _buildTitleDescRowWidget("Source", widget.booking.uniqueID!.source!),
          SizedBox(
            height: 8,
          ),
          _buildTitleDescRowWidget(
              "Booking Amt.", "$currencyCode $totalBookingAmount"),
          SizedBox(
            height: 8,
          ),
          _buildTitleDescRowWidget(
              "Pay Status",
              // (widget.booking.payAtHotel == "N")
              //     ?
              widget.booking.resGlobalInfo!.total!.payStatus!,
              // : "Pay@Hotel",
              descColor: (widget.booking.resGlobalInfo!.total!.payStatus! ==
                      "Fully Paid")
                  ? AppColors.calenderTextGreenColor
                  : AppColors.calenderTextRedColor,
              descWeight: FontWeight.w700),
        ],
      ),
    );
  }

  _buildTitleDescRowWidget(String title, String desc,
      {Color? descColor, FontWeight? descWeight}) {
    return Row(
      children: [
        Expanded(
            child: Text(
          "$title",
          style: TextStyle(fontWeight: FontWeight.w700),
        )),
        SizedBox(
          width: 5,
        ),
        Text(" : "),
        SizedBox(
          width: 5,
        ),
        Expanded(
            child: Text(
          "$desc",
          style: TextStyle(
              color: descColor ?? AppColors.grey700,
              fontWeight: descWeight ?? FontWeight.normal),
        ))
      ],
    );
  }

  buildBookingRoomDetails() {
    final resGuestList = widget.booking.resGuests!.resGuest;
    final roomStay = widget.booking.roomStays!.roomStay!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Text(
            'Booking Details',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 5,
          ),
          ListView.builder(
            itemCount: resGuestList!.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final firstName = resGuestList[index]
                  .profiles!
                  .profileInfo!
                  .profile!
                  .customer!
                  .personName!
                  .givenName!;
              final lastName = resGuestList[index]
                  .profiles!
                  .profileInfo!
                  .profile!
                  .customer!
                  .personName!
                  .surname!;
              final email = resGuestList[index]
                  .profiles!
                  .profileInfo!
                  .profile!
                  .customer!
                  .email!;
              final contactNo = resGuestList[index]
                  .profiles!
                  .profileInfo!
                  .profile!
                  .customer!
                  .contactNo!;
              final roomName =
                  roomStay[index].roomTypes!.roomType!.roomDescription!.name;
              final roomPlanName =
                  roomStay[index].ratePlans!.ratePlan!.ratePlanName;
              final checkIn = roomStay[index].timeSpan!.start;
              final checkOut = roomStay[index].timeSpan!.end;
              final sellRate = roomStay[index].total!.currencyCode! +
                  " " +
                  roomStay[index].total!.amount!.toString();
              final duration = Utility.parseServerDate(checkOut!)
                  .difference(Utility.parseServerDate(checkIn!))
                  .inDays;
              final adultCount = roomStay[index].getAdultCount;
              final childCount = roomStay[index].getChildCount;
              final ratePlan =
                  roomStay[index].ratePlans!.ratePlan!.ratePlanName;
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: AppColors.grey300,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                "Room#",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text("Room${index + 1}")
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              _buildTitleDescRowWidget(
                                  "Room Details", "$roomName"),
                              SizedBox(
                                height: 8,
                              ),
                              _buildTitleDescRowWidget(
                                  "Rate Plan", "$ratePlan"),
                              SizedBox(
                                height: 8,
                              ),
                              _buildTitleDescRowWidget(
                                  "Guest Details", "$firstName $lastName"),
                              SizedBox(
                                height: 8,
                              ),
                              _buildTitleDescRowWidget(
                                  "Contact Details", "$email\n$contactNo"),
                              SizedBox(
                                height: 8,
                              ),
                              _buildTitleDescRowWidget("Check-In", "$checkIn"),
                              SizedBox(
                                height: 8,
                              ),
                              _buildTitleDescRowWidget(
                                  "Nights #", "$duration Night"),
                              SizedBox(
                                height: 8,
                              ),
                              _buildTitleDescRowWidget("Adults", "$adultCount"),
                              SizedBox(
                                height: 8,
                              ),
                              _buildTitleDescRowWidget("Childs", "$childCount"),
                              SizedBox(
                                height: 8,
                              ),
                              _buildTitleDescRowWidget("Net Rate", "$sellRate"),
                              // SizedBox(
                              //   height: 8,
                              // ),
                              // _buildTitleDescRowWidget("Sell Rate", "-"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  _buildNetAmountDetails() {
    final total = widget.booking.resGlobalInfo!.total!;
    final netAmount = total.currencyCode! + " " + total.supplierAmount!;
    final commission = total.currencyCode! + " " + total.commissionAmount!;
    final totalAmount = "${total.currencyCode!} ${total.totalBookingAmount!}";
    final taxAmount = total.currencyCode! + " " + total.totalTax!;
    double totalBookingAmount = 0;
    for (var i = 0; i < widget.booking.roomStays!.roomStay!.length; i++) {
      totalBookingAmount +=
          double.parse(widget.booking.roomStays!.roomStay![i].total!.amount!);
    }
    final totalBookingAmountVal =
        "${total.currencyCode!} ${totalBookingAmount.toStringAsFixed(2)}";
    double discountVal =
        totalBookingAmount - double.parse(total.supplierAmount!);
    final discountAmount =
        "${total.currencyCode!} ${discountVal.toStringAsFixed(2)}";
    String partPaymentAmount = "${total.currencyCode!} 0.00";
    double partPaymentVal = 0.00;
    if (total.payableToHotel != "null") {
      partPaymentVal = double.parse(total.totalBookingAmount!) -
          double.parse(total.payableToHotel!);
      partPaymentAmount =
          "${total.currencyCode!} ${partPaymentVal.toStringAsFixed(2)}";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          double.parse(total.totalBookingAmount!) > 0
              ? Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Total Booking Amount",
                          textAlign: TextAlign.end,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Text(" : "),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(flex: 1, child: Text(totalAmount))
                  ],
                )
              : Container(),
          totalBookingAmount > 0
              ? Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Net Amount (may include tax as per your OTA configuration)",
                          textAlign: TextAlign.end,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Text(" : "),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(flex: 1, child: Text(totalBookingAmountVal))
                  ],
                )
              : Container(),
          SizedBox(
            height: 8,
          ),
          double.parse(total.totalTax!) > 0
              ? Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          "GST",
                          textAlign: TextAlign.end,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Text(" : "),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(flex: 1, child: Text(taxAmount))
                  ],
                )
              : Container(),
          double.parse(total.totalTax!) > 0
              ? SizedBox(
                  height: 8,
                )
              : Container(),
          double.parse(total.commissionAmount!) > 0
              ? Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Commission",
                          textAlign: TextAlign.end,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Text(" : "),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(flex: 1, child: Text(commission))
                  ],
                )
              : Container(),
          double.parse(total.commissionAmount!) > 0
              ? SizedBox(
                  height: 5,
                )
              : Container(),
          partPaymentVal > 0
              ? Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Part Payment Received",
                          textAlign: TextAlign.end,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Text(" : "),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(flex: 1, child: Text(partPaymentAmount))
                  ],
                )
              : Container(),
          partPaymentVal > 0
              ? SizedBox(
                  height: 5,
                )
              : Container(),
          discountVal > 0
              ? Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Discount Applied",
                          textAlign: TextAlign.end,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Text(" : "),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(flex: 1, child: Text(discountAmount))
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  _buildTotalAmount() {
    final total = widget.booking.resGlobalInfo!.total!;
    // final netAmount = total.currencyCode! + " " + total.supplierAmount!;
    // final commission = total.currencyCode! + " " + total.commissionAmount!;
    // final totalAmount = total.currencyCode! + " " + total.totalBookingAmount!;
    double paybleAtHotel = 0.00;
    if (total.payableToHotel != "null") {
      paybleAtHotel = double.parse(total.payableToHotel!);
    }
    String balanceDueVal = "${total.currencyCode!} $paybleAtHotel";
    return paybleAtHotel > 0
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: DefaultTextStyle(
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackText),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text(
                            "Balance Due",
                            textAlign: TextAlign.end,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text(" : "),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(flex: 1, child: Text(balanceDueVal))
                    ],
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  _performCollectPayment(Function(String email) onSubmit) async {
    showDialog(
        context: context,
        builder: (_) => CollectPaymentWidget(
            email: widget.booking.resGuests!.resGuest![0].profiles!.profileInfo!
                .profile!.customer!.email!,
            onSubmit: onSubmit));
  }

  _performResendMail(Function(String email) onSubmit) async {
    final email = await Prefs.username;
    // myPrint("email is $email");
    showDialog(
        context: context,
        builder: (_) => ResendMailWidget(email: email, onSubmit: onSubmit));
  }

  Widget buildButtonsView(ReportDetailsViewModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: [
          Expanded(
            child: Opacity(
              opacity: widget.booking.isPayAtHotel() ? 1 : 0.4,
              child: TextButton.icon(
                onPressed: widget.booking.isPayAtHotel()
                    ? () {
                        _performCollectPayment((String email) {
                          model.collectPaymentRequest(context, email);
                        });
                      }
                    : null,
                label: Text(
                  "Collect Payment",
                  style: TextStyle(color: AppColors.blackText),
                ),
                icon: Icon(
                  Icons.mail_outline_outlined,
                  color: AppColors.blackText,
                ),
              ),
            ),
          ),
          Container(
            height: 30,
            width: 1,
            color: AppColors.grey400,
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: () {
                _performResendMail((String email) {
                  model.resendEmail(context, email);
                });
              },
              label: Text(
                "Resend E-Mail",
                style: TextStyle(color: AppColors.blackText),
              ),
              icon: Icon(
                Icons.mail_outline_outlined,
                color: AppColors.blackText,
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildExtra(String title, String desc) {
    return Column(
      children: [
        Container(
          height: 1,
          color: AppColors.grey300,
        ),
        Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 4,
              ),
              Text("$desc")
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final apprepo = Provider.of<AppRepo>(context, listen: false);
    return ViewModelBuilder<ReportDetailsViewModel>.reactive(
      viewModelBuilder: () => ReportDetailsViewModel(),
      onModelReady: (ReportDetailsViewModel mdoel) =>
          mdoel.iniData(widget.booking),
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Booking Details"),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  color: AppColors.mainColor.withOpacity(0.8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    apprepo.selectedProperty.hotelName!,
                    style: TextStyle(fontSize: 16, color: AppColors.whiteColor),
                  ),
                ),
                buildButtonsView(model),
                Container(
                  height: 1,
                  color: AppColors.grey300,
                ),
                _buildBookingId(),
                Container(
                  height: 1,
                  color: AppColors.grey300,
                ),
                buildBookingDateCheckPayStatus(),
                Container(
                  height: 1,
                  color: AppColors.grey300,
                ),
                buildBookingRoomDetails(),
                Container(
                  height: 1,
                  color: AppColors.grey300,
                ),
                _buildNetAmountDetails(),
                Container(
                  height: 1,
                  color: AppColors.grey300,
                ),
                _buildTotalAmount(),
                Visibility(
                    visible: widget.booking.specialRequest != null,
                    child:
                        _buildExtra("Special Request", " I need show Balls")),
                Visibility(
                  visible: widget.booking.discount != null,
                  child: _buildExtra("Discount", "Dicount of 500"),
                ),
                Visibility(
                  visible: widget.booking.policy != null,
                  child: _buildExtra(
                      "Policy", "Money return policy on cancellation"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CollectPaymentWidget extends StatefulWidget {
  const CollectPaymentWidget({
    Key? key,
    required this.email,
    required this.onSubmit,
  }) : super(key: key);
  final String email;
  final Function(String email) onSubmit;

  @override
  State<CollectPaymentWidget> createState() => _CollectPaymentWidgetState();
}

class _CollectPaymentWidgetState extends State<CollectPaymentWidget> {
  final _controller = TextEditingController();
  bool _error = false;
  @override
  void initState() {
    _controller.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      titlePadding: EdgeInsets.zero,
      title: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
        color: AppColors.mainColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Text(
              "COLLECT PAYMENT",
              style: TextStyle(color: AppColors.whiteColor, fontSize: 17),
            )),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: AppColors.whiteColor,
                ))
          ],
        ),
      ),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.emailAddress,
              onChanged: (String text) {
                _error = !RegExp(CommonPattern.email_regex).hasMatch(text);
                setState(() {});
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.mainColor),
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.mainColor),
                      borderRadius: BorderRadius.circular(8)),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.mainColor, width: 0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _error ? "Please enter valid email Id" : null,
                  label: Text("Email Id")),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                    onPressed: _error
                        ? null
                        : () {
                            Navigator.pop(context);
                            widget.onSubmit(_controller.text);
                          },
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    color: AppColors.highLightColor,
                    textColor: AppColors.whiteColor,
                    child: Text("Submit")),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ResendMailWidget extends StatefulWidget {
  const ResendMailWidget({
    Key? key,
    required this.email,
    required this.onSubmit,
  }) : super(key: key);
  final String email;
  final Function(String email) onSubmit;

  @override
  State<ResendMailWidget> createState() => _ResendMailWidgetState();
}

class _ResendMailWidgetState extends State<ResendMailWidget> {
  List controllerList = [];
  List<bool> errorList = [];
  double _containerSize = 200;
  @override
  void initState() {
    // _controller.text = widget.email;
    super.initState();
    setState(() {
      controllerList.add(TextEditingController(text: widget.email));
      errorList.add(false);
    });
  }

  _buildTextFeild(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          TextField(
            controller: controllerList[index],
            keyboardType: TextInputType.emailAddress,
            onChanged: (String text) {
              errorList[index] =
                  !RegExp(CommonPattern.email_regex).hasMatch(text);
              setState(() {});
            },
            decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.mainColor),
                    borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.mainColor),
                    borderRadius: BorderRadius.circular(8)),
                disabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.mainColor, width: 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: (index != 0)
                    ? InkWell(
                        child: Icon(Icons.close),
                        onTap: () {
                          setState(() {
                            controllerList.removeAt(index);
                            errorList.removeAt(index);
                            _containerSize = _containerSize - 80;
                          });
                        },
                      )
                    : null,
                errorText:
                    errorList[index] ? "Please enter valid email Id" : null,
                label: Text("Email Id ${index + 1}")),
          ),
          // SizedBox(
          //   height: 15,
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      titlePadding: EdgeInsets.zero,
      title: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
        color: AppColors.mainColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Text(
              "RESEND E-MAIL",
              style: TextStyle(color: AppColors.whiteColor, fontSize: 17),
            )),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: AppColors.whiteColor,
                ))
          ],
        ),
      ),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: _containerSize,
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Scrollbar(
                child: ListView(
                  //shrinkWrap: true,
                  children: List.generate(
                      controllerList.length, (index) => _buildTextFeild(index)),
                ),
              ),
            ),
            Visibility(
              visible: controllerList.length < 5,
              child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      controllerList.add(TextEditingController());
                      errorList.add(false);
                      _containerSize = _containerSize + 80;
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add Email-id")),
            ),
            SizedBox(
              height: 10,
            ),
            //Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                    onPressed: () {
                      for (var i = 0; i < controllerList.length; i++) {
                        setState(() {
                          errorList[i] = !RegExp(CommonPattern.email_regex)
                              .hasMatch(controllerList[i].text);
                          //if(errorList[i])
                        });
                      }
                      if (!errorList.contains(true)) {
                        Navigator.pop(context);
                        widget.onSubmit(controllerList
                            .map((e) => e.text)
                            .toList()
                            .join(";"));
                      }
                    },
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    color: AppColors.highLightColor,
                    textColor: AppColors.whiteColor,
                    child: Text("Submit")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
