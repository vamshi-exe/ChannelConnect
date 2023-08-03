// ignore_for_file: unused_import

import 'dart:convert';

import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/model/payment_card_model.dart';
import 'package:channel_connect/model/payment_list_model.dart';
import 'package:channel_connect/page/Collect_Payment/collectPayment_View.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentCardDetails extends StatefulWidget {
  final Function(InvoiceListingResponse) onCardTapped;

  PaymentCardDetails({
    Key? key,
    required this.onCardTapped,
  }) : super(key: key);

  @override
  State<PaymentCardDetails> createState() => _PaymentCardDetailsState();
}

class _PaymentCardDetailsState extends State<PaymentCardDetails>
    with AutomaticKeepAliveClientMixin<PaymentCardDetails> {
  @override
  bool get wantKeepAlive => true;
  int _currentPage = 20;

  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Reached the end of the list, load more data
      // _loadMoreData();
      Provider.of<APIProvider>(context, listen: false).nextPage();
    }
  }

  // void _loadMoreData() {
  //   setState(() {
  //     _currentPage + 2;
  //   });
  // }
  DateTime parseDate(String dateString) {
    return DateFormat('MMM dd, yyyy').parse(dateString);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<APIProvider>(
      builder: (context, provider, _) {
        // ignore: unnecessary_null_comparison
        if (provider.responses == null) {
          if (provider._hasError) {
            return const Center();
          }
        } else {
          return ListView.builder(
            key: GlobalKey(),
            controller: _scrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // itemCount: provider.responses.length + 1,
            itemCount: provider.hasMoreData
                ? provider.responses.length + 1
                : provider.responses.length,

            itemBuilder: (context, index) {
              if (index == provider.responses.length) {
                if (provider.responses.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                // return null;
                // setState(() {
                //   Text("You've reached the bottom");
                // });
                return const Center(child: CircularProgressIndicator());
              } else {
                // Center(child: CircularProgressIndicator());
                final response = provider.responses[index];
                final createdDate = parseDate(response.merCustCreatedDate);

                return GestureDetector(
                  onTap: () {
                    widget.onCardTapped(response);
                  },
                  key: ValueKey(response.merOrderNo),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.175,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(225, 253, 253, 253),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 13, top: 13, right: 13),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${response.merCustFirstName} ${response.merCustLastName}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 42, 72, 108)),
                              ),
                              const Text(
                                'TapPay',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 254, 97, 6),
                                    fontWeight: FontWeight.w200),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Phone :' '${response.merCustPhoneNo}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 130, 130, 131),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ord #: ${response.merOrderNo}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 42, 72, 108),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 25,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: response.merCustStatus ==
                                                'Payment Awaited'
                                            ? const Color.fromARGB(
                                                208, 220, 144, 22)
                                            : response.merCustStatus == 'Failed'
                                                ? Colors.red
                                                : response.merCustStatus ==
                                                        'Successful'
                                                    ? Colors.green
                                                    : Colors.green,
                                      ),
                                      color: response.merCustStatus ==
                                              'Payment Awaited'
                                          ? const Color.fromARGB(
                                              255, 236, 222, 16)
                                          : response.merCustStatus == 'Failed'
                                              ? const Color.fromARGB(
                                                  131, 244, 67, 54)
                                              : response.merCustStatus == 'Paid'
                                                  ? const Color.fromARGB(
                                                      123, 76, 175, 79)
                                                  : const Color.fromARGB(
                                                      123, 76, 175, 79)),
                                  child: Center(
                                    child: Text(response.merCustStatus ==
                                            'Payment Awaited'
                                        ? 'Pending'
                                        : 'Paid'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 0.8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(child: Text(
                                    // 'Created: ${response.merCustCreatedDate}'
                                    'Created: ${DateFormat('dd MMM, yyyy').format(createdDate)}')),
                                Row(
                                  children: [
                                    Text(
                                      '${response.merCurrId}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${response.merAmount}',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                );
              }
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class APIProvider extends ChangeNotifier {
  List<InvoiceListingResponse> _responses = [];

  bool _hasError = false;
  int _currentPage = 20;
  int _pageSize = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;

  List<InvoiceListingResponse> get responses => _responses;
  bool get hasError => _hasError;
  bool get hasMoreData => _hasMoreData;

  DateTime parseDate(String dateStr) {
    // Assuming dateStr is in the format "dd-MM-yyyy"
    final parts = dateStr.split('-');
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } else {
      // Return a default date or throw an error, depending on your use case
      return DateTime(2000, 1, 1);
    }
  }

  Future<void> fetchInvoiceListing({
    bool isRefresh = true,
  }) async {
    if (_isLoading) return;
    _isLoading = true;
    if (isRefresh) {
      // If it's a refresh, reset the current page and clear the list
      // _currentPage = 1;
      _pageSize = 1;
      _responses.clear();
      _hasMoreData = true;
    }
    DateTime today = DateTime.now();
    DateTime fourteenDaysAgo = today.subtract(const Duration(days: 14));

    String formattedToday = DateFormat('dd-MM-yyyy').format(today);
    String formattedFourteenDaysAgo =
        DateFormat('dd-MM-yyyy').format(fourteenDaysAgo);
    var url = 'http://test.resavenue.com/res_mars_new/getInvoiceListing';

    var requestBody = InvoiceListingRequest(
      propId: 'PROP1001',
      searchFromDate: formattedFourteenDaysAgo,
      searchToDate: formattedToday,
      // searchToDate: '${today.toString()}',
      searchDateType: 'CRE',
      pageNumber: _currentPage,
      pageSize: _pageSize,
    );

    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(requestBody.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // print(response.body);
      var jsonResponse = jsonDecode(response.body);
      var customerDetailsList =
          jsonResponse['InvoiceListing']['CustomerDetails'];
      if (customerDetailsList.isEmpty) {
        _hasMoreData = false;
      } else {
        var newData = customerDetailsList
            .map<InvoiceListingResponse>((customerDetails) =>
                InvoiceListingResponse(
                  merCurrId: customerDetails['merCurrId'] ?? '',
                  merAmount: customerDetails['merAmount'] ?? '',
                  merCustCreatedDate:
                      customerDetails['merCustCreatedDate'] ?? '',
                  merCustPhoneNo: customerDetails['merCustPhoneNo'] ?? '',
                  merCustLastName: customerDetails['merCustLastName'] ?? '',
                  merOrderNo: customerDetails['merOrderNo'] ?? '',
                  merCustFirstName: customerDetails['merCustFirstName'] ?? '',
                  merCustStatus: customerDetails['merCustStatus'] ?? '',
                  merCustemailId: customerDetails['merCustemailId'] ?? '',
                  merOrderId: customerDetails['merOrderId'] ?? '',
                  merCustRefId: customerDetails['merCustRefId'] ?? '',
                  merDesc: customerDetails['merDesc'] ?? '',
                  merCustRefundAmt: customerDetails['merCustRefundAmt'] ?? '',
                  merCustRefundedDate:
                      customerDetails['merCustRefundedDate'] ?? '',
                  merRefenceNo: customerDetails['merRefenceNo'] ?? '',
                ))
            .toList();
        var uniqueNewData = newData
            .where((item) => !_responses.any(
                (existingItem) => existingItem.merOrderNo == item.merOrderNo))
            .toList();

        _responses.addAll(uniqueNewData);
        _responses.sort(
            // (a, b) => b.merCustCreatedDate.compareTo(a.merCustCreatedDate),
            (a, b) =>
                parseDate(b.merOrderNo).compareTo(parseDate(a.merOrderNo)));
        if (newData.length < _currentPage) {
          _hasMoreData = false;
        } else {
          _hasMoreData = true;
          _pageSize++;
        }

        print('length is ${_responses.length}');
        print(response.body);
      }
      _hasError = false;
    } else {
      _hasError = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> nextPage() async {
    await fetchInvoiceListing(isRefresh: false);
  }
}

class DateWidget extends StatefulWidget {
  const DateWidget({Key? key}) : super(key: key);

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

final TextEditingController date = TextEditingController();
final TextEditingController _todate = TextEditingController();

class _DateWidgetState extends State<DateWidget> {
  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<AppRepo>(context, listen: false);
    DateTime today = DateTime.now();
    DateTime fourteenDaysAgo = today.subtract(const Duration(days: 14));

    String formattedToday = DateFormat('dd MMM, yyyy').format(today);
    String formattedFourteenDaysAgo =
        DateFormat('dd MMM, yyyy').format(fourteenDaysAgo);

    return Container(
      // height: do,
      width: double.maxFinite,
      color: AppColors.mainColor.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Collect Payments",
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  date == null
                      ? '${date.text} ${_todate.text}'
                      : '${formattedFourteenDaysAgo} - ${formattedToday}',
                  style: TextStyle(fontSize: 10, color: AppColors.whiteColor),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CollectPaymentView(
                          hotelId: repo.selectedProperty.hotelId.toString(),
                          refreshData: _refreshData)));
                },
                child: Icon(
                  Icons.add,
                  color: AppColors.whiteColor,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                child: Icon(
                  Icons.search,
                  color: AppColors.whiteColor,
                ),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              children: [
                                Container(
                                  color: AppColors.mainColor,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 18),
                                        child: Text(
                                          "Search Option",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: AppColors.whiteColor),
                                        ),
                                      )),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.close),
                                        color: AppColors.whiteColor,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          //  crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: GestureDetector(
                                              onTap: () async {
                                                DateTime? frDate =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(2001),
                                                        lastDate:
                                                            DateTime.now());
                                                if (frDate != null) {
                                                  setState(() {
                                                    date.text = DateFormat(
                                                            'dd MMM, yyyy')
                                                        .format(frDate);
                                                  });
                                                }
                                                // _selectDate(context, true);
                                              },
                                              child: TextField(
                                                controller: date,
                                                //  textAlign: TextAlign.center,
                                                enabled: false,
                                                style: const TextStyle(
                                                    fontSize: 13),
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 0,
                                                          horizontal: 0),
                                                  hintText: "From Date",
                                                  // errorText: _fromDateError
                                                  //     ? "Please Select valid Date"
                                                  //     : null,
                                                  errorStyle: TextStyle(
                                                      fontSize: 9,
                                                      color:
                                                          AppColors.redAccent),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: AppColors
                                                              .mainColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: AppColors
                                                                  .mainColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            AppColors.mainColor,
                                                        width: 0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.calendar_today,
                                                    color: AppColors.mainColor,
                                                  ),
                                                ),
                                              ),
                                            )),
                                            Container(
                                              // color: AppColors.redAccent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: const Text("To"),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () async {
                                                  DateTime? toDate =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime(2001),
                                                          lastDate:
                                                              DateTime.now());
                                                  if (toDate != null) {
                                                    setState(() {
                                                      _todate.text = DateFormat(
                                                              'dd MMM, yyyy')
                                                          .format(toDate);
                                                    });
                                                  }

                                                  // if (fromDateTime != null) {
                                                  //   _selectDate(context, false);
                                                  // }
                                                },
                                                child: TextField(
                                                  controller: _todate,
                                                  // textAlign: TextAlign.center,
                                                  enabled: false,
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 0,
                                                            horizontal: 0),
                                                    hintText: "To Date",
                                                    // errorText: _toDateError
                                                    //     ? "Please Select valid Date"
                                                    //     : null,
                                                    errorStyle: TextStyle(
                                                        fontSize: 9,
                                                        color: AppColors
                                                            .redAccent),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: AppColors
                                                                .mainColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: AppColors
                                                                    .mainColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 0.8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    prefixIcon: Icon(
                                                      Icons.calendar_today,
                                                      color:
                                                          AppColors.mainColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          // visible: _fromDateError || _toDateError,
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                    // _fromDateError
                                                    //     ? "Please Select valid date"
                                                    //     :
                                                    "",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: AppColors
                                                            .redAccent),
                                                  )),
                                                  Container(
                                                    // color: AppColors.redAccent,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: const Text(
                                                      "To",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    "",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: AppColors
                                                            .redAccent),
                                                  ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: MaterialButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                  color:
                                                      AppColors.highLightColor,
                                                  textColor:
                                                      AppColors.whiteColor,
                                                  child: const Text("Apply")),
                                            ),
                                          ],
                                        ),
                                        //  SizedBox(
                                        //   height: 10,
                                        // ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ));
                      });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void _refreshData() {
    Provider.of<APIProvider>(context, listen: false)
        .fetchInvoiceListing(isRefresh: false);
  }
}
