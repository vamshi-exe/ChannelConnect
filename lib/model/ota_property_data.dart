class OtaPropertyData {
  String? update;
  String? version;
  int? status;
  List<OTAPropertiesRS>? oTAPropertiesRS;

  OtaPropertyData(
      {this.update, this.version, this.status, this.oTAPropertiesRS});

  OtaPropertyData.fromJson(Map<String, dynamic> json) {
    update = json['update'];
    version = json['version'];
    status = json['status'];
    if (json['OTA_PropertiesRS'] != null) {
      oTAPropertiesRS = <OTAPropertiesRS>[];
      json['OTA_PropertiesRS'].forEach((v) {
        oTAPropertiesRS!.add(new OTAPropertiesRS.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['update'] = this.update;
    data['version'] = this.version;
    data['status'] = this.status;
    if (this.oTAPropertiesRS != null) {
      data['OTA_PropertiesRS'] =
          this.oTAPropertiesRS!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OTAPropertiesRS {
  List<PropertyDetail>? propertyDetail;

  OTAPropertiesRS({this.propertyDetail});

  OTAPropertiesRS.fromJson(Map<String, dynamic> json) {
    if (json['PropertyDetail'] != null) {
      propertyDetail = <PropertyDetail>[];
      json['PropertyDetail'].forEach((v) {
        propertyDetail!.add(new PropertyDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.propertyDetail != null) {
      data['PropertyDetail'] =
          this.propertyDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropertyDetail {
  int? hotelId;
  String? hotelName;
  String? hotelCountry;
  String? hotelCity;
  String? hotelContact;
  String? hotelPinCode;
  String? hotelState;
  List<RoomTypes>? roomTypes;
  List<Channels>? channels;

  PropertyDetail(
      {this.hotelId,
      this.hotelName,
      this.hotelCountry,
      this.hotelCity,
      this.hotelContact,
      this.hotelPinCode,
      this.hotelState,
      this.roomTypes,
      this.channels});

  PropertyDetail.fromJson(Map<String, dynamic> json) {
    hotelId = json['hotel_id'];
    hotelName = json['hotel_name'];
    hotelCountry = json['hotel_country'];
    hotelCity = json['hotel_city'];
    hotelContact = json['hotel_contact'];
    hotelPinCode = json['hotel_pin_code'];
    hotelState = json['hotel_state'];
    if (json['RoomTypes'] != null) {
      roomTypes = <RoomTypes>[];
      json['RoomTypes'].forEach((v) {
        roomTypes!.add(new RoomTypes.fromJson(v));
      });
    }
    if (json['Channels'] != null) {
      channels = <Channels>[];
      json['Channels'].forEach((v) {
        channels!.add(new Channels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hotel_id'] = this.hotelId;
    data['hotel_name'] = this.hotelName;
    data['hotel_country'] = this.hotelCountry;
    data['hotel_city'] = this.hotelCity;
    data['hotel_contact'] = this.hotelContact;
    data['hotel_pin_code'] = this.hotelPinCode;
    data['hotel_state'] = this.hotelState;
    if (this.roomTypes != null) {
      data['RoomTypes'] = this.roomTypes!.map((v) => v.toJson()).toList();
    }
    if (this.channels != null) {
      data['Channels'] = this.channels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RoomTypes {
  int? roomId;
  String? roomName;
  int? baseOccupancy;
  int? maxOccupancy;
  String? roomStatus;
  List<RatePlans>? ratePlans;

  RoomTypes(
      {this.roomId,
      this.roomName,
      this.baseOccupancy,
      this.maxOccupancy,
      this.roomStatus,
      this.ratePlans});

  RoomTypes.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    roomName = json['room_name'];
    baseOccupancy = json['base_occupancy'];
    maxOccupancy = json['max_occupancy'];
    roomStatus = json['room_status'];
    if (json['RatePlans'] != null) {
      ratePlans = <RatePlans>[];
      json['RatePlans'].forEach((v) {
        ratePlans!.add(new RatePlans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['room_name'] = this.roomName;
    data['base_occupancy'] = this.baseOccupancy;
    data['max_occupancy'] = this.maxOccupancy;
    data['room_status'] = this.roomStatus;
    if (this.ratePlans != null) {
      data['RatePlans'] = this.ratePlans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatePlans {
  int? rateId;
  String? rateName;
  String? validFrom;
  String? validTo;
  String? rateStatus;
  double? minRate;
  double? rateBaseOccupancy;
  double? rateMaxOccupancy;
  double? maxRate;

  RatePlans(
      {this.rateId,
      this.rateName,
      this.validFrom,
      this.validTo,
      this.rateStatus,
      this.minRate,
      this.rateBaseOccupancy,
      this.rateMaxOccupancy,
      this.maxRate});

  RatePlans.fromJson(Map<String, dynamic> json) {
    rateId = json['rate_id'];
    rateName = json['rate_name'];
    validFrom = json['valid_from'];
    validTo = json['valid_to'];
    rateStatus = json['rate_status'];
    minRate = json['min_rate'];
    rateBaseOccupancy = json['rate_base_occupancy'];
    rateMaxOccupancy = json['rate_max_occupancy'];
    maxRate = json['max_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate_id'] = this.rateId;
    data['rate_name'] = this.rateName;
    data['valid_from'] = this.validFrom;
    data['valid_to'] = this.validTo;
    data['rate_status'] = this.rateStatus;
    data['min_rate'] = this.minRate;
    data['rate_base_occupancy'] = this.rateBaseOccupancy;
    data['rate_max_occupancy'] = this.rateMaxOccupancy;
    data['max_rate'] = this.maxRate;
    return data;
  }
}

class Channels {
  int? channelId;
  String? channelName;
  String? channelCode;
  bool? selected;

  Channels({this.channelId, this.channelName, this.channelCode, this.selected});

  Channels.fromJson(Map<String, dynamic> json) {
    channelId = json['channel_id'];
    channelName = json['channel_name'];
    channelCode = json['channel_code'];
  }

  Channels.fromEditJson(Map<String, dynamic> json) {
    channelId = json['channel_id'];
    channelName = json['ChannelName'];
    channelCode = json['ChannelCode'];
    selected = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel_id'] = this.channelId;
    data['channel_name'] = this.channelName;
    data['channel_code'] = this.channelCode;
    return data;
  }
}
