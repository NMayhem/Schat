import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Dash extends StatefulWidget {
  static const String id = "Dash";
  final FirebaseUser user;

  const Dash({Key key, this.user}) : super(key: key);
  @override
  Estado createState() => Estado();
}

class Estado extends State<Dash>{
  File foto;
  String urlFoto;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback(String coleccion, String texto) async {
    if (messageController.text.length > 0) {
      await _firestore.collection(coleccion).add({
        texto: messageController.text,
        'de': widget.user.email,
        'fecha': DateTime.now().toIso8601String().toString(),
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  Future subirFoto() async {    
      StorageReference storageReference = FirebaseStorage.instance.ref().child('estados/'+Random().nextInt(10000).toString());    
      StorageUploadTask uploadTask = storageReference.putFile(foto);    
      await uploadTask.onComplete;    
      print('Archivo subido');    
      storageReference.getDownloadURL().then((fileURL) {    
        setState(() {    
          urlFoto = fileURL;    
        });    
      });
      foto = null;
    }

  void tomarFoto() async{
    var pic = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      foto = pic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 223, 255, 255),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 47, 79, 79),
            title: Text('PicTalk'),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.dashboard),
                      SizedBox(width: 5.0),
                      Text('Estados')
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.message),
                      SizedBox(width: 5.0),
                      Text('Chats')
                    ],
                  ),
                )
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(20.0), 
            child: TabBarView(
              children:[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('estados')
                            .orderBy('fecha')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: CircularProgressIndicator(),
                            );

                          List<DocumentSnapshot> docs = snapshot.data.documents;

                          List<Widget> estados = docs
                              .map((doc) => Publicacion(
                                    from: doc.data['de'],
                                    text: doc.data['estado'],
                                    me: widget.user.email == doc.data['de'],
                                  ))
                              .toList();

                          return ListView(
                            controller: scrollController,
                            children: <Widget>[
                              ...estados,
                            ],
                          );
                        },
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            labelText: 'Escriba su estado.'
                          ),
                          controller: messageController,
                        ),
                        MaterialButton(
                          color: Color.fromARGB(255, 47, 79, 79),
                          textColor: Color.fromARGB(255, 255, 255, 255),
                          child: Text('Publicar'),
                          onPressed: (){
                            callback('estados','estado');
                          },
                        ),
                        SizedBox(height: 20.0,)
                      ],
                    ),
                  ],
                ),
                
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('mensajes')
                              .orderBy('fecha')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Center(
                                child: CircularProgressIndicator(),
                              );

                            List<DocumentSnapshot> docs = snapshot.data.documents;

                            List<Widget> messages = docs
                                .map((doc) => Message(
                                      from: doc.data['de'],
                                      text: doc.data['msj'],
                                      me: widget.user.email == doc.data['de'],
                                    ))
                                .toList();

                            return ListView(
                              controller: scrollController,
                              children: <Widget>[
                                ...messages,
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                onSubmitted: (value) => callback('mensajes','msj'),
                                decoration: InputDecoration(
                                  hintText: "Escriba su mensaje.",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                                controller: messageController,
                              ),
                            ),
                            MaterialButton(
                              child: Text('Enviar'),
                              onPressed: (){
                                callback('mensajes','msj');
                              }
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0)
                    ],
                  ),
                )
              ],
            ),
          ),

          drawer: Drawer(
            elevation: 16.0,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 15.0),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/lg.png'),
                        fit: BoxFit.contain,
                      )
                  ),
                ),
                SizedBox(height: 15.0),
                Text("PicTalk", style: TextStyle(fontSize: 20.0), textAlign: TextAlign.center),
                SizedBox(height: 15.0),
                ListTile(
                  leading: Icon(Icons.group_add),
                  title: Text('Añadir contactos'),
                  onTap: (){
                  },
                ),
                Divider(color: Color.fromARGB(255, 47, 79, 79)),
                ListTile(
                  leading: Icon(Icons.close),
                  title: Text('Cerrar Sesión'),
                  onTap: (){
                    _auth.signOut();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
                Divider(color: Color.fromARGB(255, 47, 79, 79)),
              ],
            ),
          ),

          bottomNavigationBar: BottomAppBar(
            elevation: 5.0,
            color: Color.fromARGB(255, 47, 79, 79),
            shape: const CircularNotchedRectangle(),
            child: Container(
              padding: EdgeInsets.only(left: 50.0, right: 50.0),
              height: 50.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.person),
                    color: Color.fromARGB(255, 255, 255, 255),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ),

          floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 47, 79, 79),

            onPressed: (){
              tomarFoto();
              subirFoto();
            },
            child: Icon(Icons.camera_alt,color: Color.fromARGB(255, 255, 255, 255)),
          ),

          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}

class Publicacion extends StatelessWidget {
  final String from;
  final String text;

  final bool me;

  const Publicacion({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Material(
            color: me ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 47, 79, 79),
            textStyle: TextStyle(fontSize: 20.0 ,color: me ? Color.fromARGB(255, 47, 79, 79) : Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.circular(10.0),
            elevation: 3.0,
            child: Container(
              constraints: BoxConstraints(maxHeight: 200, minHeight: 60, minWidth: 450),
              child: Text(
                text,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            me ? 'Tú' : from, style: TextStyle(fontSize: 10.0),
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;

  final bool me;

  const Message({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            from,
          ),
          Material(
            color: me ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 47, 79, 79),
            textStyle: TextStyle(fontSize: 20.0 ,color: me ? Color.fromARGB(255, 47, 79, 79) : Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                text,
              ),
            ),
          )
        ],
      ),
    );
  }
}