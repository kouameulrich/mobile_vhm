import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_whm_2/screens/Members/attendanceBisBis.dart';
import 'package:mobile_whm_2/widgets/default.colors.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../main.dart';

class reset2 extends StatefulWidget {
  const reset2({Key? key}) : super(key: key);

  @override
  State<reset2> createState() => _reset2State();
}

class _reset2State extends State<reset2> {
  //bool isLoading = true;
  Future reset() async {
    final storage = new FlutterSecureStorage();
    // Delete all
    await storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.leamanFondCadre,
      appBar: AppBar(
        title: Text('Réinitialiser'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 50),
                textStyle: TextStyle(
                  fontSize: 25,
                ), // takes postional arguments as width and height
              ),
              onPressed: () async {
                await reset();
                print("delete");
                showSimpleNotification(
                  Text(
                    'Réinitialisation réussie',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  background: Colors.green,
                );
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(builder: (context) => AttendanceBisBis()),
                  );
                });
                //Navigator.pop(context);
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );*/
              },
              child: Text('Réinitialiser'),
            ),
          ],
        ),
      ),
    );
  }
}
