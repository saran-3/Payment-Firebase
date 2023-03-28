import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payfire/payment_page.dart';

class StreamPage extends StatefulWidget {
  @override
  State<StreamPage> createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String email = 'saran345ms@gmail.com';
  final String password = 'saran123';

  _loginUsers() async {
    // await _authController.loginUsers(email, password);
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('prices').snapshots();

  @override
  Widget build(BuildContext context) {
    _loginUsers();

    return StreamBuilder<QuerySnapshot>(
        stream: _userStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Container(
            height: 500,
            child: ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  final storeData = snapshot.data!.docs[index];
                  int price = storeData['price'];
                  String item = storeData['item'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PaymentScreen(price, item);
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        // contentPadding: EdgeInsets.all(10),
                        // minLeadingWidth: 10,
                        // horizontalTitleGap: 30,
                        // minVerticalPadding: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.black)),
                        tileColor: Colors.yellow.shade900,
                        selectedTileColor: Colors.pink,
                        selectedColor: Colors.red,
                        textColor: Colors.white,
                        leading: Text(
                          storeData['item'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        trailing: Text(
                          storeData['price'].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
  }
}
