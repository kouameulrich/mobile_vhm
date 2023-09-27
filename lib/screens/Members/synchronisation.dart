import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_whm_2/controllers/readCounter.dart';
import 'package:mobile_whm_2/controllers/sendData.dart';
import 'package:mobile_whm_2/models/memberBis.dart';
import 'package:mobile_whm_2/screens/Members/attendanceBisBis.dart';
import 'package:mobile_whm_2/widgets/default.colors.dart';
import 'package:mobile_whm_2/widgets/loading.indicator.dart';
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
  String presenceCount = '';
  String newPersonCount = '';

  // Function to fetch the presence count
  Future<void> fetchPresenceCount() async {
    final count = await ReadCounter.PresenceStorageBis();
    setState(() {
      presenceCount = count ?? '0';
    });
  }

  // Function to fetch the presence count
  Future<void> fetchNewPersonStorageBis() async {
    final count = await ReadCounter.NewPersonStorageBis();
    setState(() {
      newPersonCount = count ?? '0';
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    //CHECKING PRESENCE MEMBER NUMBER
    fetchPresenceCount();

    //CHECKING PRESENCE NEW MEMBER NUMBER
    fetchNewPersonStorageBis();

    //CHECKING CONNECTION
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });

      final color = hasInternet ? Colors.green : Colors.red;
      final text = hasInternet ? 'Connexion internet active' : 'Pas Internet';
      showSimpleNotification(
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        background: color,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.blueFondCadre,
      appBar: AppBar(
        title: const Text('Valider'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Card(
                  color: Colors.white,
                  elevation: 70,
                  child: SizedBox(
                    width: 270,
                    height: 270,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            "Nouveau Membre",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: Defaults.appBarColor,
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Nombre:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.bluePrincipal),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  newPersonCount,
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.bluePrincipal),
                                ),
                                const Text(
                                  'Nouveau Membre Présent',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Defaults.bluePrincipal),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              onPressed: () {
                                _transferNewMembersToServer();
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Defaults.bottomColor)),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send),
                                    Text(
                                      'Transferer',
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Card(
                  color: Colors.white,
                  elevation: 70,
                  child: SizedBox(
                    width: 270,
                    height: 270,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            "Membre",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: Defaults.appBarColor,
                            ),
                            // ignore: prefer_const_constructors
                            child: Column(
                              children: [
                                const Text(
                                  'Nombre:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.bluePrincipal),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  presenceCount,
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Defaults.bluePrincipal),
                                ),
                                const Text(
                                  'Membre Présent',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Defaults.bluePrincipal),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              onPressed: () {
                                //_transferMembersToServer();
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Defaults.bottomColor)),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send),
                                    Text(
                                      'Transferer',
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _transferNewMembersToServer() async {
    hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet == false) {
      // ignore: use_build_context_synchronously
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('ERROR',
                style: TextStyle(color: Defaults.blueAppBar)),
            content: SizedBox(
              height: 140,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/nodata.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                  const Text(
                    'Vérifiez votre connexion Internet et réessayez.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      LoadingIndicatorDialog().dismiss();
      setState(() {
        isLoadingVisitor = true;
      });

      //APPEL DE L'API D'ENVOI
      var sendResponse = await SendData.postGuest();

      if (sendResponse == 'success') {
        setState(() {
          isLoadingVisitor = false;
        });
        // ignore: use_build_context_synchronously
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'SUCCESS',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 140,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/success.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                  const Text(
                    'Nouveau membre validé avec succès',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('RETOUR'))
            ],
          ),
        );
      } else if (sendResponse == 'error') {
        LoadingIndicatorDialog().dismiss();
        setState(() {
          isLoadingVisitor = false;
        });
        // ignore: use_build_context_synchronously
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('ERROR',
                  style: TextStyle(color: Defaults.blueAppBar)),
              content: SizedBox(
                height: 140,
                child: Column(
                  children: [
                    Lottie.asset(
                      'animations/nodata.json',
                      repeat: true,
                      reverse: true,
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                    const Text(
                      'Aucun visiteur enregistré .',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        LoadingIndicatorDialog().dismiss();
        setState(() {
          isLoadingVisitor = false;
        });
        // ignore: use_build_context_synchronously
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('ERROR',
                  style: TextStyle(color: Defaults.blueAppBar)),
              content: SizedBox(
                height: 140,
                child: Column(
                  children: [
                    Lottie.asset(
                      'animations/nodata.json',
                      repeat: true,
                      reverse: true,
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                    const Text(
                      'Une erreur est survenue .',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  _transferMembersToServer() async {
    hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet == false) {
      // ignore: use_build_context_synchronously
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('ERROR',
                style: TextStyle(color: Defaults.blueAppBar)),
            content: SizedBox(
              height: 140,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/nodata.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                  const Text(
                    'Vérifiez votre connexion Internet et réessayez.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      LoadingIndicatorDialog().dismiss();
      setState(() {
        isLoadingVisitor = true;
      });

      //APPEL DE L'API D'ENVOI
      var sendResponse = await SendData.postPresence();

      if (sendResponse == 'success') {
        setState(() {
          isLoadingPresence = true;
        });
        // ignore: use_build_context_synchronously
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'SUCCESS',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 140,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/success.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                  const Text(
                    'Membre validé avec succès',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('RETOUR'))
            ],
          ),
        );
      } else {
        LoadingIndicatorDialog().dismiss();
        setState(() {
          isLoadingPresence = false;
        });
        // ignore: use_build_context_synchronously
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('ERROR',
                  style: TextStyle(color: Defaults.blueAppBar)),
              content: SizedBox(
                height: 140,
                child: Column(
                  children: [
                    Lottie.asset(
                      'animations/nodata.json',
                      repeat: true,
                      reverse: true,
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                    const Text(
                      'Une erreur est survenue .',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
