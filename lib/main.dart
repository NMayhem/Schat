import 'package:flutter/material.dart';
import 'registro.dart';
import 'login.dart';
import 'dash.dart';

void main() => runApp(Schat());

class Schat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color.fromARGB(255, 47, 79, 79),
        accentColor: Color.fromARGB(255, 223, 255, 255),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Inicio.id,
      routes: {
        Inicio.id: (context) => Inicio(),
        Registro.id: (context) => Registro(),
        Login.id: (context) => Login(),
        Dash.id: (context) => Dash(),
        //Chat.id: (context) => Chat(),
      },
    );
  }
}

class Inicio extends StatelessWidget {
  static const String id = "Inicio";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 255, 255),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: 'logo',
            child: Container(
              width: 150.0,
              child: Image.asset("assets/images/lg.png"),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text("Bienvenido a", style: TextStyle(fontSize: 22.0)),
          Text("PicTalk", style: TextStyle(fontSize: 40.0)),
          SizedBox(
            height: 50.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                color: Color.fromARGB(255, 47, 79, 79),
                textColor: Color.fromARGB(255, 223, 255, 255),
                child: Text('Iniciar Sesión'),
                onPressed: () {
                  Navigator.of(context).pushNamed(Login.id);
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              MaterialButton(
                color: Color.fromARGB(255, 47, 79, 79),
                textColor: Color.fromARGB(255, 223, 255, 255),
                child: Text('Registro'),
                onPressed: () {
                  Navigator.of(context).pushNamed(Registro.id);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
