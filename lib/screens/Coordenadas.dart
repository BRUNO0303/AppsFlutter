import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class coordenadas extends StatefulWidget{
  const coordenadas({Key? key, required this.title}): super(key:key);
  final String title;
  @override
  State<coordenadas> createState()  => _coordenadasState();
}

class _coordenadasState extends State<coordenadas> {
  String _boton="Obtener coordenadas";
  String _textLat="",_textLong="";
  double _lat=-500,_lon=-500;
  Position? _currentPosition;

  void initState(){
    super.initState();
    _loadCoords();
  }

  Future<void> _loadCoords() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lat=(prefs.getDouble('lat') ?? -500);
      _lon=(prefs.getDouble('long') ?? -500);
      if(_lat==-500){
        _textLat ="No se han cargado las coordenadas";
      }
      else{
        _textLat = "${_lat}";
      }
      if(_lon==-500) {
        _textLong = "No se han cargado las coordenadas";
      }
      else{
        _textLong = "${_lon}";
      }
    });
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
    setState(() {
      prefs.setDouble('lat',(_currentPosition?.latitude ?? -500.0));
      prefs.setDouble('long',(_currentPosition?.longitude ?? -500.0));
    });
    _loadCoords();
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
            Text(
                'LATITUD:',
                style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              _textLat,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Text(
              "",
            ),
            Text(
                'LONGITUD:',
                style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
                _textLong,
                style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
                onPressed: _getCurrentPosition,
                child: Text(_boton)
            )
          ],
        ),
      ),
    );
  }
}