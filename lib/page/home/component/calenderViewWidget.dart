import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/model/inventory_data.dart';
import 'package:channel_connect/model/ota_property_data.dart';
import 'package:channel_connect/model/rate_data.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../home_viewmodel.dart';

class CalenderView extends ViewModelWidget<HomeViewModel> {
  CalenderView(
      {Key? key,
      required this.selectedRoomType,
      required this.onRoomChanged,
      required this.onRateChanged,
      required this.selctedRatePlanType,
      this.onInventoryListUpdated,
      this.onRateListUpdated,
      required this.isInventory})
      : super(key: key);

  RoomTypes? selectedRoomType;
  RatePlans? selctedRatePlanType;
  Function(RoomTypes) onRoomChanged;
  Function(RatePlans) onRateChanged;
  Function(List<InventoryData>)? onInventoryListUpdated;
  Function(List<RateData>)? onRateListUpdated;

  bool isInventory;

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    final repo = Provider.of<AppRepo>(context);
    return Consumer<AppRepo>(
        builder: (context, repo, child) => SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    color: AppColors.grey200,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repo.selectedProperty.hotelName! + "",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                border: Border.all(
                                    color: AppColors.mainColor, width: 1.5),
                                borderRadius: BorderRadius.circular(5)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child:
                                //(  isInventory) ?
                                DropdownButton<RoomTypes>(
                                    value: selectedRoomType,
                                    isDense: true,
                                    underline: SizedBox(),
                                    isExpanded: true,
                                    items: repo.selectedProperty.roomTypes!
                                        .map((e) => DropdownMenuItem<RoomTypes>(
                                            value: e,
                                            child: Text("${e.roomName}")))
                                        .toList(),
                                    onChanged: (value) {
                                      //setState(() {
                                      selectedRoomType = value!;
                                      // });
                                      onRoomChanged(value);
                                      if(isInventory){  
                                         model.fetchInvenoryCalenderData(repo);
                                      }else{
                                         model.fetchRateCalenderData(repo);
                                      }
                                     
                                    })),
                        Visibility(
                          visible: !isInventory,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Rate Plan",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    border: Border.all(
                                        color: AppColors.mainColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(5)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: DropdownButton<RatePlans>(
                                    value: selctedRatePlanType,
                                    isDense: true,
                                    underline: SizedBox(),
                                    isExpanded: true,
                                    items: repo
                                        .selectedInventoryRoomType!.ratePlans!
                                        .map((e) => DropdownMenuItem<RatePlans>(
                                            value: e,
                                            child: Text("${e.rateName}")))
                                        .toList(),
                                    onChanged: (value) {
                                      // setState(() {
                                      selctedRatePlanType = value!;
                                      //});

                                      onRateChanged(value);
                                      model.fetchRateCalenderData(repo);
                                    }),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                // const SizedBox(
                //   height: 15,
                // ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: repo.selectedDateTime.month ==
                                          DateTime.now().month &&
                                      repo.selectedDateTime.year ==
                                          DateTime.now().year
                                  ? null
                                  : () {
                                      model.updateSelectedDateTime(
                                          repo,
                                          isInventory,
                                          DateTime(
                                              repo.selectedDateTime.year,
                                              repo.selectedDateTime.month - 1,
                                              repo.selectedDateTime.day));
                                    },
                              icon: Icon(
                                Icons.chevron_left,
                                //color: AppColors.whiteColor,
                              )),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                model.showYearMonthChangeDialog(
                                    context, repo, isInventory);
                              },
                              child: Text(
                                Utility.getMonthName(
                                        repo.selectedDateTime.month) +
                                    " " +
                                    repo.selectedDateTime.year.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.mainColor,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: repo.selectedDateTime.year ==
                                          DateTime(DateTime.now().year + 1)
                                              .year &&
                                      repo.selectedDateTime.month ==
                                          DateTime.now().month - 1
                                  ? null
                                  : () {
                                      model.updateSelectedDateTime(
                                          repo,
                                          isInventory,
                                          DateTime(
                                              repo.selectedDateTime.year,
                                              repo.selectedDateTime.month + 1,
                                              repo.selectedDateTime.day));
                                      //final CurrentDateTime = DateTime.now();
                                    },
                              icon: Icon(Icons.chevron_right)),
                        ],
                      ),
                      Container(
                        // color: AppColors.blueLight,
                        child: Column(
                          children: [
                            MediaQuery.removePadding(
                              context: context,
                              removeBottom: true,
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 7,
                                        crossAxisSpacing: 2.0,
                                        mainAxisSpacing: 1.0),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 7,
                                itemBuilder: (_, index) => _getWeekNameWidget(
                                    model.weekNameList[index]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //SizedBox(height: 10,),
                      (!model.loading)
                          ? (!model.error)
                              ? GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                  ),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: isInventory
                                      ? model.inventoryList.length
                                      : model.rateList.length,
                                  itemBuilder: (_, index) {
                                    if (isInventory) {
                                      return _getDayWidget(
                                          model.inventoryList[index].dateTime!,
                                          model.inventoryList[index].stopSell,
                                          model.inventoryList[index].invCount ??
                                              0,
                                          model.inventoryList[index].selected ??
                                              false,
                                               model.inventoryList[index].isMap??true?
                                              "No Inventory Available":"No online rooms are mapped",
                                               onDateSelected: () {
                                        if (model.inventoryList[index]
                                                .stopSell ==
                                            null || DateTime.now().difference( model.inventoryList[index].dateTime!).inDays > 0
                                           ) {
                                          // Utility.showSnackBar(
                                          //     context, "Invalid Date");
                                        } else {
                                          model.updateInventoryDateSelected(
                                              model.inventoryList[index]);
                                          onInventoryListUpdated!(
                                              model.inventoryList);
                                        }
                                      });
                                    } else {
                                      return _getDayWidget(
                                          model.rateList[index].dateTime!,
                                          model.rateList[index].stopSell,
                                          model.rateList[index].ddouble!
                                              .toInt(),
                                          model.rateList[index].selected ??
                                              false,
                                              model.rateList[index].isMap??true?
                                              "No Rate Available":"No online rooms are mapped", onDateSelected: () {
                                        if (model.inventoryList[index]
                                                .stopSell ==
                                            null || DateTime.now().difference( model.inventoryList[index].dateTime!).inDays > 0
                                           ) {
                                          // Utility.showSnackBar(
                                          //     context, "Invalid Date");
                                        } else {
                                          model.updateRateDateSelected(
                                              model.rateList[index]);

                                          onRateListUpdated!(model.rateList);
                                        }
                                      });
                                    }
                                  })
                              : Container(
                                  child: Text(SOMETHING_WRONG_TEXT),
                                )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            color: AppColors.calenderRedColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Stop Sell",
                            style: TextStyle(color: AppColors.grey600),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )));
  }

  _getWeekNameWidget(String name) {
    return Container(
        // color: AppColors.redAccent,
        child: Center(
            child: Text(
      "$name",
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    )));
  }

  _getDayWidget(DateTime dateTime, bool? stopSell, int count, bool selected,String toolTopText,
      {Function()? onDateSelected}) {
    return Visibility(
      visible: dateTime.year != 1980,
      child: Card(
          color: stopSell == null || DateTime.now().difference(dateTime).inDays > 0
              ? AppColors.grey300
              : selected
                  ? Colors.yellow
                  : stopSell
                      ? AppColors.calenderRedColor
                      : AppColors.calenderGreenColor,
          child: InkWell(
            onTap: onDateSelected,
            child: MyTooltip(
              message: stopSell!=null?"":"$toolTopText",
              child: Stack(
                children: [
                  Center(
                      child: Text(
                    //dateTime.day.toString(),
                    "$count",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: stopSell == null || DateTime.now().difference(dateTime).inDays > 0
                          ? AppColors.grey600
                          : stopSell
                              ? AppColors.calenderTextRedColor
                              : AppColors.calenderTextGreenColor,
                    ),
                  )),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        dateTime.day.toString(),
                        style: TextStyle(
                          fontSize: 9,
                          color: stopSell == null || DateTime.now().difference(dateTime).inDays > 0
                              ? AppColors.grey600
                              : stopSell
                                  ? AppColors.calenderTextRedColor
                                  : AppColors.calenderTextGreenColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class MyTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  const MyTooltip({required this.message, required this.child});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      enableFeedback: true,
      message: message,
      triggerMode: TooltipTriggerMode.tap,
      child: child
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
