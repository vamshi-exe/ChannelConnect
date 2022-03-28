import 'package:channel_connect/util/constants.dart';

class BasicResponse<T> {
  String? timestamp;
  String? status;
  String? code;
  String? message;
  T? data;

  BasicResponse(
      {this.timestamp, this.status, this.code, this.message, this.data});

  factory BasicResponse.fromJson({required Map<String, dynamic> json, var data}) {
    try {
      return BasicResponse(
          timestamp: json[Constants.TIMESTAMP],
          status: json[Constants.STATUS],
          code: json[Constants.CODE],
          message: json[Constants.MESSAGE],
          data: data);
    } catch (e) {
      throw Exception(e);
    }
  }
}

