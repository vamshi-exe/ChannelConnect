class ResponseStatus {
  String? channelName;
  String? channelCode;

  ResponseStatus({this.channelName, this.channelCode});

  ResponseStatus.fromJson(Map<String, dynamic> json) {
    channelName = json['channelName'];
    channelCode = json['channelCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelName'] = this.channelName;
    data['channelCode'] = this.channelCode;
    return data;
  }
}