import 'package:channel_connect/model/ota_property_data.dart';
import 'package:channel_connect/util/utility.dart';

class RateResponseData {
  List<RateData>? rateList;
  List<Channels>? channelList;

  RateResponseData({this.rateList, this.channelList});
}

class RateData {
  String? date;
  double? single;
  double? ddouble;
  double? triple;
  double? quad;
  double? extraPax;
  double? extraChild;
  double? minStay;
  double? maxStay;
  bool? stopSell;
  String? blackout;
  DateTime? dateTime;
  bool? selected;

  RateData(
      {this.date,
      this.single,
      this.ddouble,
      this.triple,
      this.selected,
      this.quad,
      this.extraPax,
      this.dateTime,
      this.extraChild,
      this.minStay,
      this.maxStay,
      this.stopSell,
      this.blackout});

  RateData.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    single = json['Single'];
    ddouble = json['Double'];
    triple = json['Triple'];
    quad = json['Quad'];
    extraPax = json['ExtraPax'];
    extraChild = json['ExtraChild'];
    minStay = json['MinStay'];
    maxStay = json['MaxStay'];
    stopSell = json['StopSell'];
    blackout = json['Blackout'];
    dateTime = Utility.parseServerDate(date!);
    selected = false;
  }

  Map<String, dynamic> toJson(
      String invTypeCode,
      String ratePlanCode,
      String latestSingle,
      String latestDdouble,
      String latestTriple,
      String latestQuad,
      bool? latestStopSell) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InvTypeCode'] = invTypeCode;
    data['RatePlanCode'] = ratePlanCode;
    data['Start'] = this.date.toString();
    data['End'] = this.date.toString();
    if (latestSingle.isNotEmpty) {
      data['Single'] = latestSingle.toString();
    }
    if (latestDdouble.isNotEmpty) {
      data['Double'] = latestDdouble.toString();
    }
    if (latestTriple.isNotEmpty) {
      data['Triple'] = latestTriple.toString();
    }
    if (latestQuad.isNotEmpty) {
      data['Quad'] = latestQuad.toString();
    }
    data['ExtPax'] = this.extraPax.toString();
    data['ExtChild'] = this.extraChild.toString();
    data['StopSell'] =
        latestStopSell == null ? "${this.stopSell}" : "$latestStopSell";
    data['MinStay'] = this.minStay.toString();
    data['MaxStay'] = this.maxStay.toString();
    data['Mon'] = "True";
    data['Tue'] = "True";
    data['Weds'] = "True";
    data['Thur'] = "True";
    data['Fri'] = "True";
    data['Sat'] = "True";
    data['Sun'] = "True";
    data['CurrencyCode'] = "";
    return data;
  }
}
