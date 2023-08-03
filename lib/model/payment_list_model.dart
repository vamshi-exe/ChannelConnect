import 'package:http/http.dart' as http;
import 'dart:convert';

class ResInvoiceCreationReq {
  InvoiceSet invoiceSet;

  ResInvoiceCreationReq({required this.invoiceSet});

  Map<String, dynamic> toJson() {
    return {
      'ResInvoiceCreationReq': {'InvoiceSet': invoiceSet.toJson()}
    };
  }
}

class InvoiceSet {
  InvoiceData invoiceData;

  InvoiceSet({required this.invoiceData});

  Map<String, dynamic> toJson() {
    return {'InvoiceData': invoiceData.toJson()};
  }
}

class InvoiceData {
  List<CustomerDetails> customerDetails;

  InvoiceData({required this.customerDetails});

  Map<String, dynamic> toJson() {
    return {'CustomerDetails': customerDetails.map((c) => c.toJson()).toList()};
  }
}

class CustomerDetails {
  String emailId;
  String expiryDate;
  String description;
  String termsAndConditions;
  String reqFrm;
  String referenceNo;
  String address;
  String firstName;
  String checkIn;
  String city;
  double invoiceAmount;
  String hotelCode;
  String contactNo;
  String checkOut;
  String roomName;
  String paymentType;
  int totalAmount;
  String state;
  String currency;
  String zipcode;
  String country;
  String lastName;

  CustomerDetails({
    required this.emailId,
    required this.expiryDate,
    required this.description,
    required this.termsAndConditions,
    required this.reqFrm,
    required this.referenceNo,
    required this.address,
    required this.firstName,
    required this.checkIn,
    required this.city,
    required this.invoiceAmount,
    required this.hotelCode,
    required this.contactNo,
    required this.checkOut,
    required this.roomName,
    required this.paymentType,
    required this.totalAmount,
    required this.state,
    required this.currency,
    required this.zipcode,
    required this.country,
    required this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'EmailId': emailId,
      'ExpiryDate': expiryDate,
      'Description': description,
      'TermsAndConditions': termsAndConditions,
      'req_frm': reqFrm,
      'referenceNo': referenceNo,
      'Address': address,
      'FirstName': firstName,
      'check_in': checkIn,
      'City': city,
      'InvoiceAmount': invoiceAmount,
      'hotel_code': hotelCode,
      'ContactNo': contactNo,
      'check_out': checkOut,
      'room_name': roomName,
      'payment_type': paymentType,
      'total_amount': totalAmount,
      'State': state,
      'Currency': currency,
      'Zipcode': zipcode,
      'Country': country,
      'LastName': lastName,
    };
  }

  static fromJson(item) {}
}
