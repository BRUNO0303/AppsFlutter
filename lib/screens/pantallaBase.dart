import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class pantallaBase extends StatefulWidget{
  const pantallaBase({Key? key, required this.title}): super(key:key);
  final String title;
  @override
  State<pantallaBase> createState()  => _pantallaBaseState();
}

class _pantallaBaseState extends State<pantallaBase>{
  FirebaseFirestore db = FirebaseFirestore.instance;
  String _textoBienvenida1="El botón se presionó";
  String _rutaImg="";
  int _n=0;

  Future<void> _loadN() async{
      final docRef = db.collection("ElContador").doc("LaVariable");
      docRef.get().then(
            (DocumentSnapshot doc) {
              final data = doc.data() as Map<String, dynamic>;
              setState(() {
                _n=data["contador"];
              });
            },
        onError: (e) => {
              print("Error getting document: $e"),
        }
      );
  }

  void _getImg(int _a) {
    String i="${_a}";
    final docRef = db.doc("Numeros/"+i);
    docRef.get().then(
            (DocumentSnapshot doc) {
              final data = doc.data() as Map<String, dynamic>;
              setState(() {
                _rutaImg = data["img"];
              });
            },
            onError: (e) => {
              print("Error getting document: $e"),
            }
    );
  }

  void _incrementCounter() async {
    setState(() {
      _n+=1;
      _getImg(_n);
      final docRef = db.doc("ElContador/LaVariable");
      docRef.set({"contador":_n});
    });
  }

  @override
  void initState() {
    _loadN();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _textoBienvenida1,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                "${_n}",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: Image.network(
                      _rutaImg,
                      width: 100,
                      height: 100,
                      fit: BoxFit.scaleDown,
                    ),
                  )
                ],
              ),
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
