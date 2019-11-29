import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dash.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  static const String id = "LOGIN";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseUser user;
  String email;
  String password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser() async {
    try {
      if(email!=null){
        user = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dash(
              user: user,
            ),
          ),
        );
      }
    }
    on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 255, 255),
      appBar: AppBar(
      backgroundColor: Color.fromARGB(255, 47, 79, 79),
        title: Text("PicTalk"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("Inicio de Sesión", style: TextStyle(fontSize: 30.0)),
            SizedBox(
              height: 25.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => email = value,
              decoration: InputDecoration(
                hintText: "Correo electrónico",
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
              autocorrect: false,
              obscureText: true,
              onChanged: (value) => password = value,
              decoration: InputDecoration(
                hintText: "Contraseña",
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 47, 79, 79),
              textColor: Color.fromARGB(255, 223, 255, 255),
              child: Text('Iniciar sesión'),
              onPressed: () async {
                await loginUser();
              },
            )
          ],
        ),
      )
    );
  }
}
