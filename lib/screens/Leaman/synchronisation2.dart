import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_whm_2/controllers/sendData.dart';
import 'package:mobile_whm_2/widgets/default.colors.dart';
import 'package:overlay_support/overlay_support.dart';

class synchronisation2 extends StatefulWidget {
  const synchronisation2({Key? key}) : super(key: key);

  @override
  State<synchronisation2> createState() => _synchronisation2State();
}

class _synchronisation2State extends State<synchronisation2> {
  bool hasInternet = false;
  bool isLoadingVisitor = false;
  bool isLoadingPresence = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.leamanFondCadre,
      appBar: AppBar(
        title: const Text('Valider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 40, right: 40),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  hasInternet = await InternetConnectionChecker().hasConnection;
                  if (hasInternet == false) {
                    showSimpleNotification(
                      const Text(
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

                    var sendResponse = await SendData.postGuestLeaman();
                    print(sendResponse);

                    if (sendResponse == 'success') {
                      setState(() {
                        isLoadingVisitor = false;
                      });

                      showSimpleNotification(
                        const Text(
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
                        const Text(
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
                        const Text(
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
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                    : const Center(
                        child: Text(
                          'Validation visiteurs',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 40, right: 40),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  hasInternet = await InternetConnectionChecker().hasConnection;
                  if (hasInternet == false) {
                    showSimpleNotification(
                      const Text(
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

                    var sendResponse = await SendData.postPresenceLeaman();

                    if (sendResponse != '') {
                      setState(() {
                        isLoadingPresence = false;
                      });

                      showSimpleNotification(
                        const Text(
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
                        const Text(
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
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                    : const Center(
                        child: Text(
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
