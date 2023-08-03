class InvoiceListingRequest {
  String propId;
  String searchFromDate;
  String searchToDate;
  String searchDateType;
  int pageNumber;
  int pageSize;

  InvoiceListingRequest({
    required this.propId,
    required this.searchFromDate,
    required this.searchToDate,
    required this.searchDateType,
    required this.pageNumber,
    required this.pageSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'propId': propId,
      'searchFromDate': searchFromDate,
      'searchToDate': searchToDate,
      'searchDateType': searchDateType,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
  }
}

////// respose model class

class InvoiceListingResponse {
  final String merOrderNo;
  final String merCustFirstName;
  final String merCurrId;
  final String merAmount;
  final String merCustCreatedDate;
  final String merCustPhoneNo;
  final String merCustLastName;
  final String merCustStatus;
  final String merCustemailId;
  final String merOrderId;
  final String merCustRefId;
  final String merDesc;
  final String merCustRefundAmt;
  final String merCustRefundedDate;
  final String merRefenceNo;

  InvoiceListingResponse({
    required this.merCustLastName,
    required this.merCustPhoneNo,
    required this.merCustCreatedDate,
    required this.merCurrId,
    required this.merAmount,
    required this.merOrderNo,
    required this.merCustFirstName,
    required this.merCustStatus,
    required this.merCustemailId,
    required this.merOrderId,
    required this.merCustRefId,
    required this.merDesc,
    required this.merCustRefundAmt,
    required this.merCustRefundedDate,
    required this.merRefenceNo,
  });
}
