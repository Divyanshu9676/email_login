import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class About extends StatefulWidget {
  var value;
  About({@required this.value});
  @override
  _AboutState createState() => _AboutState(value);
}

class _AboutState extends State<About> {
  _AboutState(this.email);
  String email;
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
                      shrinkWrap: true, //unlimited data
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                        snapshot.data.docs[index];
                        return Column(
                          children: <Widget>[
                            Expanded(
                              child: Text("Name:"+documentSnapshot["Name"]),
                            ),
                            Expanded(
                              child: Text("Hobbies:"+documentSnapshot["Hobbies"]),
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
                onPressed: () {}
            ),
          ],
        ),
      ),
    );
  }
}
