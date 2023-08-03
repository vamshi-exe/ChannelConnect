import 'dart:convert';
import 'package:channel_connect/model/ota_hotel_data.dart';
import 'package:channel_connect/prefrence_util/Prefs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Future<List<HotelDetails>> fetchHotels() async {
// final username = await Prefs.username;
// final password = await Prefs.password;
// final value = await FirebaseMessaging.instance.getToken();
//   final url =
//       Uri.parse('http://203.109.97.241:8080/ChannelController/PropertyDetails');
//   final requestBody = {
// "APP_VersionRQ": {
//   "POS": {
//     "Action": "Login",
//     "IMEI": "unknown",
//     "Username": username,
//     "Password": password,
//     "ID_Context": "APP",
//     "FirebaseKey": "$value"
//   }
// }
//   };
//   final response =
//       await http.post(url, body: json.encode(requestBody), headers: {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//   });

//   if (response.statusCode == 200) {
//     final jsonResponse = jsonDecode(response.body);
//     final hotelList = jsonResponse['response'];
//     return List<HotelDetails>.from(
//         hotelList.map((hotel) => HotelDetails.fromJson(hotel)));
//   } else {
//     print(response.headers);
//     print(response.statusCode);
//     print('=========>${response.body}');
//     print(username);
//     print(password);
//     print(value);
//     throw Exception('Failed to load hotels');
//   }
// }

Future<List<Hotel>?> fetchHotels() async {
  final username = await Prefs.username;
  final password = await Prefs.password;
  final value = await FirebaseMessaging.instance.getToken();
  final url =
      Uri.parse('http://203.109.97.241:8080/ChannelController/PropertyDetails');
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };
  final body = jsonEncode({
    "APP_VersionRQ": {
      "POS": {
        "Action": "Login",
        "IMEI": "unknown",
        "Username": "rucha.betigeri@avenues.info",
        "Password": "test@123",
        "ID_Context": "APP",
        "FirebaseKey":
            "dr6cM1ShQki3GfP3-ltmep:APA91bF22zPgnj1zVRaAj-Hyjq1a7T0oDVDDPxzEFRFSbBOTZMfL9eVyX5RCQUdG2yivf1TdBUzDYqNXaaaQrjE92kQpyKZYrRstGOHcqpLw2gnPq54OJap1dINTD0c68is59ywpceqf"
      }
    }
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    print(response.body);
    final Map<String, dynamic> responseData = json.decode(response.body);
    final List<dynamic> hotelsData =
        responseData['OTA_PropertiesRS'][0]['PropertyDetail'];
    return hotelsData.map((hotelJson) => Hotel.fromJson(hotelJson)).toList();
  } else {
    print(response.headers);
    print(response.body);
    print(response.statusCode);
    print(username);
    throw Exception('Failed to load hotels');
  }
}
