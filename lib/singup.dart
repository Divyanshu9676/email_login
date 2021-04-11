import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';

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
  double lat;
  double long;
  File _image;

  @override
  Widget build(BuildContext context) {

    Future cameraImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future galleryImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future getImage() async {
      return showDialog(context: context,builder: (context) {
        return AlertDialog(
          content: Text("Select Path", style: TextStyle(fontSize: 20),),
          actions: <Widget>[
            MaterialButton(child: Text("Camera"),onPressed: (){cameraImage();}),
            MaterialButton(child: Text("Gallery"),onPressed: (){galleryImage();}),
          ],
        );
      });
    }

    Future uploadPic(BuildContext context) async{
      String fileName = basename(_image.path);
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(_image);
      final taskSnapshot=await uploadTask;
      setState(() {
        print("Profile Picture uploaded");
      });
    }

    Future<void> createAlert(BuildContext context){
    return showDialog(context: context,builder: (context) {
      return AlertDialog(
          content: Text("Location\n"+"Latitude:"+"$lat"+"\n"+"Longitude:"+"$long"),
      );
    });
  }

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
      'Hobbies': hobb,
      'Latitude':lat.toString(),
      'Longitude':long.toString(),
    }).whenComplete(() => Navigator.pop(context));
  }

  Future<void> getCurrentLocation() async {
    await Geolocator.getCurrentPosition().then((Position position) {
      lat=position.latitude;
      long=position.longitude;
    }).catchError((e) {
      print(e);
    });
  }

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 100,
                child: ClipOval(
                  child: new SizedBox(
                    width: 180.0,
                    height: 180.0,
                    child: (_image!=null)?Image.file(
                      _image,
                      fit: BoxFit.fill,
                    ):Text("ADD PIC")
                  ),
                ),
              ),
            ),
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
                child: Text("Get location", style: TextStyle(color: Colors.black),),
                onPressed: () {getCurrentLocation();
                createAlert(context);}
            ),
            ElevatedButton(
                child: Text("Refresh location", style: TextStyle(color: Colors.black),),
                onPressed: () {getCurrentLocation();
                createAlert(context);}
            ),
            ElevatedButton(
                child: Text("Add Photo", style: TextStyle(color: Colors.black),),
                onPressed: () {getImage();
                uploadPic(context);}
            ),
            ElevatedButton(
                child: Text("Create Account", style: TextStyle(color: Colors.black),),
                onPressed: () {signUp(emal.text, passrd.text, context);
                  addData(name.text, hobbies.text,emal.text);}
            ),
          ],
        ),
      ),
    );
  }
}