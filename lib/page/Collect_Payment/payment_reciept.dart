import 'package:channel_connect/model/payment_card_model.dart';
import 'package:channel_connect/page/Collect_Payment/collectPayment_list.dart';
import 'package:channel_connect/util/AppDoubleText.dart';
import 'package:channel_connect/util/app_color.dart';
import 'package:channel_connect/util/payment_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentReciept extends StatelessWidget {
  final InvoiceListingResponse response;

  PaymentReciept({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiProvider =
        Provider.of<APIProvider>(context, listen: false).fetchInvoiceListing();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 240, 244),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Collect Payments'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.14,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: const Color.fromARGB(65, 56, 56, 56))),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppDoubleTextWidget(
                            parameter: 'Customer Name',
                            smallText:
                                '${response.merCustFirstName} ${response.merCustLastName}',
                          ),
                          AppDoubleTextWidget(
                            parameter: 'Customer #',
                            smallText: '${response.merCustPhoneNo}',
                          ),
                          AppDoubleTextWidget(
                            parameter: 'Email ID',
                            smallText: '${response.merCustemailId}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 241, 240, 244)),
                    transform: Matrix4.translationValues(10.0, -7.0, 0.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Text(
                      'CUSTOMER DETAILS',
                      style: TextStyle(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: const Color.fromARGB(65, 56, 56, 56))),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppDoubleTextWidget(
                              parameter: 'Created Date',
                              smallText: '${response.merCustCreatedDate}'),
                          AppDoubleTextWidget(
                              parameter: 'Order ID',
                              smallText: '${response.merOrderId}'),
                          AppDoubleTextWidget(
                              parameter: 'Reference #',
                              smallText: '${response.merRefenceNo}'),
                          AppDoubleTextWidget(
                              parameter: 'Amount',
                              smallText: '${response.merAmount}'),
                          AppDoubleTextWidget(
                              parameter: 'Status',
                              smallText: '${response.merCustStatus}'),
                          AppDoubleTextWidget(
                              parameter: 'Payment Type', smallText: 'TapPay'),
                          AppDoubleTextWidget(
                              parameter: 'Description',
                              smallText: '${response.merDesc}'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 241, 240, 244)),
                    transform: Matrix4.translationValues(10.0, -7.0, 0.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Text(
                      'ORDER DETAILS',
                      style: TextStyle(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.14,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: const Color.fromARGB(65, 56, 56, 56))),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppDoubleTextWidget(
                            parameter: 'Refund Date',
                            // smallText: '${response.merCustRefundedDate}',
                            smallText: response.merCustRefundedDate,
                          ),
                          AppDoubleTextWidget(
                            parameter: 'Refund Amount',
                            smallText: '${response.merCustRefundAmt}',
                          ),
                          AppDoubleTextWidget(
                            parameter: 'Refund Reference #',
                            smallText: 'REF123456789',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 241, 240, 244)),
                    transform: Matrix4.translationValues(10.0, -7.0, 0.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Text(
                      'REFUND DETAILS',
                      style: TextStyle(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
