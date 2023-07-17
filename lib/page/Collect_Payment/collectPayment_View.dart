//vbv

import 'package:channel_connect/app/app_nav_drawer.dart';
import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/page/Collect_Payment/collectPayment_ViewModel.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/common_pattern.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../model/ota_property_data.dart';
import '../../util/dialog_helper.dart';

const List<String> list = <String>[
  'Mazong Hotel',
  'Ramoji Tara Confort',
  'PMS Test Hotel',
  'Maya Hotel',
  'City Palace A',
  'Yash'
];

class CollectPaymentView extends StatefulWidget {
  const CollectPaymentView({
    Key? key,
    required this.hotelId,
  }) : super(key: key);
  final String hotelId;
  @override
  State<CollectPaymentView> createState() => _CollectPaymentViewState();
}

class _CollectPaymentViewState extends State<CollectPaymentView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _nameError = false;
  bool _emailError = false;
  bool _contactError = false;
  bool _amountError = false;
  @override
  void initState() {
    super.initState();
  }

  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<AppRepo>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: ViewModelBuilder<CollectPaymentViewModel>.reactive(
        viewModelBuilder: () => CollectPaymentViewModel(),
        // ignore: deprecated_member_use
        onModelReady: (CollectPaymentViewModel mdoel) => mdoel.iniData(),
        builder: (_, model, child) => Scaffold(
          appBar: AppBar(
              // automaticallyImplyLeading: false,
              centerTitle: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 9.0),
                        child: Text(
                          'Collect Payment',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        elevation: 16,
                        //style: const TextStyle(color: Color.fromARGB(255, 228, 21, 21)),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        style: TextStyle(color: AppColors.whiteColor),
                        dropdownColor: AppColors.mainDarkColor,
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                      //DropdownButtonExample(),
                      //////////

                      //////////
                      // Container(
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: DropdownButton<PropertyDetail>(
                      //           underline: SizedBox(),
                      //           // iconEnabledColor: AppColors.whiteColor,
                      //           // iconDisabledColor: AppColors.whiteColor,
                      //           //isDense: true,
                      //           isExpanded: true,
                      //           style: TextStyle(color: AppColors.whiteColor),
                      //           dropdownColor: AppColors.mainDarkColor,
                      //           items: repo.otaPropertyData.oTAPropertiesRS![0]
                      //               .propertyDetail!
                      //               .map((e) => DropdownMenuItem<PropertyDetail>(
                      //                   value: e, child: Text("${e.hotelName}")))
                      //               .toList(),
                      //           value: repo.selectedProperty,
                      //           onChanged: (value) {
                      //             Navigator.pop(context);
                      //             repo.setSelectedProperty(value!);
                      //             setState(() {});
                      //             //Utility.pushToDashBoard(context);
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ],
              )),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      "Payable to",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      dropdownValue,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  onChanged: (String text) {
                    _nameError =
                        !RegExp(CommonPattern.name_regex).hasMatch(text);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(8)),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.mainColor, width: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: _nameError ? "Please enter valid name" : null,
                      label: const Text("Name")),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (String text) {
                    _emailError =
                        !RegExp(CommonPattern.email_regex).hasMatch(text);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(8)),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.mainColor, width: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText:
                          _emailError ? "Please enter valid email Id" : null,
                      label: const Text("Email Id")),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _contactController,
                  keyboardType: TextInputType.number,
                  onChanged: (String text) {
                    _contactError =
                        !RegExp(CommonPattern.mobile_regex).hasMatch(text);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(8)),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.mainColor, width: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: _contactError
                          ? "Please enter valid contact no"
                          : null,
                      label: const Text("Contact #")),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (String text) {
                    _amountError = !RegExp(CommonPattern.amount).hasMatch(text);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(8)),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.mainColor, width: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText:
                          _amountError ? "Please enter valid amount" : null,
                      label: const Text("Amount")),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _referenceController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(8)),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.mainColor, width: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      label: const Text("Reference #")),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(8)),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.mainColor, width: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      label: const Text("Description")),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                    onPressed: () {
                      _nameError = !RegExp(CommonPattern.name_regex)
                          .hasMatch(_nameController.text);
                      _emailError = !RegExp(CommonPattern.email_regex)
                          .hasMatch(_emailController.text);
                      _contactError = !RegExp(CommonPattern.mobile_regex)
                          .hasMatch(_contactController.text);
                      _amountError = !RegExp(CommonPattern.amount)
                          .hasMatch(_amountController.text);
                      setState(() {});
                      if (_nameError ||
                          _emailError ||
                          _contactError ||
                          _amountError) {
                        //                 DialogHelper.showErrorDialog(context, "Done", "Please enter valid details.",
                        // showTitle: false);
                      } else {
                        // Navigator.pop(context);
                        model.collectPayment_invoiceRequest(
                          context,
                          _nameController.text,
                          _emailController.text,
                          _contactController.text,
                          double.parse(_amountController.text),
                          _referenceController.text,
                          _descriptionController.text,
                          widget.hotelId,
                        );
                      }
                    },
                    minWidth: double.infinity,
                    height: 50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    color: const Color(0xff7597b3),
                    textColor: AppColors.whiteColor,
                    child: const Text(
                      "Send Link",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({Key? key}) : super(key: key);

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      elevation: 16,
      //style: const TextStyle(color: Color.fromARGB(255, 228, 21, 21)),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
    );
  }
}
