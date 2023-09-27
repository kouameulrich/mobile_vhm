import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_whm_2/controllers/loadData.dart';
import 'package:mobile_whm_2/screens/Members/attendanceBisBis.dart';
import 'package:mobile_whm_2/screens/Leaman/attendanceBisBis2.dart';
import 'package:mobile_whm_2/widgets/default.colors.dart';
import 'package:mobile_whm_2/widgets/mydrawer.dart';
import 'package:overlay_support/overlay_support.dart';

class loadDataBis2 extends StatefulWidget {
  const loadDataBis2({Key? key}) : super(key: key);

  @override
  State<loadDataBis2> createState() => loadDataBis2State();
}

class loadDataBis2State extends State<loadDataBis2> {
  bool hasInternet = false;
  bool isLoading = false;
  var loadResponse;

  Future writeMemberStorage(data) async {
    final storage = new FlutterSecureStorage();
    //final dataListString = data.toString();
    await storage.write(key: 'memberStorage', value: data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.leamanFondCadre,
      appBar: AppBar(
        title: Text('Données'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 40, right: 40),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  hasInternet = await InternetConnectionChecker().hasConnection;
                  if (hasInternet == false) {
                    showSimpleNotification(
                      Text(
                        'Pas de connexion internet',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      background: Colors.red,
                    );
                  } else {
                    print('Internet');
                    setState(() {
                      isLoading = true;
                    });
                    loadResponse = await LoadMemberData.getMemberDataBis();
                    if (loadResponse == '') {
                      print('vide');
                      print(loadResponse);
                      showSimpleNotification(
                        Text(
                          'Echec de chargement ',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        background: Colors.red,
                      );
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      print('non vide');
                      print(loadResponse);
                      print(loadResponse.length);
                      await writeMemberStorage(loadResponse);
                      setState(() {
                        isLoading = false;
                      });
                      showSimpleNotification(
                        Text(
                          'Données chargées',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        background: Colors.green,
                      );
                      print('local storage');
                      Future.delayed(Duration(seconds: 3), () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => attendanceBisBis2()),
                        );
                      });
                    }
                  }
                },
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Chargement...',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )
                    : const Text(
                        'Charger données',
                        style: TextStyle(fontSize: 20),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*
                  loadResponse = await LoadMemberData.getMemberData();
                  print('$loadResponse');
                  try {
                    loadResponse = await LoadMemberData.getMemberData();
                    print('$loadResponse');
                  } on HttpException catch (err) {
                    print('$err');
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                    print('$isLoading');
                  }

                  print('$loadResponse');*/
/*Future.delayed(Duration(seconds: 3), () {
                    setState(() {
                      isLoading = false;
                    });
                    print('$loadResponse');
                  });
                  if (loadResponse == true) {
                    print('$loadResponse');
                    setState(() {
                      isLoading = false;
                    });
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                  }*/
