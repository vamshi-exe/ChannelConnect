import 'dart:io';
import 'package:channel_connect/page/login/login_viewmodel.dart' as model;
import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/prefrence_util/Prefs.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/app_image.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    _performNotification();
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        seconds: 3,
      ),
      vsync: this,
      value: 0.1,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linearToEaseOut,
    );

    _controller.forward();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _loading = true;
      });
      validateLogin();
    });
  }

  _performNotification() async {
    final value = await FirebaseMessaging.instance.getToken();
    myPrint("fcm is " + value!);
    Prefs.setFcmToken(value);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print("FirebaseMessaging.instance.getInitialMessage() called");
      if (message != null) {
        // setState(() {
        //   _myPage.jumpToPage(4);
        // });
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      setState(() {
        // _myPage.jumpToPage(4);
      });
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("FirebaseMessaging.onMessage.listen called ");
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        FlutterLocalNotificationsPlugin().show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                "mobile.ia.res",
                "Channel Connect",
                channelDescription: "channel Connect",
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'noti_icon',
                //largeIcon: FilePathAndroidBitmap(_bitmap)
              ),
            ));
      }
    });

    if (Platform.isIOS) {
      askNotificationPermission();
    }
  }

  askNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  validateLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('rememberMe') ?? false;

    // Future.delayed(Duration(seconds: 2), () async {
    final login = await Prefs.login;
    final lastLoginDate = await Prefs.loginDate;
    print("last login date $lastLoginDate -  current date " +
        Utility.formattedDeviceDate(DateTime.now()));
    if (rememberMe
        // login && rememberMe
        //&&
        //  Utility.formattedDeviceDate(DateTime.now()) == lastLoginDate
        ) {
      final username = await Prefs.username;
      final password = await Prefs.password;

      final repo = Provider.of<AppRepo>(context, listen: false);
      repo.fetchUser(context);
      // Utility.pushToDashBoard(context);
    } else {
      Future.delayed(Duration(seconds: 2), () {
        Utility.pushToLogin(context);
      });
    }
    //  });
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  alignment: Alignment.center,
                  scale: _animation,
                  child: Image.asset(
                    AppImages.logo,
                    width: 150,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Channel Connect",
                    style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  AppImages.resAvenueLogo,
                  width: 200,
                ),
                const SizedBox(height: 20),
                Text("A Complete Central Reservation Solution")
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 60,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
