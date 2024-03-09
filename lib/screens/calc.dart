import 'package:flutter/material.dart';
import 'dart:math';

extension NumberParsing on String{
  double toDouble(){
    return double.parse(this);
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String _texto = "";
  String _almacena="";
  String test="";
  double _resultado = 0;
  int _operacion=0;
  Random rnd = Random();
  int _itemNav= 1;
  void _realizaOperacion(){
    if(_operacion==1){
      _resultado+=_texto.toDouble();
    }
  }
  void _actualizaAlma(){
    _almacena = _resultado.toString();
  }
  void _borra(){
    setState(() {
      if(_texto.length>0) {
        _texto = _texto.replaceRange(_texto.length - 1, _texto.length, "");
      }
    });
  }
  void _incrementCounter(String a) {
    setState(() {
      if (a.codeUnits[0] >= 48 && a.codeUnits[0] <= 57) {
        _texto += a;
      }
      else{
        if(a=="." && !_texto.contains(".")){
          if(_texto.isNotEmpty) {
            _texto += a;
          }
          else{
            _texto +="0.";
          }
        }
        if(a=="="){
          if(_operacion==0) {
            if (_texto == "") {
              _resultado = 0;
              _actualizaAlma();
            }
            else {
              _resultado = _texto.toDouble();
              _actualizaAlma();
              _texto = "";
            }
          }
        }
        if(a=="+"){
          if(_operacion==0){
            _resultado = _texto.toDouble();
            _actualizaAlma();
            _almacena+="+";
            _texto="";
            _operacion=1;
          }
          else {
            _realizaOperacion();
            _actualizaAlma();
            _almacena += "+";
            _texto="";
            _operacion=1;
          }
        }
      }
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              _almacena,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              _texto,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.headline2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <ElevatedButton>[
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("1");
                  },
                  child: Text(
                      "1",
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("2");
                  },
                  child: Text(
                      "2",
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("3");
                  },
                  child: Text(
                      "3",
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("+");
                  },
                  child: Text(
                      "+",
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <ElevatedButton>[
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("4");
                  },
                  child: Text(
                      "4",
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("5");
                  },
                  child: Text(
                      "5",
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("6");
                  },
                  child: Text(
                      "6",
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("*");
                  },
                  child: Text(
                      "*",
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <ElevatedButton>[
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("7");
                  },
                  child: Text(
                      "7",
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("8");
                  },
                  child: Text(
                    "8",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("9");
                  },
                  child: Text(
                      "9",
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("/");
                  },
                  child: Text(
                      "/",
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <ElevatedButton>[
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("-");
                  },
                  child: Text(
                      "-",
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("0");
                  },
                  child: Text(
                    "0",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter(".");
                  },
                  child: Text(
                      ".",
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter("=");
                  },
                  child: Text(
                      "=",
                      style: Theme.of(context).textTheme.headline3
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <FloatingActionButton>[
          FloatingActionButton(
            onPressed: _borra,
            tooltip: 'Borra',
            child: const Icon(Icons.restore_from_trash_outlined),
            backgroundColor: const Color.fromRGBO(255, 0, 0, 128),
          ),
        ],
      ),
    );
  }
}