import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/model/ota_property_data.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'channelRowWidget.dart';

class InventoryEditWidget extends StatefulWidget {
  const InventoryEditWidget({
    Key? key,
    required this.onSaveClicked,
    required this.channelList,
  }) : super(key: key);

  final Function(String inventory, bool? stopSell, List<Channels>)
      onSaveClicked;
  final List<Channels> channelList;

  @override
  State<InventoryEditWidget> createState() => _InventoryEditWidgetState();
}

class _InventoryEditWidgetState extends State<InventoryEditWidget> {
  int value = 1;
  final _inventoryController = TextEditingController();
  late Channels selectedChennel;
  List<Channels> _channelsList = [];
  bool _channelError = false;
  bool _isInventoryError = false;
  String? _inventoryErrorText;

  @override
  void initState() {
    _updateChannelsList();
    super.initState();
  }

  _updateChannelsList() {
    for (var i = 0; i < widget.channelList.length; i++) {
      widget.channelList[i].selected = true;
      _channelsList.add(widget.channelList[i]);
    }
    // _channelsList.addAll(widget.channelList);
    // _channelsList.insert(0, Channels());
    _channelsList.insert(0, Channels());
    // _channelsList.insert(0, Channels());
  }

  _buildDropDownRow(String title) {
    final selectedChannels =
        _channelsList.where((element) => (element.selected ?? false)).toList();
    final text = "${selectedChannels.length} Channels Selected";
    return Row(
      children: [
        Expanded(
            child: Row(
          children: [
            Text("$title"),
          ],
        )),
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  border: Border.all(color: AppColors.mainColor, width: 1.5),
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child:
                  //(widget.isInventory) ?
                  DropdownButton<Channels>(
                      //value: selectedChennel,
                      hint: Text(
                        "$text",
                        style: TextStyle(fontSize: 10),
                      ),
                      isDense: true,
                      underline: SizedBox(),
                      isExpanded: true,
                      onTap: () => {},
                      items: List.generate(
                          _channelsList.length,
                          (index) => DropdownMenuItem<Channels>(
                              //onTap: () {},
                              value: _channelsList[index],
                              child: ChannelsRowWidget(
                                selectedText: text,
                                allSelected: !_channelError,
                                channels: _channelsList[index],
                                index: index,
                                onCheckChanged: () {
                                  _validateChannel();
                                },
                                onSelctAllClicked: () {
                                  _selectAllChannels();
                                  _validateChannel();
                                },
                                onDeselectAllClicked: () {
                                  // print("deselect clicked");
                                  _deSelectAllChannels();
                                  _validateChannel();
                                },
                              ))),
                      onChanged: (value) {
                        // setState(() {
                        //   selectedChennel = value!;
                        // });
                      })),
        )
      ],
    );
  }

  _selectAllChannels() {
    // final List<Channels> list = [];
    // list.addAll(_channelsList);
    for (var i = 0; i < _channelsList.length; i++) {
      if (i != 0) {
        _channelsList[i].selected = true;
      }
    }

    Navigator.pop(context);
    setState(() {});
  }

  _deSelectAllChannels() {
    for (var i = 0; i < _channelsList.length; i++) {
      if (i != 0) {
        _channelsList[i].selected = false;
      }
    }
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        content: Container(
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      right: 8, left: 15, top: 10, bottom: 10),
                  color: AppColors.mainColor,
                  child: Column(
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Edit Inventory",
                              style: TextStyle(
                                  fontSize: 20, color: AppColors.whiteColor),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              visualDensity: VisualDensity.compact,
                              color: AppColors.whiteColor,
                              icon: Icon(Icons.cancel))
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  child: Column(
                    children: [
                      _buildDropDownRow("Channels"),
                      Visibility(
                          visible: _channelError,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Please select at least 1 channel",
                                  textAlign: TextAlign.end,
                                  textScaleFactor: 0.7,
                                  style: TextStyle(color: AppColors.redAccent),
                                ),
                              ],
                            ),
                          )),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(child: Text("Room Inventory")),
                          Expanded(
                              child: TextField(
                            controller: _inventoryController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3),
                            ],
                            decoration: InputDecoration(
                              isDense: true,
                              errorText: _inventoryErrorText,
                              errorMaxLines: 2,
                              errorStyle: TextStyle(fontSize: 10),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.mainColor, width: 1.5),
                                  borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.mainColor, width: 1.5),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ))
                        ],
                      ),
                      Divider(),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text("Stop Sell")),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "OFF",
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 9),
                                  ),
                                  //  SizedBox(width: 5,),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Stack(
                                      children: [
                                        AnimatedToggleSwitch<int>.rolling(
                                          borderColor: Colors.transparent,
                                          current: value,
                                          height: 32,
                                          innerColor: value == 0
                                              ? Colors.greenAccent
                                              : value == 1
                                                  ? AppColors.grey500
                                                  : AppColors.redAccent,
                                          indicatorSize: Size(28, 28),
                                          indicatorColor: CupertinoColors.white,
                                          values: [0, 1, 2],
                                          onTap: null,
                                          // onTap: () {
                                          //   setState(() {
                                          //     if (value == 0) {
                                          //       value = 1;
                                          //     } else if (value == 1) {
                                          //       value = 2;
                                          //     } else {
                                          //       value = 0;
                                          //     }
                                          //   });
                                          // },
                                          // onChanged: (i) => setState(() => value = i),
                                          //iconBuilder: iconBuilder,
                                          onChanged: (i) => myPrint("$i"),
                                        ),
                                        Container(
                                          width: 80,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              //  color: AppColors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          value = 0;
                                                        });
                                                      },
                                                      child: Container(
                                                        height: double.maxFinite,
                                                        child: Text("")))),
                                              Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                         setState(() {
                                                          value = 1;
                                                        });
                                                      },
                                                      child: Container(
                                                        height: double.maxFinite,
                                                        child: Text("")))),
                                              Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                         setState(() {
                                                          value = 2;
                                                        });
                                                      },
                                                      child: Container(
                                                        height: double.maxFinite,
                                                        child: Text("")))),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  //  SizedBox(width: 8,),
                                  Text(
                                    "ON",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 9),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //
                    ],
                  ),
                ),
                //Divider(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            color: AppColors.grey300,
                            child: Text("CANCEL")),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: MaterialButton(
                            onPressed: () {
                              _validateChannel();
                              if (_channelError) {
                                return;
                              }
                              if (_inventoryController.text.isNotEmpty) {
                                final amount =
                                    int.parse(_inventoryController.text);
                                if (amount > 999) {
                                  setState(() {
                                    _inventoryErrorText =
                                        "Must be in range of 0 to 999";
                                  });
                                  return;
                                }
                              }
                              Navigator.pop(context);
                              widget.onSaveClicked(
                                  _inventoryController.text,
                                  value == 2
                                      ? true
                                      : value == 1
                                          ? null
                                          : false,
                                  _channelsList);
                            },
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            textColor: Colors.white,
                            color: AppColors.mainColor,
                            child: Text("SAVE")),
                      ),
                    ],
                  ),
                )
              ],
            )));
  }

  _validateChannel() {
    setState(() {
      _channelError = false;
      _inventoryErrorText = null;
    });
    final list =
        _channelsList.where((element) => element.selected ?? false).toList();
    setState(() {
      _channelError = list.isEmpty;
    });
  }

  Widget iconBuilder(int i, Size size, bool active) {
    IconData data = Icons.access_time_rounded;
    if (i.isEven) data = Icons.cancel;
    return Icon(
      data,
      size: size.shortestSide,
    );
  }
}
