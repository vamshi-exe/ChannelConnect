import 'dart:convert';
import 'dart:io';

import 'package:channel_connect/model/inventory_data.dart';
import 'package:channel_connect/model/ota_property_data.dart';
import 'package:channel_connect/model/rate_data.dart';
import 'package:channel_connect/model/report_response_data.dart';
import 'package:channel_connect/network/Api.dart';
import 'package:channel_connect/network/Url_list.dart';
import 'package:channel_connect/network/api_error_exception.dart';
import 'package:channel_connect/network/basic_response.dart';
import 'package:channel_connect/prefrence_util/Prefs.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<BasicResponse<OtaPropertyData>> fetchUser(
      String username, String password) async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      final value = await FirebaseMessaging.instance.getToken();
      var request = http.Request('POST', Uri.parse(UrlList.propertyDetails));
      request.body = json.encode({
        "APP_VersionRQ": {
          "POS": {
            "Action": "Login",
            "IMEI": "unknown",
            "Username": "$username",
            "Password": "$password",
            "ID_Context": "APP",
            "FirebaseKey":
                "$value"
          }
        }
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        //print(await response.stream.bytesToString());
        final data = await response.stream.bytesToString();
        print("response is " + data);
        Prefs.setUserData(data);
        return BasicResponse<OtaPropertyData>(
            timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
            code: response.statusCode.toString(),
            status: "Sucess",
            data: OtaPropertyData.fromJson(jsonDecode(data)));
      } else {
        print(response.reasonPhrase);
        throw ApiErrorException(response.reasonPhrase);
      }
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      // sendMail(UrlList.SEND_OTP, SOMETHING_WRONG_TEXT);
      throw ApiErrorException(e.toString());
    }
  }

  Future<InventoryResponseData> fetchInventoryCalenderData(
    String hotelCode,
    String startDate,
    String endDate,
    String invCode,
  ) async {
    try {
      final username = await Prefs.username;
      final password = await Prefs.password;
      final queryData = {
        "response_type": "json",
        "request_method": "inventory",
        "id_context": "APP",
        "username": "$username",
        "password": "$password",
        "hotel_code": "$hotelCode",
        "start": "$startDate",
        "end": "$endDate",
        "invCode": "$invCode",
      };
      print("body is " + queryData.toString());
      final response =
          await Api.requestGet(UrlList.propertyDetails, query: queryData);

      // print("response inventory data is " + response.json);
      if (response.json != null) {
        final json = jsonDecode(response.json);
        final otaJson = json["OTA_HotelInventoryRS"];
        final Inventories = otaJson["Inventories"];
        final inventList = Inventories[0]["Inventory"];
        final channels = otaJson["Channels"];
        List<InventoryData> list = [];
        List<Channels> channelList = [];
        for (var item in inventList) {
          list.add(InventoryData.fromJson(item));
        }
        for (var item in channels) {
          channelList.add(Channels.fromEditJson(item));
        }
        return InventoryResponseData(
            channelList: channelList, inventoryList: list);
      }
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      // sendMail(UrlList.SEND_OTP, SOMETHING_WRONG_TEXT);
      throw ApiErrorException(e.toString());
    }
  }

  Future<RateResponseData> fetchRateCalenderData(String hotelCode,
      String startDate, String endDate, String rateCode) async {
    try {
      final username = await Prefs.username;
      final password = await Prefs.password;
      final queryData = {
        "response_type": "json",
        "request_method": "rate",
        "id_context": "APP",
        "username": "$username",
        "password": "$password",
        "hotel_code": "$hotelCode",
        "start": "$startDate",
        "end": "$endDate",
        "rateCode": "$rateCode",
      };
      print("body is " + queryData.toString());
      final response =
          await Api.requestGet(UrlList.propertyDetails, query: queryData);

      print("response rate data is " + response.json);
      if (response.json != null) {
        final json = jsonDecode(response.json);
        final otaJson = json["OTA_HotelRateRS"];
        final rates = otaJson["Rates"];
        final rateList = rates[0]["Rate"];
        final channels = otaJson["Channels"];
        List<RateData> list = [];
        List<Channels> channelList = [];
        for (var item in rateList) {
          list.add(RateData.fromJson(item));
        }
        for (var item in channels) {
          channelList.add(Channels.fromEditJson(item));
        }
        return RateResponseData(rateList: list, channelList: channelList);
      }
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      print(e.toString());
      // sendMail(UrlList.SEND_OTP, SOMETHING_WRONG_TEXT);
      throw ApiErrorException(e.toString());
    }
  }

  Future<Map<String, dynamic>> updateRateData(
    String hotelName,
    String hotelCode,
    String invCode,
    String ratePlanCode,
    String single,
    String ddouble,
    String triple,
    String quad,
    bool? stopSell,
    List<RateData> rateList,
    String channels,
  ) async {
    try {
      final username = await Prefs.username;
      final password = await Prefs.password;
      final timeStamp = DateTime.now().millisecondsSinceEpoch;
      final list = rateList
          .map((e) => e.toJson(
              invCode, ratePlanCode, single, ddouble, triple, quad, stopSell))
          .toList();

      final postJson = {
        "OTA_HotelRateAmountNotifRQ": {
          "POS": {
            "ID": "$username",
            "MessagePassword": "$password",
            "ID_Context": "APP",
          },
          "TimeStamp": "$timeStamp",
          "EchoToken": "abc1323",
          "RequestFrom": "APP",
          "OTAName": "$channels",
          "RateAmountMessages": {
            "HotelName": "$hotelName",
            "HotelCode": "$hotelCode",
            "RateAmountMessage": list,
          }
        }
      };
      print("post json is " + jsonEncode(postJson));
      final response = await http.post(Uri.parse(UrlList.propertyDetails),
          body: jsonEncode(postJson),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          });

      // final response = await Api.requestPost(
      //     api: UrlList.propertyDetails,
      //     body: postJson,
      //     jsonformat: true,
      //     encoded: true);

      print("response rate data is " + response.body.toString());
      if (response.body != null) {
        final json = jsonDecode(response.body);
        return json;
      }
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      print(e.toString());
      // sendMail(UrlList.SEND_OTP, SOMETHING_WRONG_TEXT);
      throw ApiErrorException(e.toString());
    }
  }

  Future<Map<String, dynamic>> updateInventoryData(
    String hotelName,
    String hotelCode,
    String invCode,
    String inventory,
    bool? stopSell,
    List<InventoryData> inventoryList,
    String channels,
  ) async {
    try {
      final username = await Prefs.username;
      final password = await Prefs.password;
      final timeStamp = DateTime.now().millisecondsSinceEpoch;
      final list = inventoryList
          .map((e) => e.toJson(invCode.toString(), inventory, stopSell))
          .toList();

      final postJson = {
        "OTA_HotelInvCountNotifRQ": {
          "POS": {
            "ID": "$username",
            "MessagePassword": "$password",
            "ID_Context": "APP",
          },
          "TimeStamp": "$timeStamp",
          "EchoToken": "de84d0b6-ba3c-4d54-9255-b57b33a1ecba",
          "RequestFrom": "Normal",
          "OTAName": "$channels",
          "Inventories": {
            "HotelName": "$hotelName",
            "HotelCode": "$hotelCode",
            "Inventory": list,
          }
        }
      };
      // print("post json is " + jsonEncode(postJson));
      final response = await Api.requestPost(
          api: UrlList.propertyDetails,
          body: postJson,
          jsonformat: true,
          encoded: true);

      print("response rate data is " + response.json);
      if (response.json != null) {
        final json = jsonDecode(response.json);
        return json;
      }
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      print(e.toString());
      // sendMail(UrlList.SEND_OTP, SOMETHING_WRONG_TEXT);
      throw ApiErrorException(e.toString());
    }
  }

  Future<ReportResponse> fetchReportList(
      String hotelCode,
      String startDate,
      String endDate,
      String guestName,
      String bookingNo,
      bool isBooking) async {
    try {
      final username = await Prefs.username;
      final password = await Prefs.password;
      final queryData = {
        "action": "booking_detail",
        "code": "REV",
        "user_name": "$username",
        "password": "$password",
        "hotel_id": "$hotelCode",
        "date_from": (isBooking) ? "$startDate" : "",
        "date_to": (isBooking) ? "$endDate" : "",
        "guestName": "$guestName",
        "bookingNo": "$bookingNo",
        "checkinDateFrom": (isBooking) ? "" : "$startDate",
        "checkinDateTo": (isBooking) ? "" : "$endDate",
        "reqFrom": "APP"
      };
      print("body is " + queryData.toString());
      final response = await Api.requestGet(UrlList.repot, query: queryData);

      //print("response rate data is " + response.json);
      if (response.json != null) {
        final json = jsonDecode(response.json);
        return ReportResponse.fromJson(json);
      }
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      print(e.toString());
      // sendMail(UrlList.SEND_OTP, SOMETHING_WRONG_TEXT);
      throw ApiErrorException(e.toString());
    }
  }

  Future<Map<String, dynamic>> collectPyment(String email, String propertyCode,
      String bookingNo, String bookingId) async {
    try {
      final username = await Prefs.username;
      final password = await Prefs.password;
      final postJson = {
        "OTA_CreateInvoiceRQ": {
          "POS": {
            "reqFrom": "APP",
            "Username": "$username",
            "Password": "$password",
            "ID_Context": "REV"
          },
          "PropCode": "$propertyCode",
          "BookingNo": "$bookingNo",
          "BookingId": "$bookingId",
          "Emails": "$email"
        }
      };
      final header = {
        "Accept": "application/json",
        "Content-Type": "application/json"
      };
      print("body is " + postJson.toString());
      //  final response = await Api.requestPost(
      //       api: UrlList.propertyDetails,
      //       body: postJson,
      //       jsonformat: true,
      //       encoded: true);
      final response = await http.post(Uri.parse(UrlList.propertyDetails),
          body: jsonEncode(postJson), headers: header);

      print("collect payment data is " + response.body);
      if (response.body != null) {
        final json = jsonDecode(response.body);
        return json;
      }
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      print(e.toString());
      // sendMail(UrlList.SEND_OTP, SOMETHING_WRONG_TEXT);
      throw ApiErrorException(e.toString());
    }
  }

  Future<Map<String, dynamic>> resendEmail(
      String email, String propertyCode, String bookingId) async {
    try {
      final username = await Prefs.username;
      final password = await Prefs.password;
      final postJson = {
        "OTA_ResendMailRQ": {
          "POS": {
            "reqFrom": "APP",
            "Username": "$username",
            "Password": "$password",
            "ID_Context": "REV"
          },
          "PropCode": "$propertyCode",
          "BookingId": "$bookingId",
          "Emails": "$email"
        }
      };
      final header = {
        "Accept": "application/json",
        "Content-Type": "application/json"
      };
      print("body is " + postJson.toString());
      final response = await http.post(Uri.parse(UrlList.propertyDetails),
          body: jsonEncode(postJson), headers: header);

      print("resendEmail data is " + response.body);
      if (response.body != null) {
        final json = jsonDecode(response.body);
        return json;
      }
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      print(e.toString());
      // sendMail(UrlList.SEND_OTP, SOMETHING_WRONG_TEXT);
      throw ApiErrorException(e.toString());
    }
  }
}
