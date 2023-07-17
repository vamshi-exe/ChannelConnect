import 'package:channel_connect/page/report/report_view.dart';
import 'package:channel_connect/page/splash/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'app/app_repo.dart';
import 'app/locator.dart';
import 'page/dashboard/dashboard_page.dart';
import 'page/login/login_page.dart';
import 'prefrence_util/Prefs.dart';
import 'util/app_color.dart';
import 'util/utility.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setUpLocator();
  final model = AppRepo();
  //await model.init();
  final login = await Prefs.login;
  myPrint("start login is $login");
  runApp(MyApp(
    repo: model,
    login: login,
  ));
}

final routies = {
  '/HomePage': (BuildContext context) => DashboardPage(),
  '/LoginPage': (BuildContext context) => LoginPage(),
};

class MyApp extends StatelessWidget {
  final AppRepo? repo;
  final bool? login;

  const MyApp({Key? key,  this.repo, this.login}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<AppRepo>.value(value: repo!)],
      child: MaterialApp(
        color: AppColors.backgroundColor,
        title: 'Channel Connect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.pink,
            focusColor: Colors.blueGrey,
            appBarTheme: AppBarTheme(
              color: AppColors.mainColor, systemOverlayStyle: SystemUiOverlayStyle.light
            ),
            textTheme:
                GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)),
        home: SplashPage(),
        // home: Scaffold(
        //   appBar: AppBar(),
        //   body: ReportView()),
        routes: routies,
      ),
    );
  }
}