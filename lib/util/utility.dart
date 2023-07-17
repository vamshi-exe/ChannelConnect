import 'dart:convert';

import 'package:channel_connect/util/app_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:url_launcher/url_launcher.dart';

final String NO_INTERNET_CONN = "No internet connection";
final String SOMETHING_WRONG_TEXT =
    "Something went wrong, sorry for inconvenience cause you, Please try after some time.";

const channelImageMap = {
  "AGD": AppImages.AGD,
  "AIRBNB": AppImages.AIRBNB,
  "ATS":AppImages.ATS,
  "BIDDR": AppImages.BIDDR,
  "BKC": AppImages.BKC,
  "CNX": AppImages.CNX,
  "CTP": AppImages.CTP,
  "DOTW": AppImages.DOTW,
  "HRS": AppImages.HRS,
  "EMT": AppImages.EMT,
  "EXP": AppImages.EXP,
  "EZEEGO": AppImages.EZEEGO,
  "GDS": AppImages.GDS,
  "GOIBIBO": AppImages.GOIBIBO,
  "GOOMO": AppImages.GOOMO,
  "HEG": AppImages.HEG,
  "HOBSE": AppImages.HOBSE,
  "HOTLA": AppImages.HOTLA,
  "HSB": AppImages.HSB,
  "HSC": AppImages.HSC,
  "ITC": AppImages.ITC,
  "Irctc": AppImages.Irctc,
  "LRM": AppImages.LRM,
  "MBB": AppImages.MBB,
  "MMT": AppImages.MMT,
  "NDL": AppImages.NDL,
  "OFR": AppImages.OFR,
  "OPERA": AppImages.OPERA,
  "PAYTM": AppImages.PAYTM,
  "PMSRES": AppImages.PMSRES,
  "RDIR": AppImages.RDIR,
  "REZ": AppImages.REZ,
  "STH": AppImages.STH,
  "STL": AppImages.STL,
  "STZ": AppImages.STZ,
  "SYS": AppImages.SYS,
  "TGR": AppImages.TGR,
  "TLK": AppImages.TLK,
  "TMI": AppImages.TMI,
  "TRP": AppImages.TRP,
  "TVS": AppImages.TVS,
  "VEEKEND": AppImages.VEEKEND,
  "VIA": AppImages.VIA,
  "WHR": AppImages.WHR,
  "WOT": AppImages.WOT,
  "XENIA": AppImages.XENIA,
  "jkrooms": AppImages.jkrooms,
};

class Utility {
  static Future pushToNext(BuildContext context, dynamic page) {
    return Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => page),
    );
  }

  static String encodeJson(dynamic jsonData) {
    print("json data is: ${jsonData.toString()}");
    return json.encode(jsonData);
  }

  static dynamic decodeJson(String jsonString) {
    return json.decode(jsonString);
  }

  static pushToDashBoard(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/HomePage', (Route<dynamic> route) => false);
  }

  static pushToLogin(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/LoginPage', (Route<dynamic> route) => false);
  }

  

  static showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
    ));
  }

  static String formattedDeviceDate(DateTime dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  static String pad2(int number) {
    return (number < 10 ? '0' : '') + number.toString();
  }

  static String getWeekDayName(int weekDay) {
    String name = "Sunday";
    switch (weekDay) {
      case 1:
        name = "Monday";
        break;
      case 2:
        name = "Tuesday";
        break;
      case 3:
        name = "Wednesday";
        break;
      case 4:
        name = "Thusday";
        break;
      case 5:
        name = "Friday";
        break;
      case 6:
        name = "Saturday";
        break;
      case 7:
        name = "Sunday";
        break;
      default:
        name = "Sunday";
    }
    return name;
  }

  static String getMonthName(int weekDay) {
    String name = "January";
    switch (weekDay) {
      case 1:
        name = "January";
        break;
      case 2:
        name = "February";
        break;
      case 3:
        name = "March";
        break;
      case 4:
        name = "April";
        break;
      case 5:
        name = "May";
        break;
      case 6:
        name = "June";
        break;
      case 7:
        name = "July";
        break;
      case 8:
        name = "August";
        break;
      case 9:
        name = "September";
        break;
      case 10:
        name = "October";
        break;
      case 11:
        name = "November";
        break;
      case 12:
        name = "December";
        break;
      default:
        name = "January";
    }
    return name;
  }

  static String formattedDeviceMonthDate(DateTime dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  static String formattedServerDateForRequest(DateTime dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

    static String formattedServerDateForPaymentRequest(DateTime dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('dd-MMM-yyyy').format(dateTime);
  }

  static String formattedServerDate(DateTime dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }

  static String formattedServerDateTime(DateTime dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('dd MMM, yyyy hh:mm:ss').format(dateTime);
  }

  static DateTime parseServerDate(String dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('yyyy-MM-dd').parse(dateTime);
  }

  static DateTime parseServerDateTime(String dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('yyyy-MM-dd hh:mm:ss').parse(dateTime);
  }

  static DateTime parseDeviceDate(String dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('dd-MM-yyyy').parse(dateTime);
  }

  static List<String> getMonthList() {
    return [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
  }

  static List<int> yearList() {
    final DateTime dateTime = DateTime.now();
    List<int> yearList = [];
    yearList.add(dateTime.year);
    yearList.add(dateTime.year + 1);
    yearList.add(dateTime.year + 2);
    return yearList;
  }
//   static  Future<void> makePhoneCall(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);fget
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//  static Future<void>makeWhatsapp(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
}

void myPrint(String text) {
  print(text);
}
