import 'package:channel_connect/model/ota_property_data.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:flutter/material.dart';

class ChannelsRowWidget extends StatefulWidget {
  ChannelsRowWidget(
      {Key? key,
      required this.channels,
      required this.index,
      required this.selectedText,
      required this.onSelctAllClicked,
      required this.onDeselectAllClicked,
      required this.allSelected,
      required this.onCheckChanged})
      : super(key: key);
  Channels channels;
  final int index;
  final String selectedText;
  final Function() onSelctAllClicked;
  final Function() onDeselectAllClicked;
  final Function() onCheckChanged;
  final bool allSelected;

  @override
  _ChannelsRowWidgetState createState() => _ChannelsRowWidgetState();
}

class _ChannelsRowWidgetState extends State<ChannelsRowWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.index == 0) {
      return InkWell(
        onTap: () {
          widget.onSelctAllClicked();
        },
        child: Container(
          // color: AppColors.grey200,
          child: Row(
            children: [
              // Expanded(child: MaterialButton(
              //   color: AppColors.highLightColor,
              //   textColor: AppColors.whiteColor,
              //   padding: const EdgeInsets.symmetric(horizontal: 1,vertical: 2),
              //   elevation: 0,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(4)
              //   ),
              //   onPressed: (){
              //      widget.onSelctAllClicked();
              //   },
              //   child: Text("Select\nAll ",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 11),))),
              // SizedBox(width: 5,),
              Expanded(
                  child: MaterialButton(
                      onPressed: () {
                        if (widget.allSelected) {
                          widget.onDeselectAllClicked();
                        } else {
                          widget.onSelctAllClicked();
                        }
                        //
                      },
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1, vertical: 2),
                      color: AppColors.mainColor,
                      textColor: AppColors.whiteColor,
                      child: Text(
                        (widget.allSelected) ? "Deselect All" : "Select All",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ))),
            ],
          ),
        ),
      );
    }
    // else if (widget.index == 1) {
    //   return InkWell(
    //     onTap: () {
    //       //print("deselect called");
    //       widget.onDeselectAllClicked();
    //     },
    //     child: Container(
    //       //   color: AppColors.grey200,
    //       padding: const EdgeInsets.all(2),
    //       child: Text("Deselect All"),
    //     ),
    //   );
    // }
    else {
      return Container(
          child: CheckboxListTile(
        value: widget.channels.selected,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.all(0),
        title: Text("${widget.channels.channelName}"),
        onChanged: (value) {
          setState(() {
            widget.channels.selected = !widget.channels.selected!;
          });
          widget.onCheckChanged();
        },
      ));
    }
  }
}
