import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget{
  const LoginScreen({Key? key, required this.title}): super(key:key);
  final String title;
  @override
  State<LoginScreen> createState()  => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final _textController = TextEditingController();
  String _N="";
  Future<void> _saveName(String _name) async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('name', _name);
    });
  }

  void _delTextField() {
    _textController.clear();
  }

  Future<void> _showName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _N=(prefs.getString('name') ?? "jaja");
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _textController,
                  enabled: true,
                ),
                ElevatedButton(
                    onPressed: (){
                      _saveName(_textController.text);
                      _delTextField();
                    },
                    child: const Text("Inicia")
                ),
                Text(
                  _N,
                )
            ],
          )
      ),
    );
  }
}
