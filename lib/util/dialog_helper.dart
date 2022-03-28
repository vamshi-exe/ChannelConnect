import 'package:flutter/material.dart';

import 'app_color.dart';

class DialogHelper {
  static showRemoveDialog(BuildContext context, var title, var desc,
      var positiveBtnText, Function positiveClick) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                    child: Text(desc,
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade600)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.mainColor,
                                fontWeight: FontWeight.w700),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text(
                            positiveBtnText,
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.mainColor,
                                fontWeight: FontWeight.w700),
                          ),
                          onPressed: () => positiveClick(),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          );
        });
  }

  // static showUpdateDialog(BuildContext context,BasicResponse response){
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context){
  //       return WillPopScope(
  //         onWillPop: ()async{
  //           return false;
  //         },
  //         child: AlertDialog(
  //           contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 5),
  //           actionsPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
  //           title: Text('New version available'),
  //           shape: RoundedRectangleBorder(
  //            borderRadius: BorderRadius.circular(6)
  //           ),
  //           content: Container(
  //             child: Text('Please, Update app to new version to continue.',style: TextStyle(fontSize: 15,color: Colors.grey.shade600),),
  //           ),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('Update',style: TextStyle(fontSize: 14),),
  //               onPressed: ()async{
  //                 if(response.isForce){
  //                   Prefs.clear();
  //                 }
  //                 //Navigator.pop(context);
  //                // StoreRedirect.redirect();
  //               },
  //             ),

  //           ],
  //         ),
  //       );
  //     }
  //   );
  // }

  static showLogoutDialog(BuildContext context, Function onClick) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 5),
            actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            title: Text('Logout'),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            content: Container(
              child: Text(
                'Are you sure you want to logout ?',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(fontSize: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('LOG OUT', style: TextStyle(fontSize: 14)),
                onPressed: () => onClick(),
              ),
            ],
          );
        });
  }

  static Future showUpdateDialog(BuildContext context, String title,
      String desc, Function() onCancelClicked, Function() onUpdateClicked, {bool showCancel = true}) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: AlertDialog(
                title: Text(title),
                content: Text(desc),
                actions: [
                   Visibility(
                     visible: showCancel,
                     child: TextButton(
                        onPressed: onCancelClicked,
                        child: Text("REMIND LATER")),
                   ),
                  TextButton(
                      onPressed: onUpdateClicked,
                      child: Text("UPDATE")),
                 
                ],
              ),
            ));
  }

  static showErrorDialog(BuildContext context, title, content,
      {bool? showTitle = true, Function()? onOkClicked}) {
    showDialog(
        //   edgeInsets: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              title: (showTitle ?? false)
                  ? Text(
                      title,
                      style: TextStyle(fontSize: 17),
                    )
                  : Container(),
              content: Text(
                content,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: AppColors.blackText),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: onOkClicked ??
                      () {
                        Navigator.pop(context);
                      },
                  child: Text('OK'),
                  textColor: AppColors.blackText,
                )
              ],
            ),
          );
        });
  }

  showNoInternetDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              content: Container(
                child: Text(
                    'No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again.'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }
}
