import 'package:channel_connect/app/locator.dart';
import 'package:channel_connect/model/nav_data.dart';
import 'package:channel_connect/model/ota_property_data.dart';
import 'package:channel_connect/network/api_service.dart';
import 'package:channel_connect/prefrence_util/Prefs.dart';
import 'package:channel_connect/util/constants.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/material.dart';

class AppRepo extends ChangeNotifier {
  bool _login = false;
  bool _introDone = false;
  String? _name;
  final _apiService = locator<ApiService>();

  late OtaPropertyData _otaPropertyData;
  late PropertyDetail _selectedProperty;

  late DrawerEnum _selectedNavigationItem;
  late RoomTypes? _selectedInvetoryRoomType;
  late RatePlans? _selectedRateRoomType;
  DateTime _selectedDateTime = DateTime.now();

  init() async {
    try {
      _login = await Prefs.login;
      _name = await Prefs.name;
      _selectedNavigationItem = DrawerEnum.dashboard;
    } catch (e) {
      myPrint(e.toString());
    }
    if (_login) {
      //fetchUser();
    }
  }

  bool get login => _login;
  OtaPropertyData get otaPropertyData => _otaPropertyData;
  DrawerEnum get selectedNavigationItem => _selectedNavigationItem;
  PropertyDetail get selectedProperty => _selectedProperty;
  RoomTypes? get selectedInventoryRoomType => _selectedInvetoryRoomType;
  RatePlans? get selectedRateRoomType => _selectedRateRoomType;
  DateTime get selectedDateTime => _selectedDateTime;

  setDrawerNavigationItem(DrawerEnum value) {
    _selectedNavigationItem = value;
    notifyListeners();
  }

  setSelectedDateTime(DateTime value) {
    _selectedDateTime = value;
    notifyListeners();
  }

  setSelectedProperty(PropertyDetail detail) {
    _selectedProperty = detail;
    _selectedNavigationItem = DrawerEnum.dashboard;
    if (detail.roomTypes!.isNotEmpty) {
      _selectedInvetoryRoomType = detail.roomTypes![0];
      _selectedRateRoomType = detail.roomTypes![0].ratePlans![0];
    } else {
      _selectedInvetoryRoomType = null;
      _selectedRateRoomType = null;
    }
    notifyListeners();
  }

  setSelectedInventoryRoomType(RoomTypes type) {
    _selectedInvetoryRoomType = type;
    _selectedRateRoomType = type.ratePlans![0];
    notifyListeners();
  }

  setSelectedRateRoomType(RatePlans type) {
    _selectedRateRoomType = type;
    notifyListeners();
  }

  setOtaPropertyData(OtaPropertyData data) {
    _otaPropertyData = data;
    notifyListeners();
  }

  void fetchUser(BuildContext context) async {
    try {
      final username = await Prefs.username;
      final password = await Prefs.password;
      final response = await _apiService.fetchUser(username, password);
      final OtaPropertyData data = response.data!;
      setOtaPropertyData(data);
      setSelectedProperty(data.oTAPropertiesRS![0].propertyDetail![0]);
      Utility.pushToDashBoard(context);
    } catch (e) {
      print(e.toString());
      Utility.showSnackBar(context, SOMETHING_WRONG_TEXT);
    }
  }

  List<NavData> getNavigationItem() {
    final List<NavData> list = [];
    list.add(NavData(
        name: Constants.inventoryRate,
        icon: Icons.apps,
        drawerEnum: DrawerEnum.dashboard));
    // list.add(NavData(
    //     name: Constants.propertyManagement,
    //     icon: Icons.home_outlined,
    //     drawerEnum: DrawerEnum.proprtyManagement));
    // list.add(NavData(
    //     name: Constants.rateManagement,
    //     icon: Icons.home_outlined,
    //     drawerEnum: DrawerEnum.rateManagement));
    // list.add(NavData(
    //     name: Constants.inventoryManagement,
    //     icon: Icons.home_outlined,
    //     drawerEnum: DrawerEnum.inventoryManagement));
    // list.add(NavData(
    //     name: Constants.bulk,
    //     icon: Icons.home_outlined,
    //     drawerEnum: DrawerEnum.bulk));
    // list.add(NavData(
    //     name: Constants.rateLinkage,
    //     icon: Icons.home_outlined,
    //     drawerEnum: DrawerEnum.rateLinkage));
    // list.add(NavData(
    //     name: Constants.promotions,
    //     icon: Icons.home_outlined,
    //     drawerEnum: DrawerEnum.promotions));
    list.add(NavData(
        name: Constants.reports,
        icon: Icons.receipt,
        drawerEnum: DrawerEnum.reports));
    // list.add(NavData(
    //     name: Constants.configuration,
    //     icon: Icons.home_outlined,
    //     drawerEnum: DrawerEnum.configuration));
    list.add(NavData(
        name: Constants.collectPayment,
        icon: Icons.payment,
        drawerEnum: DrawerEnum.collectPayment));
    list.add(NavData(
        name: Constants.help,
        icon: Icons.help_outline_rounded,
        drawerEnum: DrawerEnum.help));
    list.add(NavData(
        name: Constants.logout,
        icon: Icons.logout_outlined,
        drawerEnum: DrawerEnum.logout));
    return list;
  }
}

enum DrawerEnum {
  dashboard,
  proprtyManagement,
  rateManagement,
  inventoryManagement,
  bulk,
  rateLinkage,
  promotions,
  reports,
  configuration,
  help,
  logout,
  collectPayment
}
