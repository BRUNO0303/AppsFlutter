import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class nuevaPantalla extends StatefulWidget{
  const nuevaPantalla({Key? key, required this.title}): super(key:key);
  final String title;
  @override
  State<nuevaPantalla> createState()  => _nuevaPantallaState();
}

class _nuevaPantallaState extends State<nuevaPantalla>{
  String _textoBienvenida1="Aquí vamos a poner un mapa y la ubicación";
  Position? _currentPosition;

  final MapController _mapController = MapController.withPosition(
    initPosition: GeoPoint(
      latitude: 0,
      longitude: 0
      ,),
  );

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _handleLocationPermission() async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    final prefs = await SharedPreferences.getInstance();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void _loadNoPreferences() {
    _mapController.changeLocation(GeoPoint(latitude: 19.474180976330988, longitude: -99.04588082060995));
    _mapController.addMarker(GeoPoint(latitude: 19.474180976330988, longitude: -99.04588082060995));
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              onPressed: _loadNoPreferences,
              icon: const Icon(
                        Icons.location_on_outlined)
          ),
        ],
      ),
      body: Center(
          child:
          OSMFlutter(
            controller:_mapController,
            trackMyPosition: false,
            initZoom: 15,
            minZoomLevel: 2,
            maxZoomLevel: 19,
            stepZoom: 1.0,
          ),
      ),

    );
  }
}
