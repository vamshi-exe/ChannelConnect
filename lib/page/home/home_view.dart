import 'dart:convert';
import 'dart:ui';

import 'package:channel_connect/app/app_dialog_text_feild.dart';
import 'package:channel_connect/app/app_helper.dart';
import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/app/locator.dart';
import 'package:channel_connect/model/inventory_data.dart';
import 'package:channel_connect/model/ota_property_data.dart';
import 'package:channel_connect/model/rate_data.dart';
import 'package:channel_connect/model/response_status.dart';
import 'package:channel_connect/network/api_service.dart';
import 'package:channel_connect/page/home/home_viewmodel.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/dialog_helper.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

import 'component/calenderViewWidget.dart';
import 'component/invenotyEditWidget.dart';
import 'component/rateEditWidget.dart';
import 'component/status_dialog_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with TickerProviderStateMixin, AppHelper {
  late TabController _controller;
  List<InventoryData> _inventoryList = [];
  List<RateData> _rateList = [];
  final _apiService = locator<ApiService>();
  bool _refreshData = false;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);

    super.initState();
    fcmToken();
  }

  fcmToken() async {}

  _showInventoryEditDialog(HomeViewModel model) {
    showDialog(
      context: context,
      // isScrollControlled: true,
      builder: (context) => InventoryEditWidget(
        channelList: model.channelList,
        onSaveClicked:
            (String inventory, bool? stopSell, List<Channels> channelList) {
          // print("inventory is $inventory stop sell is $stopSell");
          _updateInventotyData(model, inventory, stopSell, channelList);
        },
      ),
    );
  }

  _updateInventotyData(HomeViewModel model, String inventory, bool? stopSell,
      List<Channels> channelList) async {
    try {
      progressDialog("Please Wait...", context);
      final appRepo = Provider.of<AppRepo>(context, listen: false);
      final invCode = appRepo.selectedInventoryRoomType!.roomId!;
      final hotelName = appRepo.selectedProperty.hotelName!;
      final hotelCode = appRepo.selectedProperty.hotelId!;
      final list =
          channelList.where((element) => element.selected ?? false).toList();

      final channels = list.map((e) => e.channelCode).toList().join(",");

      final response = await _apiService.updateInventoryData(
          hotelName,
          hotelCode.toString(),
          invCode.toString(),
          inventory,
          stopSell,
          _inventoryList,
          channels);
      hideProgressDialog(context);
      final name = response["Result"][0]["roomName"];
      final id = response["Result"][0]["roomId"];
      final updateResult = response["Result"][0]["updateResult"];

      List<ResponseStatus> sucessStatusList = [];
      List<ResponseStatus> failedStatusList = [];
      for (var resultItem in updateResult) {
        if (resultItem["Success"] != null) {
          final sucessList = resultItem["Success"];
          for (var item in sucessList) {
            sucessStatusList.add(ResponseStatus.fromJson(item));
          }
        }
        if (resultItem["Failed"] != null) {
          final failedList = resultItem["Failed"];
          for (var item in failedList) {
            failedStatusList.add(ResponseStatus.fromJson(item));
          }
        }
      }
      final value = await _showStatusDialog(
          "Inventory Update", name, id, sucessStatusList, failedStatusList);
      if (_controller.index == 0) {
        _inventoryList.clear();
        model.resetInventoryList();
        model.fetchInvenoryCalenderData(appRepo);
      } else {
        _rateList.clear();
        model.resetRateList();
        model.fetchRateCalenderData(appRepo);
      }
    } catch (e) {
      hideProgressDialog(context);
      print(e.toString());
      DialogHelper.showErrorDialog(context, "Error", e.toString());
    }
  }

  _showRateEditDialog(HomeViewModel model) {
    //showModalBottomSheet(context: context, builder: builder)
    showDialog(
      context: context,
      builder: (context) => RateEditWidget(
        channelsList: model.channelList,
        onSaveClicked: (channelList, single, ddouble, triple, quad, stopSell) {
          final list = channelList
              .where((element) => element.selected ?? false)
              .toList();

          _updateRateData(
              channelList, model, single, ddouble, triple, quad, stopSell);
        },
      ),
    );
  }

  _updateRateData(
      List<Channels> channelList,
      HomeViewModel model,
      String single,
      String ddoble,
      String triple,
      String quad,
      bool? stopSell) async {
    try {
      progressDialog("Please Wait...", context);
      final appRepo = Provider.of<AppRepo>(context, listen: false);
      final invCode = appRepo.selectedInventoryRoomType!.roomId!;
      final hotelName = appRepo.selectedProperty.hotelName!;
      final hotelCode = appRepo.selectedProperty.hotelId!;
      final rateCode = appRepo.selectedRateRoomType!.rateId;
      final list =
          channelList.where((element) => element.selected ?? false).toList();

      final channels = list.map((e) => e.channelCode).toList().join(",");

      final response = await _apiService.updateRateData(
        hotelName,
        hotelCode.toString(),
        invCode.toString(),
        rateCode.toString(),
        single,
        ddoble,
        triple,
        quad,
        stopSell,
        _rateList,
        channels,
      );
      hideProgressDialog(context);
      final name = response["Result"][0]["RateName"];
      final id = response["Result"][0]["RateId"];
      final updateResult = response["Result"][0]["updateResult"];

      List<ResponseStatus> sucessStatusList = [];
      List<ResponseStatus> failedStatusList = [];

      for (var resultItem in updateResult) {
        if (resultItem["Success"] != null) {
          final sucessList = resultItem["Success"];
          for (var item in sucessList) {
            sucessStatusList.add(ResponseStatus.fromJson(item));
          }
        }
        if (resultItem["Failed"] != null) {
          final failedList = resultItem["Failed"];
          for (var item in failedList) {
            failedStatusList.add(ResponseStatus.fromJson(item));
          }
        }
      }

      final value = await _showStatusDialog(
          "Rate Update", name, id, sucessStatusList, failedStatusList);
      if (_controller.index == 0) {
        _inventoryList.clear();
        model.resetInventoryList();
        model.fetchInvenoryCalenderData(appRepo);
      } else {
        _rateList.clear();
        model.resetRateList();
        model.fetchRateCalenderData(appRepo);
      }
    } catch (e) {
      hideProgressDialog(context);
      print(e.toString());
      DialogHelper.showErrorDialog(context, "Error", e.toString());
    }
  }

  _showStatusDialog(String title, String name, String id,
      List<ResponseStatus> list, List<ResponseStatus> failedList) async {
    await showDialog(
        context: context,
        builder: (_) => StatusDialogWidget(
              title: title,
              name: name,
              code: id,
              statusList: list,
              failedList: failedList,
            ));
  }

  _floatingButtonClicked(HomeViewModel model) async {
    // final repo = Provider.of<AppRepo>(context, listen: false);
    // _refreshData = false;
    // final value =
    //     await _showStatusDialog("Inventory Update", "Luxury AC Room", "1584", [
    //   ResponseStatus(channelName: "Resavenue", channelCode: "REZ"),
    //   ResponseStatus(channelName: "Demo", channelCode: "REZ")
    // ]);
    // if (value == 0) {
    //                       model.fetchInvenoryCalenderData(repo);
    //                     } else {
    //                       model.fetchRateCalenderData(repo);
    //                     }
    // final repo = Provider.of<AppRepo>(context, listen: false);
    // repo.setSelectedInventoryRoomType(repo.selectedInventoryRoomType!);
    //Utility.pushToDashBoard(context);

    // _controller.animateTo(_controller.index);
    if (_controller.index == 0) {
      if (_inventoryList.isNotEmpty) {
        _showInventoryEditDialog(model);
      } else {
        Utility.showSnackBar(context, "No Date Selected");
      }
      //_showInventoryEditDialog();
    } else {
      if (_rateList.isNotEmpty) {
        _showRateEditDialog(model);
      } else {
        Utility.showSnackBar(context, "No Date Selected");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<AppRepo>(context, listen: false);
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.intiData(context, repo),
      builder: (context, model, child) => Consumer<AppRepo>(
        builder: (context, repo, child) => Scaffold(
          floatingActionButton:
              (_inventoryList.isNotEmpty || _rateList.isNotEmpty)
                  ? FloatingActionButton(
                      onPressed: () => _floatingButtonClicked(model),
                      child: const Icon(Icons.edit),
                    )
                  : null,
          body: Column(
            children: [
              Container(
                color: AppColors.mainColor,
                child: TabBar(
                    controller: _controller,
                    onTap: (value) {
                      // if (_controller.index != value) {
                      if (value == 0) {
                        model.fetchInvenoryCalenderData(repo);
                      } else {
                        model.fetchRateCalenderData(repo);
                        //   }
                      }
                    },
                    //labelPadding: const EdgeInsets.symmetric(vertical: 3),
                    tabs: const [
                      Tab(child: Text('INVENTORY')),
                      Tab(child: Text('RATE')),
                    ]),
              ),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    CalenderView(
                      selectedRoomType: repo.selectedInventoryRoomType,
                      isInventory: true,
                      selctedRatePlanType: repo.selectedRateRoomType,
                      onRoomChanged: (RoomTypes value) {
                        repo.setSelectedInventoryRoomType(value);
                        _inventoryList.clear();
                        _rateList.clear();
                      },
                      onRateChanged: (RatePlans value) {},
                      onInventoryListUpdated: (List<InventoryData> list) {
                        _inventoryList = list
                            .where((element) => element.selected ?? false)
                            .toList();
                        setState(() {});
                      },
                    ),
                    CalenderView(
                      selectedRoomType: repo.selectedInventoryRoomType,
                      selctedRatePlanType: repo.selectedRateRoomType,
                      isInventory: false,
                      onRoomChanged: (RoomTypes value) {
                        repo.setSelectedInventoryRoomType(value);
                         _inventoryList.clear();
                        _rateList.clear();
                      },
                      onRateChanged: (RatePlans value) {
                        repo.setSelectedRateRoomType(value);
                         _inventoryList.clear();
                        _rateList.clear();
                      },
                      onRateListUpdated: (List<RateData> list) {
                        _rateList = list
                            .where((element) => element.selected ?? false)
                            .toList();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
