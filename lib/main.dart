import 'package:flutter/material.dart';
import 'package:mobile_whm_2/screens/attendanceBis.dart';
import 'package:mobile_whm_2/screens/attendanceBisBis.dart';
import 'package:overlay_support/overlay_support.dart';
import 'screens/attendance.dart';

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
        home: MainPage(),
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
      body: attendanceBisBis(),
    );
  }
}
