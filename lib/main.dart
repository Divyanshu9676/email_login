import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:email/singup.dart';
import 'package:email/second.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LogIn',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future<void> signin(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result =
      await auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => About(value: email)));
      return Future.value(user);
    } catch (e) {
      print(e.code);
      return Future.value(null);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                controller: email,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                )),
            TextField(
                controller: pass,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                )),
            ElevatedButton(
                child: Text("LogIn", style: TextStyle(color: Colors.black),),
                onPressed: () {signin(email.text,pass.text,context);}
            ),
            ElevatedButton(
                child: Text("SignUp", style: TextStyle(color: Colors.black),),
                onPressed: () {Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()));}
            ),
          ],
        ),
      ),
    );
  }
}
