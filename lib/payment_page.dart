import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  int price;
  String item;

  PaymentScreen(this.price, this.item);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const platform = MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerPaymentFailureResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWalletResponse);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void handlerPaymentSuccessResponse(PaymentSuccessResponse response) {
    print('Success $response');
  }

  void handlerPaymentFailureResponse(PaymentFailureResponse response) {
    print('Failure $response');
  }

  void handlerExternalWalletResponse(ExternalWalletResponse response) {
    print('Wallet $response');
  }

  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('prices')
        // .where('vendorId', isEqualTo: storeData['vendorId'])
        .snapshots();

    // dynamic money = storeData['price'];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Do Payments Here',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 350,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        widget.item,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 200,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            '₹ ' + widget.price.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextButton(
                          onPressed: () {
                            var options = {
                              'key': 'rzp_test_XfZU894TDFQWg5',
                              'amount': widget.price * 100,
                              'name': 'ShopNow.',
                              'description': widget.item,
                              'prefill': {
                                'contact': '9894018373',
                                'email': 'umsrn333@gmail.com'
                              },
                              'external': {
                                'wallets': ['paytm']
                              }
                            };
                            try {
                              _razorpay.open(options);
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.yellow.shade900,
                              ),
                              height: 50,
                              width: 100,
                              child: Center(
                                child: Text(
                                  'Pay',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
