import 'dart:io';

import 'package:channel_connect/app/app_helper.dart';
import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/app/locator.dart';
import 'package:channel_connect/model/ota_property_data.dart';
import 'package:channel_connect/network/api_service.dart';
import 'package:channel_connect/prefrence_util/Prefs.dart';
import 'package:channel_connect/util/dialog_helper.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:store_redirect/store_redirect.dart';

class LoginViewModel extends BaseViewModel with AppHelper {
  final usernameController =
      TextEditingController(text: "rucha.betigeri@avenues.info");
  final passwordController = TextEditingController(text: "test@123");
  final _apiService = locator<ApiService>();

  void loginUser(BuildContext context) async {
    try {
      progressDialog("Please wait...", context);
      final response = await _apiService.fetchUser(
          usernameController.text, passwordController.text);
      hideProgressDialog(context);
      final OtaPropertyData data = response.data!;
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;

      await Prefs.setUserName(usernameController.text);
      await Prefs.setPassword(passwordController.text);
      await Prefs.setLoginDate(Utility.formattedDeviceDate(DateTime.now()));

      Provider.of<AppRepo>(context, listen: false).setOtaPropertyData(data);
      Provider.of<AppRepo>(context, listen: false)
          .setSelectedProperty(data.oTAPropertiesRS![0].propertyDetail![0]);

      if (version != data.version) {
        String msg = "";
        if (Platform.isIOS) {
          msg =
              "There is new version available for download !\nPlease update the app by visiting App Store.";
        } else {
          msg =
              "There is new version available for download !\nPlease update the app by visiting Google Play Store.";
        }
        DialogHelper.showUpdateDialog(context, "Update Available", msg,
            () async {
          Navigator.pop(context);
          await Prefs.setLogin(true);
          Utility.pushToDashBoard(context);
        }, () {
          StoreRedirect.redirect(iOSAppId: "1227658357");
        }, showCancel: (data.update == "optional"));
      } else {
        await Prefs.setLogin(true);
        Utility.pushToDashBoard(context);
      }
    } catch (e) {
      hideProgressDialog(context);
      print(e.toString());
      DialogHelper.showErrorDialog(context, "Error", e.toString());
    }
  }
}
