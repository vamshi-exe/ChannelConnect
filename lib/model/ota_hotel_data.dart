// class HotelDetails {
//   String? update;
//   String? version;
//   int? status;
//   List<OTAPropertiesRS>? oTAPropertiesRS;

//   HotelDetails({this.update, this.version, this.status, this.oTAPropertiesRS});

//   HotelDetails.fromJson(Map<String, dynamic> json) {
//     update = json['update'];
//     version = json['version'];
//     status = json['status'];
//     if (json['OTA_PropertiesRS'] != null) {
//       oTAPropertiesRS = <OTAPropertiesRS>[];
//       json['OTA_PropertiesRS'].forEach((v) {
//         oTAPropertiesRS!.add(new OTAPropertiesRS.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['update'] = this.update;
//     data['version'] = this.version;
//     data['status'] = this.status;
//     if (this.oTAPropertiesRS != null) {
//       data['OTA_PropertiesRS'] =
//           this.oTAPropertiesRS!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class OTAPropertiesRS {
//   List<PropertyDetail>? propertyDetail;

//   OTAPropertiesRS({this.propertyDetail});

//   OTAPropertiesRS.fromJson(Map<String, dynamic> json) {
//     if (json['PropertyDetail'] != null) {
//       propertyDetail = <PropertyDetail>[];
//       json['PropertyDetail'].forEach((v) {
//         propertyDetail!.add(new PropertyDetail.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.propertyDetail != null) {
//       data['PropertyDetail'] =
//           this.propertyDetail!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class PropertyDetail {
//   int? hotelId;
//   String? hotelName;
//   String? hotelCountry;
//   String? hotelCity;
//   String? hotelContact;
//   String? hotelPinCode;
//   String? hotelState;

//   PropertyDetail(
//       {this.hotelId,
//       this.hotelName,
//       this.hotelCountry,
//       this.hotelCity,
//       this.hotelContact,
//       this.hotelPinCode,
//       this.hotelState});

//   PropertyDetail.fromJson(Map<String, dynamic> json) {
//     hotelId = json['hotel_id'];
//     hotelName = json['hotel_name'];
//     hotelCountry = json['hotel_country'];
//     hotelCity = json['hotel_city'];
//     hotelContact = json['hotel_contact'];
//     hotelPinCode = json['hotel_pin_code'];
//     hotelState = json['hotel_state'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['hotel_id'] = this.hotelId;
//     data['hotel_name'] = this.hotelName;
//     data['hotel_country'] = this.hotelCountry;
//     data['hotel_city'] = this.hotelCity;
//     data['hotel_contact'] = this.hotelContact;
//     data['hotel_pin_code'] = this.hotelPinCode;
//     data['hotel_state'] = this.hotelState;
//     return data;
//   }
// }

class Hotel {
  final int id;
  final String name;
  final String country;
  final String city;
  final String contact;
  final String pinCode;
  final String state;

  Hotel({
    required this.id,
    required this.name,
    required this.country,
    required this.city,
    required this.contact,
    required this.pinCode,
    required this.state,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['hotel_id'],
      name: json['hotel_name'],
      country: json['hotel_country'],
      city: json['hotel_city'],
      contact: json['hotel_contact'],
      pinCode: json['hotel_pin_code'],
      state: json['hotel_state'],
    );
  }
}
