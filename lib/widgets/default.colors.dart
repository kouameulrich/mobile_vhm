import 'package:flutter/material.dart';

class Defaults {
  //static const Color drawerItemColor = Colors.green;
  static const MaterialColor primaryBleuColor = MaterialColor(
    0xFF00C0F0,
    <int, Color>{
      50: Color(0xFF00C0F0),
      100: Color(0xFF00C0F0),
      200: Color(0xFF00C0F0),
      300: Color(0xFF00C0F0),
      400: Color(0xFF00C0F0),
      500: Color(0xFF00C0F0),
      600: Color(0xFF00C0F0),
      700: Color(0xFF00C0F0),
      800: Color(0xFF00C0F0),
      900: Color(0xFF00C0F0),
    },
  );
  static const MaterialColor primaryGreenColor = MaterialColor(
    0xFF14c9a6,
    <int, Color>{
      50: Color(0xFF14c9a6),
      100: Color(0xFF14c9a6),
      200: Color(0xFF14c9a6),
      300: Color(0xFF14c9a6),
      400: Color(0xFF14c9a6),
      500: Color(0xFF14c9a6),
      600: Color(0xFF14c9a6),
      700: Color(0xFF14c9a6),
      800: Color(0xFF14c9a6),
      900: Color(0xFF14c9a6),
    },
  );
  static final Color? drawerItemSelectedColor = Colors.green[700];
  static final Color? drawerSelectedTileColor = Colors.green[100];
  static const Color backgroundColorPage = Color.fromRGBO(232, 244, 251, 1);
  static const Color bottomColor = Color.fromRGBO(20, 201, 166, 1);
  static const Color appBarColor = Color.fromRGBO(15, 81, 105, 1);
  static const Color libelleColor = Color.fromRGBO(17, 80, 107, 1);
  static const Color textColor = Color.fromRGBO(19, 76, 104, 1);
  static const Color bluePrincipal = Color(0xFF0f5169);
  static const Color leamanPrincipal = Color.fromARGB(255, 173, 24, 153);
  static const Color greenPrincipal = Color(0xFF14c9a6);
  static const Color greenSelected = Color(0xFF59f1d3);
  static const Color greenMenuColor = Color.fromARGB(255, 44, 98, 82);
  static const Color blueFondCadre = Color(0xFFe8f6f9);
  static const Color leamanFondCadre = Color.fromARGB(255, 246, 232, 249);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color blueAppBar = Color.fromRGBO(15, 81, 105, 1);

  static final drawerItemText = [
    'Acceuil',
    'V H M',
    // 'Transfert des données',
  ];

  static final drawerItemIcon = [
    Icons.home,
    Icons.list,
    // Icons.send,
  ];
}
