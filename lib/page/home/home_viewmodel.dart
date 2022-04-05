import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/app/locator.dart';
import 'package:channel_connect/model/inventory_data.dart';
import 'package:channel_connect/model/ota_property_data.dart';
import 'package:channel_connect/model/rate_data.dart';
import 'package:channel_connect/network/api_service.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'component/selectYearMonthDialog.dart';
import 'home_view.dart';

class HomeViewModel extends ChangeNotifier {
  late DateTime _selectedDateTime;
  List<String> weekNameList = ["S", "M", "T", "W", "T", "F", "S"];
  final _apiService = locator<ApiService>();
  List<InventoryData> _inventoryList = [];
  List<RateData> _rateList = [];
  List<Channels> _channelList = [];

  bool _loading = false;
  bool _isError = false;

  bool get loading => _loading;
  bool get error => _isError;
  List<InventoryData> get inventoryList => _inventoryList;
  List<RateData> get rateList => _rateList;
  List<Channels> get channelList => _channelList;

  intiData(BuildContext context, AppRepo repo) {
    // if (isInventory) {
    fetchInvenoryCalenderData(repo);
    // } else {
    //   fetchRateCalenderData(repo);
    // }
  }

  fetchRateCalenderData(AppRepo repo) async {
    final startDateTime =
        DateTime(repo.selectedDateTime.year, repo.selectedDateTime.month, 1);
    final endDateTime = DateTime(
        repo.selectedDateTime.year, repo.selectedDateTime.month + 1, 1 - 1);
    final diffrence = endDateTime.difference(startDateTime);
    try {
      _loading = true;
      _isError = false;
      final startDate = Utility.formattedServerDateForRequest(
          DateTime(repo.selectedDateTime.year, repo.selectedDateTime.month, 1));
      final endDate = Utility.formattedServerDateForRequest(DateTime(
          repo.selectedDateTime.year, repo.selectedDateTime.month + 1, 1 - 1));
      notifyListeners();
      final response = await _apiService.fetchRateCalenderData(
          repo.selectedProperty.hotelId.toString(),
          startDate,
          endDate,
          repo.selectedRateRoomType!.rateId.toString());
      _rateList = response.rateList!;
      _channelList = response.channelList!;
      if (_rateList.isNotEmpty) {
        if (_rateList.length != diffrence.inDays + 1) {
          // return date list is not complete lets add remainig dates
          final List<RateData> alteredList = [];
          for (var i = 0; i < diffrence.inDays + 1; i++) {
            final datetime = DateTime(
                startDateTime.year, startDateTime.month, startDateTime.day + i);
            final found = _rateList.indexWhere((element) =>
                element.dateTime!.year == datetime.year &&
                element.dateTime!.month == datetime.month &&
                element.dateTime!.day == datetime.day);
            if (found == -1) {
              alteredList.add(RateData(
                  stopSell: false,
                  dateTime: datetime,
                  single: 0.00,
                  ddouble: 0.0,
                  isMap: true,
                  triple: 0.0));
            } else {
              alteredList.add(_rateList[found]);
            }
          }

          _rateList.clear();
          _rateList.addAll(alteredList);
        }
        final etxraDateCount = _rateList[0].dateTime!.weekday;
        if (etxraDateCount != 7) {
          for (int i = 0; i < etxraDateCount; i++) {
            final datetime = DateTime(1980, 1, 1);
            _rateList.insert(
                0,
                RateData(
                    stopSell: false,
                    dateTime: datetime,
                    single: 0.00,
                    ddouble: 0.0,
                    triple: 0.0));
          }
        }
      }
      _loading = false;
      _isError = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      final diffrence = endDateTime.difference(startDateTime);
      _rateList.clear();
      //print("diffrence is $diffrence");
      for (var i = 0; i < diffrence.inDays + 1; i++) {
        final datetime = DateTime(
            startDateTime.year, startDateTime.month, startDateTime.day + i);
        _rateList.add(RateData(
            dateTime: datetime,
            single: 0.0,
            ddouble: 0.0,
            triple: 0.0,
            isMap: false,
            date: Utility.formattedServerDateForRequest(datetime)));
      }
      final etxraDateCount = _rateList[0].dateTime!.weekday;
      if (etxraDateCount != 7) {
        for (int i = 0; i < etxraDateCount; i++) {
          final datetime = DateTime(1980, 1, 1);
          _rateList.insert(
              0,
              RateData(
                  dateTime: datetime, single: 0.00, ddouble: 0.0, triple: 0.0));
        }
      }

      notifyListeners();
    }
  }

  fetchInvenoryCalenderData(AppRepo repo) async {
    final startDateTime =
        DateTime(repo.selectedDateTime.year, repo.selectedDateTime.month, 1);
    final endDateTime = DateTime(
        repo.selectedDateTime.year, repo.selectedDateTime.month + 1, 1 - 1);
    final diffrence = endDateTime.difference(startDateTime);

    try {
      _loading = true;
      _isError = false;
      final startDate = Utility.formattedServerDateForRequest(startDateTime);
      final endDate = Utility.formattedServerDateForRequest(endDateTime);
      notifyListeners();
      final response = await _apiService.fetchInventoryCalenderData(
          repo.selectedProperty.hotelId.toString(),
          startDate,
          endDate,
          repo.selectedInventoryRoomType!.roomId.toString());
      _inventoryList = response.inventoryList!;
      _channelList = response.channelList!;
      if (_inventoryList.isNotEmpty) {
        myPrint("${_inventoryList.length} == ${diffrence.inDays + 1}");
        if (_inventoryList.length != diffrence.inDays + 1) {
          // return date list is not complete lets add remainig dates
          final List<InventoryData> alteredList = [];
          for (var i = 0; i < diffrence.inDays + 1; i++) {
            final datetime = DateTime(
                startDateTime.year, startDateTime.month, startDateTime.day + i);
            final found = _inventoryList.indexWhere((element) =>
                element.dateTime!.year == datetime.year &&
                element.dateTime!.month == datetime.month &&
                element.dateTime!.day == datetime.day);
            if (found == -1) {
              alteredList.add(InventoryData(
                  dateTime: datetime,
                  invCount: 0,
                  isMap: true,
                  date: Utility.formattedServerDateForRequest(datetime)));
            } else {
              alteredList.add(_inventoryList[found]);
            }
          }

          _inventoryList.clear();
          _inventoryList.addAll(alteredList);
        }
        final etxraDateCount = _inventoryList[0].dateTime!.weekday;
        if (etxraDateCount != 7) {
          for (int i = 0; i < etxraDateCount; i++) {
            final datetime = DateTime(1980, 1, 1);
            _inventoryList.insert(0, InventoryData(dateTime: datetime));
          }
        }
      }

      _loading = false;
      _isError = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _inventoryList.clear();
      final diffrence = endDateTime.difference(startDateTime);

      for (var i = 0; i < diffrence.inDays + 1; i++) {
        final datetime = DateTime(
            startDateTime.year, startDateTime.month, startDateTime.day + i);
        _inventoryList.add(InventoryData(
            dateTime: datetime,
            invCount: 0,
            isMap: false,
            date: Utility.formattedServerDateForRequest(datetime)));
      }
      final etxraDateCount = _inventoryList[0].dateTime!.weekday;
      if (etxraDateCount != 7) {
        for (int i = 0; i < etxraDateCount; i++) {
          final datetime = DateTime(1980, 1, 1);
          _inventoryList.insert(0, InventoryData(dateTime: datetime));
        }
      }

      //_isError = true;
      notifyListeners();
    }
  }

  void showYearMonthChangeDialog(
      BuildContext context, AppRepo repo, bool isInventoty) async {
    final date = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: SelectYearMonthDialog(),
            ));

    if (date != null) {
      repo.setSelectedDateTime(date);
      if (isInventoty) {
        fetchInvenoryCalenderData(repo);
      } else {
        fetchRateCalenderData(repo);
      }
    }
  }

  void updateSelectedDateTime(
      AppRepo repo, bool isInventory, DateTime dateTime) {
    repo.setSelectedDateTime(dateTime);
    if (isInventory) {
      fetchInvenoryCalenderData(repo);
    } else {
      fetchRateCalenderData(repo);
    }
  }

  void updateInventoryDateSelected(InventoryData data) {
    if (data.selected == null) {
      data.selected = true;
    } else {
      data.selected = !data.selected!;
    }

    notifyListeners();
  }

  void updateRateDateSelected(RateData data) {
    if (data.selected == null) {
      data.selected = true;
    } else {
      data.selected = !data.selected!;
    }

    notifyListeners();
  }

  void resetInventoryList() {
    for (var item in _inventoryList) {
      item.selected = false;
    }
    notifyListeners();
  }

  void resetRateList() {
    for (var item in _rateList) {
      item.selected = false;
    }
    notifyListeners();
  }
}
