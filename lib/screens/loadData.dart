import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_whm_2/controllers/loadData.dart';
import 'package:overlay_support/overlay_support.dart';

import 'attendance.dart';

class loadData extends StatefulWidget {
  const loadData({Key? key}) : super(key: key);

  @override
  State<loadData> createState() => loadDataState();
}

class loadDataState extends State<loadData> {
  bool hasInternet = false;
  bool isLoading = false;
  var loadResponse;

  Future writeMemberStorage(String data) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'memberStorage', value: data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Charger données'),
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
                    loadResponse = await LoadMemberData.getMemberData();
                    if (loadResponse == '') {
                      print('vide');
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
                      await writeMemberStorage(loadResponse);
                      setState(() {
                        isLoading = false;
                      });
                      showSimpleNotification(
                        Text(
                          'Chargement réussi',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        background: Colors.green,
                      );
                      print('local storage');
                      Future.delayed(Duration(seconds: 3), () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(builder: (context) => attendance()),
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
