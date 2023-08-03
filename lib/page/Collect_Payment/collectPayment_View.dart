import 'dart:convert';

import 'package:channel_connect/app/app_nav_drawer.dart';
import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/model/ota_hotel_data.dart';
import 'package:channel_connect/model/payment_card_model.dart';
import 'package:channel_connect/model/payment_list_model.dart';
import 'package:channel_connect/network/api_service.dart';
import 'package:channel_connect/network/hotel_api_service.dart';
import 'package:channel_connect/page/Collect_Payment/collectPayment_ViewModel.dart';
import 'package:channel_connect/page/Collect_Payment/collectPayment_list.dart';
import 'package:channel_connect/prefrence_util/Prefs.dart';
import 'package:channel_connect/util/payment_detail_card.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/common_pattern.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import '../../model/ota_property_data.dart';
import '../../util/dialog_helper.dart';

class CollectPaymentView extends StatefulWidget {
  final String? prop_code;
  final VoidCallback refreshData;
  const CollectPaymentView(
      {Key? key,
      required this.hotelId,
      this.prop_code,
      required this.refreshData})
      : super(key: key);
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
  int? hotelID;
  bool _nameError = false;
  bool _emailError = false;
  bool _contactError = false;
  bool _amountError = false;
  String _propcode = "";
  @override
  void initState() {
    super.initState();
    initRequest();
  }

  //// prop_id&&prop_code function
  void makePostRequest() async {
    // final hotelId = await Prefs.hotel_code;
    final username = await Prefs.username;
    final password = await Prefs.password;
    final String url =
        // "http://203.109.97.241:8080/ChannelController/PropertyDetails";
        "https://cm.resavenue.com/channelcontroller/PropertyDetails";
    late Map<String, dynamic> requestBody = {
      "OTA_ResAvenueProp": {
        "POS": {
          "Username": username,
          "Password": password,
          "ID_Context": "APP"
        },
        "HotelCode": "${hotelID.toString()}"
      }
    };
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        String resobj = jsonDecode(response.body)['prop_code'];
        if (resobj == null) {
          print('null');
        }
        print(username);
        setState(() {
          _propcode = resobj.toString();
        });
        print(':::::::::::::::::::> ${resobj.toString()}');
      } else {
        print('Response: ${response.body}');
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  ///
  void initRequest() async {
    // final hotelId = await Prefs.hotel_code;
    final username = await Prefs.username;
    final password = await Prefs.password;
    final String url =
        "https://cm.resavenue.com/channelcontroller/PropertyDetails";
    late Map<String, dynamic> requestBody = {
      "OTA_ResAvenueProp": {
        "POS": {
          "Username": username,
          "Password": password,
          "ID_Context": "APP"
        },
        "HotelCode": "6"
      }
    };
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        String resobj = jsonDecode(response.body)['prop_code'];
        if (resobj == null) {
          print('null');
        }
        print(username);
        setState(() {
          _propcode = resobj.toString();
        });
        print(':::::::::::::::::::> ${resobj.toString()}');
      } else {
        print('Response: ${response.body}');
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  ///

  /// send link function
  void sendPostRequest() async {
    String contactNo = _contactController.text;

    var url = 'http://test.resavenue.com/res_mars_new/generateBulkInvoice';
    var requestBody = ResInvoiceCreationReq(
      invoiceSet: InvoiceSet(
        invoiceData: InvoiceData(
          customerDetails: [
            CustomerDetails(
              emailId: _emailController.text,
              expiryDate: '29-Jul-2023',
              description: _descriptionController.text,
              termsAndConditions: 'NO',
              reqFrm: 'ChannelApp',
              referenceNo: _referenceController.text,
              address: 'Level 2, Plaza Asiad, S. V. Road',
              firstName: _nameController.text,
              checkIn: '27-Jul-2023',
              city: 'Coimbatore',
              invoiceAmount: double.parse(_amountController.text),
              hotelCode: _propcode,
              // hotelCode: widget.hotelId,
              contactNo: _contactController.text,
              checkOut: '28-Jul-2023',
              roomName: 'Beach Villa',
              paymentType: 'PaymentLink',
              totalAmount: 2000,
              state: 'Tamil Nadu',
              currency: 'INR',
              zipcode: '',
              country: 'India',
              lastName: 'test',
            ),
          ],
        ),
      ),
    );
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(requestBody.toJson()),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    if (response.statusCode == 200) {
      print('${_contactController.text} ::::::::::::::: ${_contactController}');
      Navigator.pop(context);
      // Request successful
      print('POST request successful');
      print(response.body);
    } else {
      // Request failed
      print('POST request failed with status: ${response.statusCode}');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<AppRepo>(context, listen: false);
    // final username  = await Prefs.username;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: ViewModelBuilder<CollectPaymentViewModel>.reactive(
        viewModelBuilder: () => CollectPaymentViewModel(),
        // ignore: deprecated_member_use
        onModelReady: (CollectPaymentViewModel mdoel) => mdoel.iniData(),
        builder: (_, model, child) => Scaffold(
          backgroundColor: const Color.fromARGB(255, 241, 240, 244),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop(MaterialPageRoute(
                    builder: (context) => CollectPaymentList()));
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined),
            ),
            centerTitle: true,
            elevation: 0,
            title: const Text('Collect Payment'),
          ),
          body: SingleChildScrollView(
            child: Container(
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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton<PropertyDetail>(
                            value: repo.selectedProperty,
                            icon: Icon(Icons.keyboard_arrow_down_outlined),
                            onChanged: (value) {
                              print('${value!.hotelId}');
                              print('${value!.hotelName}');
                              setState(() {
                                repo.setSelectedProperty(value);
                                hotelID = value.hotelId as int?;
                              });
                              makePostRequest();
                            },
                            underline: SizedBox(),
                            iconEnabledColor: AppColors.blackColor,
                            iconDisabledColor: AppColors.blackColor,
                            //isDense: true,
                            isExpanded: true,
                            style: TextStyle(color: AppColors.mainDarkColor),
                            dropdownColor: AppColors.whiteColor,
                            items: repo.otaPropertyData.oTAPropertiesRS![0]
                                .propertyDetail!
                                .map(
                                  (e) => DropdownMenuItem<PropertyDetail>(
                                    value: e,
                                    child: Text("${e.hotelName} "),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // _propcode != null
                  //     ? Text("prop code is ${_propcode}")
                  //     : Text('null'),
                  const SizedBox(
                    height: 10,
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
                          borderSide: BorderSide(
                              color: AppColors.mainColor, width: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorText:
                            _nameError ? "Please enter valid name" : null,
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
                          borderSide: BorderSide(
                              color: AppColors.mainColor, width: 0.8),
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
                          borderSide: BorderSide(
                              color: AppColors.mainColor, width: 0.8),
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
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (String text) {
                      _amountError =
                          !RegExp(CommonPattern.amount).hasMatch(text);
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
                          borderSide: BorderSide(
                              color: AppColors.mainColor, width: 0.8),
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
                          borderSide: BorderSide(
                              color: AppColors.mainColor, width: 0.8),
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
                          borderSide: BorderSide(
                              color: AppColors.mainColor, width: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: const Text("Description")),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    onPressed: () {
                      // sendPostRequest();
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
                            // widget.hotelId,
                            _propcode);
                        ;
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
                    ),
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       makePostRequest();
                  //       // fetchHotels();
                  //       // Provider.of<ApiService>(context)
                  //       //     .fetchUser(username, password);
                  //       // repo.fetchUser(context);
                  //     },
                  //     child: Text('data'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class HotelDropdown extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<HotelDetails>>(
//       future: fetchHotels(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (snapshot.hasData) {
//           final hotelList = snapshot.data!;

//           return DropdownButtonFormField<HotelDetails>(
//             value: null,
//             hint: Text('Select a hotel'),
//             items: hotelList.map((hotel) {
//               return DropdownMenuItem<HotelDetails>(
//                 value: hotel,
//                 child: Text(),
//               );
//             }).toList(),
//             onChanged: (value) {
//               // Handle the selected hotel here
//             },
//           );
//         } else {
//           return Text('No hotels found.');
//         }
//       },
//     );
//   }
// }
