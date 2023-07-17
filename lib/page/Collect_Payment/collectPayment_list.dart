import 'dart:convert';

import 'package:channel_connect/app/app_nav_drawer.dart';
import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/model/payment_list_model.dart';
import 'package:channel_connect/page/Collect_Payment/collectPayment_View.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/payment_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CollectPaymentList extends StatefulWidget {
  const CollectPaymentList({Key? key}) : super(key: key);

  @override
  State<CollectPaymentList> createState() => _CollectPaymentListState();
}

class _CollectPaymentListState extends State<CollectPaymentList> {
  @override
  final ApiProvider apiProvider = ApiProvider();

  Widget build(BuildContext context) {
    final repo = Provider.of<AppRepo>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 240, 244),
      drawer: const AppNavDrawer(),
      appBar: AppBar(
        elevation: 0,
        title: const Text('Collect Payments'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CollectPaymentView(
                          hotelId: repo.selectedProperty.hotelId.toString(),
                        )));
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.white),
            ///// demo list
            // child: ListView.builder(
            //   itemCount: dataList.length,
            //   itemBuilder: (context, index) {
            //     return PaymentCardDetails();
            //   },
            // ),
            //////
            ////////////
            ////// viewing the list from api
            // child: StreamBuilder(
            //   stream: Stream.fromFuture(apiProvider.fetchData()),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       final List<Payment_list> data =
            //           snapshot.data as List<Payment_list>;
            //       return ListView.builder(
            //           itemCount: data.length,
            //           itemBuilder: (context, index) {
            //             final Payment_list list = data[index];
            //             return PaymentCardDetails();
            //           });
            //     } else if (snapshot.hasError) {
            //       return Text('Error: ${snapshot.error}');
            //     }
            //     return Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   },
            // ),
          ),
          const PaymentCardDetails()
        ]),
      ),
    );
  }
}

class ApiProvider {
  final String apiUrl =
      'https://your-api-url.com'; // Replace with your API endpoint

  Future<List<Payment_list>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      return data.map((item) => Payment_list.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
