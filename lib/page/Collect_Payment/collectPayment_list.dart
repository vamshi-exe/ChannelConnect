import 'dart:convert';

import 'package:channel_connect/app/app_nav_drawer.dart';
import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/model/ota_property_data.dart';
import 'package:channel_connect/model/payment_list_model.dart';
import 'package:channel_connect/page/Collect_Payment/collectPayment_View.dart';
import 'package:channel_connect/page/Collect_Payment/payment_reciept.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/payment_detail_card.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../model/payment_card_model.dart';

class CollectPaymentList extends StatefulWidget {
  const CollectPaymentList({Key? key}) : super(key: key);

  @override
  State<CollectPaymentList> createState() => _CollectPaymentListState();
}

class _CollectPaymentListState extends State<CollectPaymentList>
    with AutomaticKeepAliveClientMixin<CollectPaymentList> {
  @override
  bool get wantKeepAlive => true;
  PropertyDetail? selectedProperty;
  String? selectedValue;
  bool _isLoadingMoreData = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final TextEditingController date = TextEditingController();
  final TextEditingController _todate = TextEditingController();
  ScrollController _scrollController = ScrollController();

  Future<void> _loadMoreData() async {
    if (_isLoadingMoreData) return;

    setState(() {
      _isLoadingMoreData = true;
    });

    await Provider.of<APIProvider>(context, listen: false)
        .fetchInvoiceListing(isRefresh: false);

    setState(() {
      _isLoadingMoreData = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('init state');
    _scrollController.addListener(_scrollListener);
    Provider.of<APIProvider>(context, listen: false).fetchInvoiceListing();
  }

  void _showCardDetails(InvoiceListingResponse response) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentReciept(response: response),
      ),
    );
  }

  void _scrollListener() {
    if (!_isLoadingMoreData &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  @override
  Future<void> fromDate() async {}

  Widget build(BuildContext context) {
    // final ApiProvider apiProvider = ApiProvider();

    // final response = Provider.of<APIProvider>(context).fetchInvoiceListing();
    super.build(context);
    final repo = Provider.of<AppRepo>(context, listen: false);
    // final response = provider.responses[index];
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 240, 244),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<APIProvider>(context, listen: false)
              .fetchInvoiceListing();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!_hasMoreData || _isLoadingMoreData) return false;
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              _loadMoreData();
              setState(() {});
            }

            return false;
          },
          child: SingleChildScrollView(
            child: Column(children: [
              const DateWidget(),
              Container(
                height: MediaQuery.of(context).size.height * 0.055,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(225, 253, 253, 253)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButton<PropertyDetail>(
                    value: repo.selectedProperty,
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    onChanged: (value) {
                      // Navigator.pop(context);
                      setState(() {
                        repo.setSelectedPropertyDropdown(value!);
                      });
                      Provider.of<APIProvider>(context, listen: false)
                          .fetchInvoiceListing();
                      // repo.selectedProperty;
                    },
                    underline: const SizedBox(),
                    iconEnabledColor: AppColors.blackColor,
                    iconDisabledColor: AppColors.blackColor,
                    //isDense: true,
                    isExpanded: true,
                    style: const TextStyle(color: AppColors.mainDarkColor),
                    dropdownColor: AppColors.whiteColor,
                    items: repo
                        .otaPropertyData.oTAPropertiesRS![0].propertyDetail!
                        .map((e) => DropdownMenuItem<PropertyDetail>(
                            value: e, child: Text("${e.hotelName}")))
                        .toList(),
                  ),
                ),
              ),
              PaymentCardDetails(
                onCardTapped: _showCardDetails,
              ),
              const SizedBox(
                height: 30,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
