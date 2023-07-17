import 'package:channel_connect/util/utility.dart';

class ReportResponse {
  OTAHotelResNotifRS? oTAHotelResNotifRS;

  ReportResponse({this.oTAHotelResNotifRS});

  ReportResponse.fromJson(Map<String, dynamic> json) {
    oTAHotelResNotifRS = json['OTA_HotelResNotifRS'] != null
        ? new OTAHotelResNotifRS.fromJson(json['OTA_HotelResNotifRS'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.oTAHotelResNotifRS != null) {
      data['OTA_HotelResNotifRS'] = this.oTAHotelResNotifRS!.toJson();
    }
    return data;
  }
}

class OTAHotelResNotifRS {
  HotelReservations? hotelReservations;
  String? timeStamp;
  String? target;
  String? version;
  String? echoToken;

  OTAHotelResNotifRS(
      {this.hotelReservations,
      this.timeStamp,
      this.target,
      this.version,
      this.echoToken});

  OTAHotelResNotifRS.fromJson(Map<String, dynamic> json) {
    hotelReservations = json['HotelReservations'] != null
        ? new HotelReservations.fromJson(json['HotelReservations'])
        : null;
    timeStamp = json['TimeStamp'];
    target = json['Target'];
    version = json['Version'];
    echoToken = json['EchoToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hotelReservations != null) {
      data['HotelReservations'] = this.hotelReservations!.toJson();
    }
    data['TimeStamp'] = this.timeStamp;
    data['Target'] = this.target;
    data['Version'] = this.version;
    data['EchoToken'] = this.echoToken;
    return data;
  }
}

class HotelReservations {
  List<HotelReservation>? hotelReservation;

  HotelReservations({this.hotelReservation});

  HotelReservations.fromJson(Map<String, dynamic> json) {
    if (json['HotelReservation'] != null) {
      hotelReservation = <HotelReservation>[];
      json['HotelReservation'].forEach((v) {
        hotelReservation!.add(new HotelReservation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hotelReservation != null) {
      data['HotelReservation'] =
          this.hotelReservation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HotelReservation {
  String? createDateTime;
  ResGlobalInfo? resGlobalInfo;
  String? payAtHotel;
  ResGuests? resGuests;
  UniqueID? uniqueID;
  RoomStays? roomStays;
  String? resStatus;
  String? specialRequest;
  String? discount;
  String? policy;

  HotelReservation(
      {this.createDateTime,
      this.resGlobalInfo,
      this.payAtHotel,
      this.resGuests,
      this.uniqueID,
      this.specialRequest,
      this.discount,
      this.policy,
      this.roomStays,
      this.resStatus});

  HotelReservation.fromJson(Map<String, dynamic> json) {
    createDateTime = json['CreateDateTime'];
    resGlobalInfo = json['ResGlobalInfo'] != null
        ? new ResGlobalInfo.fromJson(json['ResGlobalInfo'])
        : null;
    payAtHotel = json['PayAtHotel'];
    resGuests = json['ResGuests'] != null
        ? new ResGuests.fromJson(json['ResGuests'])
        : null;
    uniqueID = json['UniqueID'] != null
        ? new UniqueID.fromJson(json['UniqueID'])
        : null;
    roomStays = json['RoomStays'] != null
        ? new RoomStays.fromJson(json['RoomStays'])
        : null;
    resStatus = json['ResStatus'];
    specialRequest = json["SpecialRequest"];
    discount = json["Discount"];
    policy = json["Policy"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CreateDateTime'] = this.createDateTime;
    if (this.resGlobalInfo != null) {
      data['ResGlobalInfo'] = this.resGlobalInfo!.toJson();
    }
    data['PayAtHotel'] = this.payAtHotel;
    if (this.resGuests != null) {
      data['ResGuests'] = this.resGuests!.toJson();
    }
    if (this.uniqueID != null) {
      data['UniqueID'] = this.uniqueID!.toJson();
    }
    if (this.roomStays != null) {
      data['RoomStays'] = this.roomStays!.toJson();
    }
    data['ResStatus'] = this.resStatus;
    return data;
  }

  bool isPayAtHotel() {
    return (payAtHotel != null) ? payAtHotel == "Y" : false;
  }

  getImage() {
    final ota = uniqueID!.otaCode;
    String? imgUrl = channelImageMap[ota];
    if (imgUrl != null) {
      return imgUrl;
    }
    return "assets/no_img.jpeg";
  }
}

class ResGlobalInfo {
  String? specialRequest;
  Total? total;

  ResGlobalInfo({this.specialRequest, this.total});

  ResGlobalInfo.fromJson(Map<String, dynamic> json) {
    specialRequest = json['SpecialRequest'];
    total = json['Total'] != null ? new Total.fromJson(json['Total']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SpecialRequest'] = this.specialRequest;
    if (this.total != null) {
      data['Total'] = this.total!.toJson();
    }
    return data;
  }
}

class Total {
  String? supplierAmount;
  String? payStatus;
  String? totalTax;
  String? totalBookingAmount;
  String? commissionAmount;
  String? currencyCode;
  String? payableToHotel;
  Commission? commission;
  String? payAtHotelAmount;
  String? amount;

  Total(
      {this.supplierAmount,
      this.payStatus,
      this.totalTax,
      this.totalBookingAmount,
      this.amount,
      this.commissionAmount,
      this.currencyCode,
      this.payableToHotel,
      this.commission,
      this.payAtHotelAmount});

  Total.fromJson(Map<String, dynamic> json) {
    supplierAmount = json['SupplierAmount'].toString();
    payStatus = json['PayStatus'];
    totalTax = json['TotalTax'].toString();
    totalBookingAmount = json['TotalBookingAmount'].toString();
    commissionAmount = json['CommissionAmount'].toString();
    currencyCode = json['CurrencyCode'].toString();
    payableToHotel = json['PayableToHotel'].toString();
    commission = json['Commission'] != null
        ? new Commission.fromJson(json['Commission'])
        : null;
    payAtHotelAmount = json['PayAtHotelAmount'].toString();
    amount = json["Amount"].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SupplierAmount'] = this.supplierAmount;
    data['PayStatus'] = this.payStatus;
    data['TotalTax'] = this.totalTax;
    data['TotalBookingAmount'] = this.totalBookingAmount;
    data['CommissionAmount'] = this.commissionAmount;
    data['CurrencyCode'] = this.currencyCode;
    data['PayableToHotel'] = this.payableToHotel;
    if (this.commission != null) {
      data['Commission'] = this.commission!.toJson();
    }
    data['PayAtHotelAmount'] = this.payAtHotelAmount;
    return data;
  }
}

class Commission {
  String? amountAfterTax;
  String? taxInclusive;

  Commission({this.amountAfterTax, this.taxInclusive});

  Commission.fromJson(Map<String, dynamic> json) {
    amountAfterTax = json['AmountAfterTax'].toString();
    taxInclusive = json['TaxInclusive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AmountAfterTax'] = this.amountAfterTax;
    data['TaxInclusive'] = this.taxInclusive;
    return data;
  }
}

class ResGuests {
  List<ResGuest>? resGuest;

  ResGuests({this.resGuest});

  ResGuests.fromJson(Map<String, dynamic> json) {
    if (json['ResGuest'] != null) {
      resGuest = <ResGuest>[];
      json['ResGuest'].forEach((v) {
        resGuest!.add(new ResGuest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.resGuest != null) {
      data['ResGuest'] = this.resGuest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResGuest {
  int? resGuestRPH;
  Profiles? profiles;

  ResGuest({this.resGuestRPH, this.profiles});

  ResGuest.fromJson(Map<String, dynamic> json) {
    resGuestRPH = json['ResGuestRPH'];
    profiles = json['Profiles'] != null
        ? new Profiles.fromJson(json['Profiles'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ResGuestRPH'] = this.resGuestRPH;
    if (this.profiles != null) {
      data['Profiles'] = this.profiles!.toJson();
    }
    return data;
  }
}

class Profiles {
  ProfileInfo? profileInfo;

  Profiles({this.profileInfo});

  Profiles.fromJson(Map<String, dynamic> json) {
    profileInfo = json['ProfileInfo'] != null
        ? new ProfileInfo.fromJson(json['ProfileInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profileInfo != null) {
      data['ProfileInfo'] = this.profileInfo!.toJson();
    }
    return data;
  }
}

class ProfileInfo {
  Profile? profile;
  UniqueID? uniqueID;

  ProfileInfo({this.profile, this.uniqueID});

  ProfileInfo.fromJson(Map<String, dynamic> json) {
    profile =
        json['Profile'] != null ? new Profile.fromJson(json['Profile']) : null;
    uniqueID = json['UniqueID'] != null
        ? new UniqueID.fromJson(json['UniqueID'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profile != null) {
      data['Profile'] = this.profile!.toJson();
    }

    return data;
  }
}

class Profile {
  Customer? customer;
  String? profileType;

  Profile({this.customer, this.profileType});

  Profile.fromJson(Map<String, dynamic> json) {
    customer = json['Customer'] != null
        ? new Customer.fromJson(json['Customer'])
        : null;
    profileType = json['ProfileType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['Customer'] = this.customer!.toJson();
    }
    data['ProfileType'] = this.profileType;
    return data;
  }
}

class Customer {
  String? email;
  PersonName? personName;
  String? contactNo;

  Customer({this.email, this.personName, this.contactNo});

  Customer.fromJson(Map<String, dynamic> json) {
    email = json['Email'];
    personName = json['PersonName'] != null
        ? new PersonName.fromJson(json['PersonName'])
        : null;
    contactNo = json['ContactNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Email'] = this.email;
    if (this.personName != null) {
      data['PersonName'] = this.personName!.toJson();
    }
    data['ContactNo'] = this.contactNo;
    return data;
  }
}

class PersonName {
  String? givenName;
  String? surname;

  PersonName({this.givenName, this.surname});

  PersonName.fromJson(Map<String, dynamic> json) {
    givenName = json['GivenName'];
    surname = json['Surname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GivenName'] = this.givenName;
    data['Surname'] = this.surname;
    return data;
  }
}

class UniqueID {
  String? source;
  String? oTA;
  String? iD;
  String? otaCode;
  String? otaId;

  UniqueID({this.source, this.oTA, this.iD, this.otaCode});

  UniqueID.fromJson(Map<String, dynamic> json) {
    source = json['Source'];
    oTA = json['OTA'];
    iD = json['ID'];
    otaId = json["OTA_ID"];
    otaCode = json["OTA_Code"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Source'] = this.source;
    data['OTA'] = this.oTA;
    data['ID'] = this.iD;
    data['OTA_ID'] = this.otaId;
    data["OTA_Code"] = this.otaCode;
    return data;
  }
}

class RoomStays {
  List<RoomStay>? roomStay;

  RoomStays({this.roomStay});

  RoomStays.fromJson(Map<String, dynamic> json) {
    if (json['RoomStay'] != null) {
      roomStay = <RoomStay>[];
      json['RoomStay'].forEach((v) {
        roomStay!.add(new RoomStay.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.roomStay != null) {
      data['RoomStay'] = this.roomStay!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RoomStay {
  GuestCounts? guestCounts;
  RoomRates? roomRates;
  RoomTypes? roomTypes;
  BasicPropertyInfo? basicPropertyInfo;
  ResGuestRPHs? resGuestRPHs;
  RatePlans? ratePlans;
  TimeSpan? timeSpan;
  Total? total;

  RoomStay(
      {this.guestCounts,
      this.roomRates,
      this.roomTypes,
      this.basicPropertyInfo,
      this.resGuestRPHs,
      this.ratePlans,
      this.timeSpan,
      this.total});

  String get getAdultCount {
    final guestCount = guestCounts!.guestCount!;
    for (var item in guestCount) {
      if (item.ageQualifyingCode == "10") {
        return item.count!;
      }
    }
    return "0";
  }

  String get getChildCount {
    final guestCount = guestCounts!.guestCount!;
    for (var item in guestCount) {
      if (item.ageQualifyingCode == "8") {
        return item.count!;
      }
    }
    return "0";
  }

  RoomStay.fromJson(Map<String, dynamic> json) {
    guestCounts = json['GuestCounts'] != null
        ? new GuestCounts.fromJson(json['GuestCounts'])
        : null;
    roomRates = json['RoomRates'] != null
        ? new RoomRates.fromJson(json['RoomRates'])
        : null;
    roomTypes = json['RoomTypes'] != null
        ? new RoomTypes.fromJson(json['RoomTypes'])
        : null;
    basicPropertyInfo = json['BasicPropertyInfo'] != null
        ? new BasicPropertyInfo.fromJson(json['BasicPropertyInfo'])
        : null;
    resGuestRPHs = json['ResGuestRPHs'] != null
        ? new ResGuestRPHs.fromJson(json['ResGuestRPHs'])
        : null;
    ratePlans = json['RatePlans'] != null
        ? new RatePlans.fromJson(json['RatePlans'])
        : null;
    timeSpan = json['TimeSpan'] != null
        ? new TimeSpan.fromJson(json['TimeSpan'])
        : null;
    total = json['Total'] != null ? new Total.fromJson(json['Total']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.guestCounts != null) {
      data['GuestCounts'] = this.guestCounts!.toJson();
    }
    if (this.roomRates != null) {
      data['RoomRates'] = this.roomRates!.toJson();
    }
    if (this.roomTypes != null) {
      data['RoomTypes'] = this.roomTypes!.toJson();
    }
    if (this.basicPropertyInfo != null) {
      data['BasicPropertyInfo'] = this.basicPropertyInfo!.toJson();
    }
    if (this.resGuestRPHs != null) {
      data['ResGuestRPHs'] = this.resGuestRPHs!.toJson();
    }
    if (this.ratePlans != null) {
      data['RatePlans'] = this.ratePlans!.toJson();
    }
    if (this.timeSpan != null) {
      data['TimeSpan'] = this.timeSpan!.toJson();
    }
    if (this.total != null) {
      data['Total'] = this.total!.toJson();
    }
    return data;
  }
}

class GuestCounts {
  List<GuestCount>? guestCount;

  GuestCounts({this.guestCount});

  GuestCounts.fromJson(Map<String, dynamic> json) {
    if (json['GuestCount'] != null) {
      guestCount = <GuestCount>[];
      json['GuestCount'].forEach((v) {
        guestCount!.add(new GuestCount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.guestCount != null) {
      data['GuestCount'] = this.guestCount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GuestCount {
  String? count;
  String? ageQualifyingCode;

  GuestCount({this.count, this.ageQualifyingCode});

  GuestCount.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    ageQualifyingCode = json['AgeQualifyingCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['AgeQualifyingCode'] = this.ageQualifyingCode;
    return data;
  }
}

class RoomRates {
  RoomRate? roomRate;

  RoomRates({this.roomRate});

  RoomRates.fromJson(Map<String, dynamic> json) {
    roomRate = json['RoomRate'] != null
        ? new RoomRate.fromJson(json['RoomRate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.roomRate != null) {
      data['RoomRate'] = this.roomRate!.toJson();
    }
    return data;
  }
}

class RoomRate {
  List<Rates>? rates;

  RoomRate({this.rates});

  RoomRate.fromJson(Map<String, dynamic> json) {
    if (json['Rates'] != null) {
      rates = <Rates>[];
      json['Rates'].forEach((v) {
        rates!.add(new Rates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rates != null) {
      data['Rates'] = this.rates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rates {
  Total? base;
  String? effectiveDate;

  Rates({this.base, this.effectiveDate});

  Rates.fromJson(Map<String, dynamic> json) {
    base = json['Base'] != null ? new Total.fromJson(json['Base']) : null;
    effectiveDate = json['EffectiveDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.base != null) {
      data['Base'] = this.base!.toJson();
    }
    data['EffectiveDate'] = this.effectiveDate;
    return data;
  }
}

class RoomTypes {
  RoomType? roomType;

  RoomTypes({this.roomType});

  RoomTypes.fromJson(Map<String, dynamic> json) {
    roomType = json['RoomType'] != null
        ? new RoomType.fromJson(json['RoomType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.roomType != null) {
      data['RoomType'] = this.roomType!.toJson();
    }
    return data;
  }
}

class RoomType {
  String? numberOfUnits;
  RoomDescription? roomDescription;
  int? roomTypeCode;

  RoomType({this.numberOfUnits, this.roomDescription, this.roomTypeCode});

  RoomType.fromJson(Map<String, dynamic> json) {
    numberOfUnits = json['NumberOfUnits'];
    roomDescription = json['RoomDescription'] != null
        ? new RoomDescription.fromJson(json['RoomDescription'])
        : null;
    roomTypeCode = json['RoomTypeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NumberOfUnits'] = this.numberOfUnits;
    if (this.roomDescription != null) {
      data['RoomDescription'] = this.roomDescription!.toJson();
    }
    data['RoomTypeCode'] = this.roomTypeCode;
    return data;
  }
}

class RoomDescription {
  String? name;

  RoomDescription({this.name});

  RoomDescription.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    return data;
  }
}

class BasicPropertyInfo {
  String? hotelName;
  String? hotelCode;

  BasicPropertyInfo({this.hotelName, this.hotelCode});

  BasicPropertyInfo.fromJson(Map<String, dynamic> json) {
    hotelName = json['HotelName'];
    hotelCode = json['HotelCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HotelName'] = this.hotelName;
    data['HotelCode'] = this.hotelCode;
    return data;
  }
}

class ResGuestRPHs {
  ResGuestRPH? resGuestRPH;

  ResGuestRPHs({this.resGuestRPH});

  ResGuestRPHs.fromJson(Map<String, dynamic> json) {
    resGuestRPH = json['ResGuestRPH'] != null
        ? new ResGuestRPH.fromJson(json['ResGuestRPH'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.resGuestRPH != null) {
      data['ResGuestRPH'] = this.resGuestRPH!.toJson();
    }
    return data;
  }
}

class ResGuestRPH {
  int? rPH;

  ResGuestRPH({this.rPH});

  ResGuestRPH.fromJson(Map<String, dynamic> json) {
    rPH = json['RPH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RPH'] = this.rPH;
    return data;
  }
}

class RatePlans {
  RatePlan? ratePlan;

  RatePlans({this.ratePlan});

  RatePlans.fromJson(Map<String, dynamic> json) {
    ratePlan = json['RatePlan'] != null
        ? new RatePlan.fromJson(json['RatePlan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ratePlan != null) {
      data['RatePlan'] = this.ratePlan!.toJson();
    }
    return data;
  }
}

class RatePlan {
  String? ratePlanName;
  String? ratePlanCode;

  RatePlan({this.ratePlanName, this.ratePlanCode});

  RatePlan.fromJson(Map<String, dynamic> json) {
    ratePlanName = json['RatePlanName'];
    ratePlanCode = json['RatePlanCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RatePlanName'] = this.ratePlanName;
    data['RatePlanCode'] = this.ratePlanCode;
    return data;
  }
}

class TimeSpan {
  String? end;
  String? start;

  TimeSpan({this.end, this.start});

  TimeSpan.fromJson(Map<String, dynamic> json) {
    end = json['End'];
    start = json['Start'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['End'] = this.end;
    data['Start'] = this.start;
    return data;
  }

  int getDuration() {
    final startDateTime = Utility.parseServerDate(start!);
    final endDateTime = Utility.parseServerDate(end!);
    return endDateTime.difference(startDateTime).inDays;
  }
}
