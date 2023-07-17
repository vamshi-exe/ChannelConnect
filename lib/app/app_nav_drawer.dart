import 'package:channel_connect/model/ota_property_data.dart';
import 'package:channel_connect/page/Collect_Payment/collectPayment_list.dart';
import 'package:channel_connect/prefrence_util/Prefs.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/app_image.dart';
import 'package:channel_connect/util/dialog_helper.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_repo.dart';

class AppNavDrawer extends StatelessWidget {
  const AppNavDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<AppRepo>(context, listen: false);
    return Drawer(
      backgroundColor: AppColors.mainDarkColor,
      child: MediaQuery.removeViewPadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: [
            Container(
              width: double.maxFinite,
              //height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFF1f496e),
                      Color(0xFF4b9adf),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Image.asset(
                    AppImages.logo,
                    height: 60,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButton<PropertyDetail>(
                            underline: const SizedBox(),
                            iconEnabledColor: AppColors.whiteColor,
                            iconDisabledColor: AppColors.whiteColor,
                            //isDense: true,
                            isExpanded: true,
                            style: TextStyle(color: AppColors.whiteColor),
                            dropdownColor: AppColors.mainDarkColor,
                            items: repo.otaPropertyData.oTAPropertiesRS![0]
                                .propertyDetail!
                                .map((e) => DropdownMenuItem<PropertyDetail>(
                                    value: e, child: Text("${e.hotelName}")))
                                .toList(),
                            value: repo.selectedProperty,
                            onChanged: (value) {
                              Navigator.pop(context);
                              repo.setSelectedProperty(value!);
                              Utility.pushToDashBoard(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Column(
              children: repo
                  .getNavigationItem()
                  .map((e) => ListTile(
                        title: Text(e.name),
                        textColor: AppColors.whiteColor,
                        iconColor: AppColors.whiteColor,
                        leading: Icon(e.icon),
                        dense: false,
                        onTap: () {
                          if (e.drawerEnum == DrawerEnum.logout) {
                            DialogHelper.showLogoutDialog(context, () async {
                              Prefs.clear();
                              Utility.pushToLogin(context);
                            });
                          } else if (e.drawerEnum ==
                              DrawerEnum.collectPayment) {
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CollectPaymentList(
                                    // hotelId: repo.selectedProperty.hotelId
                                    //     .toString(),
                                    )));
                          } else {
                            Navigator.pop(context);
                            repo.setDrawerNavigationItem(e.drawerEnum);
                          }
                        },
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
