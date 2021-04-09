import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email/main.dart';

class About extends StatefulWidget {
  var value;
  About({@required this.value});
  @override
  _AboutState createState() => _AboutState(value);
}

class _AboutState extends State<About> {
  _AboutState(this.email);
  String email;
  FirebaseAuth auth = FirebaseAuth.instance;

  void signOut() async {
    await auth.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("$email").snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                        snapshot.data.docs[index];
                        return Row(
                          children: <Widget>[
                            Expanded(
                              child: Text("Name: "+snap["Name"]+"\n", style: TextStyle(fontSize: 20),),
                            ),
                            Expanded(
                              child: Text("Hobbies: "+snap["Hobbies"], style: TextStyle(fontSize: 20),),
                            ),
                        ],
                        );
                      });
                } else {
                  return Text(snapshot.error.toString());
                }
              },
            ),
            ElevatedButton(
                child: Text("SignOut", style: TextStyle(color: Colors.black),),
                onPressed: () {signOut();}
            ),
          ],
        ),
      ),
    );
  }
}