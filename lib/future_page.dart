import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payfire/payment_page.dart';

class FutureScreen extends StatefulWidget {
  const FutureScreen({super.key});

  @override
  State<FutureScreen> createState() => _FutureScreenState();
}

class _FutureScreenState extends State<FutureScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String email = 'saran345ms@gmail.com';
  final String password = 'saran123';

  _loginUsers() async {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const FutureScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _loginUsers();

    CollectionReference prices =
        FirebaseFirestore.instance.collection('prices');

    return FutureBuilder<DocumentSnapshot>(
      future: prices.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
            body: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                TextButton(
                    onPressed: () {},
                    child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width - 100,
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text('Pay for Shirt'))),
                const SizedBox(
                  height: 50,
                ),
                TextButton(
                    onPressed: () {},
                    child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width - 100,
                        decoration: BoxDecoration(
                            color: Colors.yellow.shade900,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text('Pay for Laptop'))),
                Text("Shirt: ${data['shirt']}"),
                Text("Laptop: ${data['laptop']}"),
              ],
            ),
          );

          // return Text("Full Name: ${data['shirt']} ${data['laptop']}");
        }

        return const Text("loading");
      },
    );
  }
}
