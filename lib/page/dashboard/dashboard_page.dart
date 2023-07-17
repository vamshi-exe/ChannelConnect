import 'package:channel_connect/app/app_nav_drawer.dart';
import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/model/ota_property_data.dart';
import 'package:channel_connect/page/Collect_Payment/collectPayment_View.dart';
import 'package:channel_connect/page/home/home_view.dart';
import 'package:channel_connect/page/report/report_view.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/app_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppRepo>(
      builder: (context, repo, child) => Scaffold(
        appBar: AppBar(
          title: Image.asset(
            AppImages.loginHeader,
            height: 40,
          ),
        ),
        drawer: AppNavDrawer(),
        
        body: Builder(builder: (context) {
          if (repo.selectedNavigationItem == DrawerEnum.dashboard) {
            return HomeView();
          }
          if (repo.selectedNavigationItem == DrawerEnum.reports) {
            return ReportView();
          }
          return HomeView();
        }),
      ),
    );
  }
}


