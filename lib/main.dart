import 'package:flutter/material.dart';
import 'package:mobile_whm_2/screens/Members/attendanceBisBis.dart';
import 'package:mobile_whm_2/screens/home.page.dart';
import 'package:mobile_whm_2/screens/login.page.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'VHM PRESENCE';

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.teal),
        initialRoute: '/',
        routes: {
          '/': (context) => MainPage(),
          '/loginpage': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/attendanceBisBis': (context) => AttendanceBisBis(),
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: buildBottomBar(),
      body: HomePage(),
    );
  }
}
