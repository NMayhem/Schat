import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dash.dart';
import 'valida.dart';

class Registro extends StatefulWidget {
  static const String id = "Registro";
  @override
  _RegistroEstado createState() => _RegistroEstado();
}

class _RegistroEstado extends State<Registro> {
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  String email;
  String password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser() async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
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
            Text("Registro", style: TextStyle(fontSize: 30.0)),
            SizedBox(
              height: 25.0,
            ),
            
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              controller: _email,
              validator: Validacion.validaMail,
              decoration: InputDecoration(
                hintText: "Introduzca su correo electrónico",
                border: const OutlineInputBorder(),
              ),
            ),

            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              autofocus: false,
              obscureText: true,
              controller: _password,
              validator: Validacion.validaPass,
              decoration: InputDecoration(
                hintText: "Introduzca su contraseña",
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 47, 79, 79),
              textColor: Color.fromARGB(255, 223, 255, 255),
              child: Text('Registrar datos'),
              onPressed: () async {
                email = _email.text;
                password = _password.text;
                await registerUser();
              },
            )
          ],
        ),
      )
    );
  }
}