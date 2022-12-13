import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_whm_2/controllers/sendData.dart';
import 'package:overlay_support/overlay_support.dart';

class synchronisation extends StatefulWidget {
  const synchronisation({Key? key}) : super(key: key);

  @override
  State<synchronisation> createState() => _synchronisationState();
}

class _synchronisationState extends State<synchronisation> {
  bool hasInternet = false;
  bool isLoadingVisitor = false;
  bool isLoadingPresence = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Valider'),
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
                        "Pas d'internet",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      background: Colors.red,
                    );
                  } else {
                    setState(() {
                      isLoadingVisitor = true;
                    });

                    print('Internet');

                    var sendResponse = await SendData.postGuest();
                    print(sendResponse);

                    if (sendResponse == 'success') {
                      setState(() {
                        isLoadingVisitor = false;
                      });

                      showSimpleNotification(
                        Text(
                          'Visiteurs Validés',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        background: Colors.green,
                      );
                    } else if (sendResponse == 'error') {
                      setState(() {
                        isLoadingVisitor = false;
                      });
                      showSimpleNotification(
                        Text(
                          'Aucun visiteur enregistré',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        background: Colors.red,
                      );
                    } else {
                      setState(() {
                        isLoadingVisitor = false;
                      });
                      showSimpleNotification(
                        Text(
                          'Une erreur est survenue',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        background: Colors.red,
                      );
                    }
                    //print(responseSync);

                  }
                },
                child: isLoadingVisitor
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
                            'Validation en cours...',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )
                    : Center(
                        child: const Text(
                          'Validation visiteurs',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),
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
                        "Pas d'internet",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      background: Colors.red,
                    );
                  } else {
                    setState(() {
                      isLoadingPresence = true;
                    });

                    print('Internet');

                    var sendResponse = await SendData.postPresence();

                    if (sendResponse != '') {
                      setState(() {
                        isLoadingPresence = false;
                      });

                      showSimpleNotification(
                        Text(
                          'Présences validées',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        background: Colors.green,
                      );
                    } else {
                      setState(() {
                        isLoadingPresence = false;
                      });
                      showSimpleNotification(
                        Text(
                          'Une erreur est survenue',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        background: Colors.red,
                      );
                    }
                    //print(responseSync);

                  }
                },
                child: isLoadingPresence
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
                            'Validation en cours...',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )
                    : Center(
                        child: const Text(
                          'Validation présences',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
