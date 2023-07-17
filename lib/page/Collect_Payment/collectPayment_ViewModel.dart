import 'package:channel_connect/app/app_helper.dart';
import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/model/report_response_data.dart';
import 'package:channel_connect/network/api_service.dart';
import 'package:channel_connect/util/dialog_helper.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../app/locator.dart';

class CollectPaymentViewModel extends BaseViewModel with AppHelper {
  final _apiService = locator<ApiService>();
  iniData() {}

  void collectPayment_invoiceRequest(
      BuildContext context,
      String name,
      String email,
      String contactNo,
      double amount,
      String referenceNo,
      String description,
      String propertyCode) async {
    final AppRepo appRepo = Provider.of<AppRepo>(context, listen: false);
    final propertyId = appRepo.selectedProperty.hotelId!;
    // final bookingNo = booking.uniqueID!.iD;
    // final bookingId = booking.uniqueID!.otaId;
    progressDialog("Please wait...", context);
    try {
      final response = await _apiService.collectPayment_invoice(
          name,
          email,
          contactNo,
          amount,
          referenceNo,
          description,
          propertyCode);

      hideProgressDialog(context);
      if (response["ResCreationResult"] != null) {
        String result = "Unknown Error Occured.";
        if (response["ResCreationResult"][0]["Desc"] != null) {
          result = response["ResCreationResult"][0]["Desc"];
        }
        DialogHelper.showErrorDialog(context, "Done", result,
            showTitle: false);
      }
    } catch (e) {
      hideProgressDialog(context);
      DialogHelper.showErrorDialog(context, "Error", SOMETHING_WRONG_TEXT);
      myPrint(e.toString());
    }
  }
}
