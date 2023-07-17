import 'package:flutter/material.dart';

class PaymentCardDetails extends StatelessWidget {
  const PaymentCardDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.16,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color.fromARGB(225, 253, 253, 253),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 13, top: 13, right: 13),
          child: Column(children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Narendra Payasi',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromARGB(255, 42, 72, 108)),
                ),
                Text(
                  'TapPay',
                  style: TextStyle(
                      color: Color.fromARGB(255, 254, 97, 6),
                      fontWeight: FontWeight.w200),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Phone : 720237601',
                    style: TextStyle(
                      color: Color.fromARGB(255, 130, 130, 131),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ord #: REF123456789123',
                    style: TextStyle(
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
                              color: const Color.fromARGB(194, 76, 175, 79)),
                          color: const Color.fromARGB(82, 66, 179, 69)),
                      child: const Center(child: Text('Paid'))),
                ],
              ),
            ),
            const Divider(
              thickness: 0.8,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Created: 10 Jan, 2023'),
                  Text(
                    'INR 6,300',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
