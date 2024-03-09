import 'package:flutter/material.dart';
import 'package:proyectocc/screens/Calendario.dart';
import 'package:proyectocc/screens/Tools/dateTimePicker.dart';
import 'package:proyectocc/screens/prueba.dart';

import 'screens/nfc.dart';
import 'screens/Mapa.dart';
import 'screens/Coordenadas.dart';
import 'screens/bienvenida.dart';
import 'screens/pantallaBase.dart';
import 'screens/calc.dart';
import 'screens/login.dart';
import 'screens/graficos.dart';
import 'screens/unity.dart';

class MainNavigator extends StatefulWidget{

  const MainNavigator({Key? key}) : super(key: key);

  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator>{
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<Widget> _screens=[
    const MyWelcomeScreen(title: "Bienvenida"),
    const coordenadas(title: "Ubicación"),
    const Graficos(title: "Gráficos"),
    const NFC(title: "Pruebas NFC"),
    //const Unity(title: "Unity"),
    const LoginScreen(title: "Inicio de sesión"),
    const pantallaBase(title: "El contador en la nube"),
    const Calendario(title: "Calendario"),
    const Calculadora(title: "Calculadora"),
    const nuevaPantalla(title: "Mapa"),
  ];

  void _onPageChanged(int index){
    setState(() {
      _selectedIndex=index;
    });
  }

  void _onItemTapped(int i){
    _pageController.jumpToPage(i);
  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            children: _screens,
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                                  BottomNavigationBarItem(
                                        icon: Icon(Icons.home_outlined),
                                        label: "Home",
                                  ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.title),
                    label: "Pantalla"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart),
                    label: "Gráficos"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.nfc),
                    label: "NFC"
                ),
                /*BottomNavigationBarItem(
                    icon: Icon(Icons.videogame_asset_outlined),
                    label: "Unity"
                ),*/
                BottomNavigationBarItem(
                    icon: Icon(Icons.login),
                    label: "Login"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.cloud),
                    label: "Contador"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today_sharp),
                    label: "Calendario"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calculate),
                    label: "Calculadora"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.map),
                    label: "Mapa"
                ),
              ],
              onTap: _onItemTapped,
              currentIndex: _selectedIndex,
            ),
          ),
        )
    );
  }
}