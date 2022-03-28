import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import 'locator.dart';

abstract class AppHelper {
  var isLoading = false;
  final _dialogService = locator<DialogService>();
  final _navigatorService  = locator<NavigationService>();


  showProgressDialogService(var messgae){
    isLoading = true;
    _dialogService.showCustomDialog(variant: DialogType.progress,description: messgae);
  }
  hideProgressDialogService(){
    if (isLoading) {
      _navigatorService.back();
      isLoading = false;
    }
  }

  progressDialog( var message,BuildContext context) {
    isLoading = true;
   // _dialogService.showCustomDialog(variant: DialogType.progress,description: message);
    showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (context) {
          return  AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              content:  WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child:  Container(
                    color: Colors.white,
                    child:  Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // new SizedBox(height: 10,
                         CircularProgressIndicator(),
                        //),

                         Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            message,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        )
                      ],
                    ),
                  )));
        });
  }

  hideProgressDialog(BuildContext context) {
    if (isLoading) {
   //   _navigatorService.back();
      Navigator.pop(context);
      isLoading = false;
    }
  }
}
