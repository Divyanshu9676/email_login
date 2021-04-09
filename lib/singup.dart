import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _SignUpState extends State<SignUp> {
  TextEditingController emal = TextEditingController();
  TextEditingController passrd = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController hobbies = TextEditingController();

  Future<User> signUp(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return Future.value(user);
    } catch (error) {
      print(error);
      return Future.value(null);
    }
  }

  void addData(String nam,String hobb,String email) {
    DocumentReference ref =
    FirebaseFirestore.instance.collection("$email").doc("$email");
    ref.set({
      'Name': nam,
      'Hobbies': hobb
    }).whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                controller: emal,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                )),
            TextField(
                controller: passrd,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                )),
            TextField(
                controller: name,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(),
                )),
            TextField(
                controller: hobbies,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Hobbies',
                  border: OutlineInputBorder(),
                )),
            ElevatedButton(
                child: Text("Create Account", style: TextStyle(color: Colors.black),),
                onPressed: () {addData(name.text, hobbies.text,emal.text);}
            ),
          ],
        ),
      ),
    );
  }
}
