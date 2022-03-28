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

class ReportDetailsViewModel extends BaseViewModel with AppHelper {
  late HotelReservation booking;
  final _apiService = locator<ApiService>();

  iniData(HotelReservation hotelReservation) {
    booking = hotelReservation;
  }

  void resendEmail(BuildContext context, String email) async {
    final AppRepo appRepo = Provider.of<AppRepo>(context, listen: false);
    final propertyId = appRepo.selectedProperty.hotelId!;
    // final bookingNo = booking.uniqueID!.oTA;
    final bookingId = booking.uniqueID!.otaId;
    progressDialog("Please wait...", context);
    try {
      final response = await _apiService.resendEmail(
        email,
        "$propertyId",
        "$bookingId",
      );
      hideProgressDialog(context);
      if (response["result"] != null) {
        DialogHelper.showErrorDialog(
          context,
          "Done",
          response["result"],
          showTitle: false
        );
      }
    } catch (e) {
      hideProgressDialog(context);
      DialogHelper.showErrorDialog(context, "Error", SOMETHING_WRONG_TEXT);
      myPrint(e.toString());
    }
  }

  void collectPaymentRequest(BuildContext context, String email) async {
    final AppRepo appRepo = Provider.of<AppRepo>(context, listen: false);
    final propertyId = appRepo.selectedProperty.hotelId!;
    final bookingNo = booking.uniqueID!.iD;
    final bookingId = booking.uniqueID!.otaId;
    progressDialog("Please wait...", context);
    try {
      final response = await _apiService.collectPyment(
          email, "$propertyId", "$bookingNo", "$bookingId");
      hideProgressDialog(context);
      if (response["result"] != null) {
        DialogHelper.showErrorDialog(
          context,
          "Done",
          response["result"],
          showTitle: false
        );
      }
    } catch (e) {
      hideProgressDialog(context);
      DialogHelper.showErrorDialog(context, "Error", SOMETHING_WRONG_TEXT);
      myPrint(e.toString());
    }
  }
}
