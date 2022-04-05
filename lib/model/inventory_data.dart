import 'package:channel_connect/model/rate_data.dart';
import 'package:channel_connect/util/utility.dart';

import 'ota_property_data.dart';

class InventoryResponseData {
  List<InventoryData>? inventoryList;
  List<Channels>? channelList;

  InventoryResponseData({this.inventoryList, this.channelList});
}

class InventoryData {
  String? date;
  int? invCount;
  bool? stopSell;
  bool? closeOnArrival;
  bool? closeOnDeparture;
  int? cutOff;
  DateTime? dateTime;
  bool? selected;
  bool? isMap;

  InventoryData(
      {this.date,
      this.invCount,
      this.stopSell,
      this.closeOnArrival,
      this.closeOnDeparture,
      this.selected,
      this.isMap,
      this.dateTime,
      this.cutOff});

  InventoryData.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    invCount = json['InvCount'];
    stopSell = json['StopSell'];
    closeOnArrival = json['CloseOnArrival'];
    closeOnDeparture = json['CloseOnDeparture'];
    cutOff = json['CutOff'];
    selected = false;
    isMap = true;
    dateTime = Utility.parseServerDate(date!);
  }

  Map<String, dynamic> toJson(
      String invCode, String latestInvCount, bool? latestStopSell) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['End'] = this.date;
    data['Start'] = this.date;
    data['InvTypeCode'] = "$invCode";
    if (latestInvCount.isNotEmpty) {
      data['InvCount'] = latestInvCount;
    }
    data['StopSell'] =
        latestStopSell == null ? "${this.stopSell}" : "$latestStopSell";
    data['CloseOnArrival'] = "${this.closeOnArrival}";
    data['CloseOnDeparture'] = "${this.closeOnDeparture}";
    data['Cutoff'] = "${this.cutOff}";
    data['Sun'] = "true";
    data['Sat'] = "true";
    data['Fri'] = "true";
    data['Thur'] = "true";
    data['Weds'] = "true";
    data['Tue'] = "true";
    data['Mon'] = "true";
    return data;
  }
}
