import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyWelcomeScreen extends StatefulWidget{
  const MyWelcomeScreen({Key? key, required this.title}): super(key:key);
  final String title;
  @override
  State<MyWelcomeScreen> createState()  => _MyWelcomeScreenState();
}

class _MyWelcomeScreenState extends State<MyWelcomeScreen>{
  int _itemNav= 0;
  String _textoBienvenida1="Bienvenido";
  String _name="";
  Future<void> _loadName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name=(prefs.getString('name') ?? "");
      if(_name!="") {
        _textoBienvenida1 += " " + _name;
      }
      else{
        _textoBienvenida1 = "Bienvenido";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child:
            Text(
              _textoBienvenida1,
              style: Theme.of(context).textTheme.headlineMedium,
            )
        ),
    );
  }
}
