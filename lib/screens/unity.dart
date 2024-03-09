/*
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class Unity extends StatefulWidget{
  const Unity({Key? key, required this.title}): super(key:key);
  final String title;
  @override
  State<Unity> createState()  => _UnityState();
}

class _UnityState extends State<Unity>{
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  late UnityWidgetController _unityWidgetController;

  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: () {
            Future<bool> b=true as Future<bool>;
            return b;
            // Pop the category page if Android back button is pressed.
          },
          child: Container(
            //color: Color(),
            child: UnityWidget(
              onUnityCreated: onUnityCreated,
            ),
          ),
        ),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }
}
*/