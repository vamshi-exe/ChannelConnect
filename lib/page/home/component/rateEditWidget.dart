import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:channel_connect/app/app_dialog_text_feild.dart';
import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/model/ota_property_data.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_view.dart';
import 'channelRowWidget.dart';

class RateEditWidget extends StatefulWidget {
  const RateEditWidget({
    Key? key,
    required this.onSaveClicked,
    required this.channelsList,
  }) : super(key: key);
  final Function(List<Channels>, String single, String ddouble, String triple,
      String quad, bool? stopSell) onSaveClicked;

  final List<Channels> channelsList;

  @override
  State<RateEditWidget> createState() => _RateEditWidgetState();
}

class _RateEditWidgetState extends State<RateEditWidget> {
  int value = 1;
  final singleRoomController = TextEditingController();
  final doubleRoomController = TextEditingController();
  final tripleRoomController = TextEditingController();
  final quadRoomController = TextEditingController();
  late Channels selectedChennel;
  List<Channels> _channelsList = [];

  bool _channelError = false;
  String? _singleError;
  String? _doubleError;
  String? _tripleError;
  String? _quadError;

  @override
  void initState() {
    _updateChannelsList();
    super.initState();
  }

  _updateChannelsList() {
    final repo = Provider.of<AppRepo>(context, listen: false);
    for (var item in widget.channelsList) {
      item.selected = true;
      _channelsList.add(item);
    }
    // _channelsList.insert(0, Channels());
    // _channelsList.insert(0, Channels());
    _channelsList.insert(0, Channels());
  }

  _buildTextFeildRow(
      String title, TextEditingController controller, String? errorText) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Row(
              children: [
                Text("$title"),
                // const SizedBox(
                //   width: 5,
                // ),
                // Icon(
                //   Icons.info,
                //   color: AppColors.grey500,
                // ),
              ],
            )),
            Expanded(
                child: AppDialogTextFeild(
              controller: controller,
              // error: error,
              errorText: errorText,
            ))
          ],
        ),
        Divider()
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
            // const SizedBox(
            //   width: 5,
            // ),
            // Icon(
            //   Icons.info,
            //   color: AppColors.grey500,
            // ),
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

  @override
  Widget build(BuildContext context) {
    final appRepo = Provider.of<AppRepo>(context, listen: false);
    final selectedRatePlan = appRepo.selectedRateRoomType!;
    return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        content: SingleChildScrollView(
          child: Container(
              // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15, right: 8, top: 10, bottom: 10),
                    color: AppColors.mainColor,
                    child: Column(
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Edit Rate",
                                style: TextStyle(
                                    fontSize: 20, color: AppColors.whiteColor),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: AppColors.whiteColor,
                                visualDensity: VisualDensity.compact,
                                icon: Icon(Icons.cancel))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
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
                                    style:
                                        TextStyle(color: AppColors.redAccent),
                                  ),
                                ],
                              ),
                            )),
                        const Divider(),
                        selectedRatePlan.rateMaxOccupancy! > 0
                            ? _buildTextFeildRow(
                                "Single", singleRoomController, _singleError)
                            : Container(),
                        selectedRatePlan.rateMaxOccupancy! > 1
                            ? _buildTextFeildRow(
                                "Double",
                                doubleRoomController,
                                _doubleError,
                              )
                            : Container(),
                        selectedRatePlan.rateMaxOccupancy! > 2
                            ? _buildTextFeildRow(
                                "Triple",
                                tripleRoomController,
                                _tripleError,
                              )
                            : Container(),
                        selectedRatePlan.rateMaxOccupancy! >= 4
                            ? _buildTextFeildRow(
                                "Quad", quadRoomController, _quadError)
                            : Container(),
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
                                    Stack(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: AnimatedToggleSwitch<int>.rolling(
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
                                            onTap: () {
                                              setState(() {
                                                if (value == 0) {
                                                  value = 1;
                                                } else if (value == 1) {
                                                  value = 2;
                                                } else {
                                                  value = 0;
                                                }
                                              });
                                            },
                                            // onChanged: (i) => setState(() => value = i),
                                            //iconBuilder: iconBuilder,
                                            onChanged: (i) => myPrint("$i"),
                                          ),
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
                      ],
                    ),
                  ),
                  const Divider(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  _singleError = null;
                                  _doubleError = null;
                                  _tripleError = null;
                                  _quadError = null;
                                });
                                final minRate =
                                    appRepo.selectedRateRoomType!.minRate!;
                                final maxRate =
                                    appRepo.selectedRateRoomType!.maxRate!;
                                final singleRate = int.parse(
                                    singleRoomController.text.isNotEmpty
                                        ? singleRoomController.text
                                        : "0");
                                final doubleRate = int.parse(
                                    doubleRoomController.text.isNotEmpty
                                        ? doubleRoomController.text
                                        : "0");
                                final tripleRate = int.parse(
                                    tripleRoomController.text.isNotEmpty
                                        ? tripleRoomController.text
                                        : "0");
                                final quadRate = int.parse(
                                    quadRoomController.text.isNotEmpty
                                        ? quadRoomController.text
                                        : "0");

                                _validateChannel();
                                if (_channelError) {
                                  return;
                                }

                                _checkSingleRate(singleRate, minRate, maxRate);
                                _checkDoubleRate(
                                    doubleRate, singleRate, minRate, maxRate);
                                _checkTripleRate(tripleRate, doubleRate,
                                    singleRate, minRate, maxRate);
                                _checkQuadRate(quadRate, tripleRate, doubleRate,
                                    singleRate, minRate, maxRate);

                                setState(() {});
                                if (_singleError == null &&
                                    _doubleError == null &&
                                    _tripleError == null &&
                                    _quadError == null) {
                                  Navigator.pop(context);
                                  widget.onSaveClicked(
                                    _channelsList,
                                    singleRoomController.text,
                                    doubleRoomController.text,
                                    tripleRoomController.text,
                                    quadRoomController.text,
                                    value == 2
                                        ? true
                                        : value == 1
                                            ? null
                                            : false,
                                  );
                                }
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
              )),
        ));
  }

  _checkSingleRate(int singleRate, double minRate, double maxRate) {
    if (singleRoomController.text.isNotEmpty) {
      if (singleRate < minRate || singleRate > maxRate) {
        setState(() {
          _singleError = "Rate must be between $minRate to $maxRate";
        });
        return;
      }
    }
  }

  _checkDoubleRate(
      int doubleRate, int singleRate, double minRate, double maxRate) {
    if (doubleRoomController.text.isNotEmpty) {
      if (singleRoomController.text.isNotEmpty) {
        if (doubleRate < singleRate || doubleRate > maxRate) {
          setState(() {
            _doubleError = "Rate must be between $singleRate to $maxRate";
          });
        }
      } else {
        if (doubleRate < minRate || doubleRate > maxRate) {
          setState(() {
            _doubleError = "Rate must be between $minRate to $maxRate";
          });
        }
      }
    }
  }

  _checkTripleRate(int tripleRate, int doubleRate, int singleRate,
      double minRate, double maxRate) {
    if (tripleRoomController.text.isNotEmpty) {
      if (doubleRoomController.text.isNotEmpty) {
        if (tripleRate < doubleRate || tripleRate > maxRate) {
          setState(() {
            _tripleError = "Rate must be between $doubleRate to $maxRate";
          });
        }
      } else if (singleRoomController.text.isNotEmpty) {
        if (tripleRate < singleRate || tripleRate > maxRate) {
          setState(() {
            _tripleError = "Rate must be between $singleRate to $maxRate";
          });
        }
      } else {
        if (tripleRate < minRate || tripleRate > maxRate) {
          setState(() {
            _tripleError = "Rate must be between $minRate to $maxRate";
          });
        }
      }
    }
  }

  _checkQuadRate(int quadRate, int tripleRate, int doubleRate, int singleRate,
      double minRate, double maxRate) {
    if (quadRoomController.text.isNotEmpty) {
      if (tripleRoomController.text.isNotEmpty) {
        if (quadRate < tripleRate || quadRate > maxRate) {
          setState(() {
            _quadError = "Rate must be between $tripleRate to $maxRate";
          });
        }
      } else if (doubleRoomController.text.isNotEmpty) {
        if (quadRate < doubleRate || quadRate > maxRate) {
          setState(() {
            _quadError = "Rate must be between $doubleRate to $maxRate";
          });
        }
      } else if (singleRoomController.text.isNotEmpty) {
        if (quadRate < singleRate || quadRate > maxRate) {
          setState(() {
            _quadError = "Rate must be between $singleRate to $maxRate";
          });
        }
      } else {
        if (quadRate < minRate || quadRate > maxRate) {
          setState(() {
            _quadError = "Rate must be between $minRate to $maxRate";
          });
        }
      }
    }
  }

  _validateChannel() {
    setState(() {
      _channelError = false;
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
