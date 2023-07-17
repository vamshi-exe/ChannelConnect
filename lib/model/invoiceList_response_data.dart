import 'package:channel_connect/util/utility.dart';

class InvoiceListResponse {
  InvoiceListing? invoiceListing;

  InvoiceListResponse({this.invoiceListing});

  InvoiceListResponse.fromJson(Map<String, dynamic> json) {
    invoiceListing = json['InvoiceListing'] != null
        ? InvoiceListing.fromJson(json['InvoiceListing'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.invoiceListing != null) {
      data['InvoiceListing'] = this.invoiceListing!.toJson();
    }
    return data;
  }
}

class InvoiceListing {
  List<CustomerDetails>? customerDetails;

  InvoiceListing({this.customerDetails});

  InvoiceListing.fromJson(Map<String, dynamic> json) {
    if (json['CustomerDetails'] != null) {
      customerDetails = <CustomerDetails>[];
      json['CustomerDetails'].forEach((v) {
        customerDetails!.add(CustomerDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.customerDetails != null) {
      data['CustomerDetails'] =
          this.customerDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerDetails {
  String? merOrderId;
  String? merOrderNo;
  String? merRefenceNo;
  String? merAmount;
  String? merCurrId;
  String? merDesc;
  String? merCustFirstName;
  String? merCustLastName;
  String? merCustAddress;
  String? merCustCity;
  String? merCustState;
  String? merCustCountry;
  String? merCustZip;
  String? merCustemailId;
  String? merCustChecksum;
  String? merCustRefId;
  String? merCustStatus;
  String? merCustExpDate;
  String? merCustSettledDate;
  String? merCustActivity;
  String? merCustCreatedDate;
  String? merCustPhoneNo;
  String? merCustTrackingId;
  String? merCustGatewayId;
  String? merCustTransLogId;
  String? merInvoiceCreatedBy;
  Null? merCustRefundAmt;
  Null? merCustRefundedDate;

  CustomerDetails(
      {this.merOrderId,
      this.merOrderNo,
      this.merRefenceNo,
      this.merAmount,
      this.merCurrId,
      this.merDesc,
      this.merCustFirstName,
      this.merCustLastName,
      this.merCustAddress,
      this.merCustCity,
      this.merCustState,
      this.merCustCountry,
      this.merCustZip,
      this.merCustemailId,
      this.merCustChecksum,
      this.merCustRefId,
      this.merCustStatus,
      this.merCustExpDate,
      this.merCustSettledDate,
      this.merCustActivity,
      this.merCustCreatedDate,
      this.merCustPhoneNo,
      this.merCustTrackingId,
      this.merCustGatewayId,
      this.merCustTransLogId,
      this.merInvoiceCreatedBy,
      this.merCustRefundAmt,
      this.merCustRefundedDate});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    merOrderId = json['merOrderId'];
    merOrderNo = json['merOrderNo'];
    merRefenceNo = json['merRefenceNo'];
    merAmount = json['merAmount'];
    merCurrId = json['merCurrId'];
    merDesc = json['merDesc'];
    merCustFirstName = json['merCustFirstName'];
    merCustLastName = json['merCustLastName'];
    merCustAddress = json['merCustAddress'];
    merCustCity = json['merCust_City'];
    merCustState = json['merCustState'];
    merCustCountry = json['merCustCountry'];
    merCustZip = json['merCustZip'];
    merCustemailId = json['merCustemailId'];
    merCustChecksum = json['merCustChecksum'];
    merCustRefId = json['merCustRefId'];
    merCustStatus = json['merCustStatus'];
    merCustExpDate = json['merCustExpDate'];
    merCustSettledDate = json['merCustSettledDate'];
    merCustActivity = json['merCustActivity'];
    merCustCreatedDate = json['merCustCreatedDate'];
    merCustPhoneNo = json['merCustPhoneNo'];
    merCustTrackingId = json['merCustTrackingId'];
    merCustGatewayId = json['merCustGatewayId'];
    merCustTransLogId = json['merCustTransLogId'];
    merInvoiceCreatedBy = json['merInvoiceCreatedBy'];
    merCustRefundAmt = json['merCustRefundAmt'];
    merCustRefundedDate = json['merCustRefundedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['merOrderId'] = this.merOrderId;
    data['merOrderNo'] = this.merOrderNo;
    data['merRefenceNo'] = this.merRefenceNo;
    data['merAmount'] = this.merAmount;
    data['merCurrId'] = this.merCurrId;
    data['merDesc'] = this.merDesc;
    data['merCustFirstName'] = this.merCustFirstName;
    data['merCustLastName'] = this.merCustLastName;
    data['merCustAddress'] = this.merCustAddress;
    data['merCust_City'] = this.merCustCity;
    data['merCustState'] = this.merCustState;
    data['merCustCountry'] = this.merCustCountry;
    data['merCustZip'] = this.merCustZip;
    data['merCustemailId'] = this.merCustemailId;
    data['merCustChecksum'] = this.merCustChecksum;
    data['merCustRefId'] = this.merCustRefId;
    data['merCustStatus'] = this.merCustStatus;
    data['merCustExpDate'] = this.merCustExpDate;
    data['merCustSettledDate'] = this.merCustSettledDate;
    data['merCustActivity'] = this.merCustActivity;
    data['merCustCreatedDate'] = this.merCustCreatedDate;
    data['merCustPhoneNo'] = this.merCustPhoneNo;
    data['merCustTrackingId'] = this.merCustTrackingId;
    data['merCustGatewayId'] = this.merCustGatewayId;
    data['merCustTransLogId'] = this.merCustTransLogId;
    data['merInvoiceCreatedBy'] = this.merInvoiceCreatedBy;
    data['merCustRefundAmt'] = this.merCustRefundAmt;
    data['merCustRefundedDate'] = this.merCustRefundedDate;
    return data;
  }
}