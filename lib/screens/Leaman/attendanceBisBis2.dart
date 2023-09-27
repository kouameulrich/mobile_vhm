// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_whm_2/models/MemberBis2.dart';
import 'package:mobile_whm_2/models/memberBis.dart';
import 'package:mobile_whm_2/screens/Leaman/guestBis2.dart';
import 'package:mobile_whm_2/screens/Leaman/loadDataBis2.dart';
import 'package:mobile_whm_2/screens/Leaman/reset2.dart';
import 'package:mobile_whm_2/screens/Leaman/synchronisation2.dart';
import 'package:mobile_whm_2/widgets/default.colors.dart';
import 'package:mobile_whm_2/widgets/member_item_bis2.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../controllers/Members.dart';
import '../../controllers/readCounter.dart';

class attendanceBisBis2 extends StatefulWidget {
  const attendanceBisBis2({Key? key}) : super(key: key);

  @override
  State<attendanceBisBis2> createState() => _attendanceBisBis2State();
}

class _attendanceBisBis2State extends State<attendanceBisBis2> {
  bool isLocalData = false;
  String query = '';
  bool hasInternet = false;
  late List members = [];
  final myProducts = List<String>.generate(1000, (i) => 'Product $i');
  List<MemberBis2> attendanceStore = [];
  List attendanceIdStore = [];

  late TextEditingController searchController;
  late String? memberStatus;
  String dropdownValue = '';
  bool _showClearIcon = false;

  @override
  initState() {
    searchController = TextEditingController();
    searchController.addListener(searchControllerListener);
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });

      final color = hasInternet ? Colors.green : Colors.red;
      final text = hasInternet ? 'Connexion internet active' : 'Pas Internet';

      showSimpleNotification(
        Text(
          '$text',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        background: color,
      );
    });
    showMembers();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void searchControllerListener() {
    setState(() {
      _showClearIcon = searchController.text.isNotEmpty;
    });
  }

  void _clearSearch() {
    setState(() {
      searchController.clear();
      showMembers();
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  Future showMembers() async {
    final storage = new FlutterSecureStorage();
    // verified existing local secure storage
    final readDataStore = await storage.read(key: 'memberStorage');
    print('readDataStore: ${readDataStore}');

    if (readDataStore == null) {
      //print(readDataStore);
      setState(() {
        isLocalData = false;
      });
    } else {
      //print(readDataStore);
      //Read data storage member
      print('membersStore: ');
      final membersStore = jsonDecode(readDataStore);
      print('membersStore: ${membersStore}');
      //print(members);
      setState(() {
        isLocalData = true;
      });
      return this.members =
          membersStore.map((json) => MemberBis2.fromJson(json)).toList();
    }
  }

  Future writePresenceStorage(MemberBis2 member, int memberLine) async {
    final storage = new FlutterSecureStorage();

    //Update member into list
    final data = await storage.read(key: 'memberStorage');
    final List members = jsonDecode(data!);
    final memberList =
        members.map((json) => MemberBis2.fromJson(json)).toList();

    print(memberList[memberLine].memberLastName);
    print(memberList[memberLine].flag);

    setState(() {
      memberList[memberLine] = member;
    });

    print(memberList[memberLine].flag);

    final listUpdate = jsonEncode(memberList);
    await storage.write(key: 'memberStorage', value: listUpdate);

    //Write attendance score in local storage
    final checkAttendanceStore =
        await storage.containsKey(key: 'presenceStorage');
    final checkAttendanceIdStore =
        await storage.containsKey(key: 'presenceIdStorage');

    if (checkAttendanceStore == false || checkAttendanceIdStore == false) {
      setState(() {
        attendanceStore.add(member);
        attendanceIdStore.add(member.memberId);
      });

      final dataEncoded = json.encode(attendanceStore);
      final dataIdEncoded = json.encode(attendanceIdStore);
      await storage.write(key: 'presenceStorage', value: dataEncoded);
      await storage.write(key: 'presenceIdStorage', value: dataIdEncoded);
      print('attendanceStore.length: ${attendanceStore.length}');
      print('attendanceIdStore.length: ${attendanceIdStore.length}');
      print('attendanceIdStore: ${attendanceIdStore}');
    } else {
      //Read data storage member
      final readAttendanceData = await storage.read(key: 'presenceStorage');
      final List decodeData = jsonDecode(readAttendanceData!);
      final List<MemberBis2> dataToList =
          decodeData.map((json) => MemberBis2.fromJson(json)).toList();

      final readAttendanceIdData = await storage.read(key: 'presenceIdStorage');
      final List decodeIdData = jsonDecode(readAttendanceIdData!);

      setState(() {
        dataToList.add(member);
        decodeIdData.add(member.memberId);
      });

      final dataEncoded = json.encode(dataToList);
      await storage.write(key: 'presenceStorage', value: dataEncoded);

      final dataIdEncoded = json.encode(decodeIdData);
      await storage.write(key: 'presenceIdStorage', value: dataIdEncoded);

      print('dataToList.length: ${dataToList.length}');
      print('decodeIdData.length: ${decodeIdData.length}');
      print('decodeIdData.: ${decodeIdData}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.leamanFondCadre,
      appBar: AppBar(
        title: const Text('VHM Présences'),
        //centerTitle: true,
        actions: [
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return const [
              PopupMenuItem<int>(
                value: 0,
                child: Text("Réinitialiser"),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text("Valider"),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text("Données"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const reset2()),
              );
              print("Reset menu is selected.");
            } else if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const synchronisation2()),
              );
              print("Synchoniser menu is selected.");
            } else if (value == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const loadDataBis2()),
              );
            }
          }),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 15.0, 15.0, 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                      ),
                      child: const Text('Nouvelle Personne'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const guestBis2()),
                        );
                      },
                    ),
                  )
                ],
              ),

              /*--------- ZONE DE RECHERCHE -------*/
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Votre nom ou numéro de téléphone',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Visibility(
                      visible: _showClearIcon,
                      child: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      ),
                    ),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 3, color: Colors.black12), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.black12),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onChanged: searchMember,
                ),
              ),
            ],
          ),
          isLocalData
              ? Expanded(
                  child: ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      MemberBis2 member = members[index];
                      final memberLine = index;
                      return MemberItemBis2(
                        key: ValueKey(member.memberId),
                        item: member,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Alert Présence'),
                              content: SizedBox(
                                height: 150,
                                child: Column(
                                  children: [
                                    Text('Quel est votre status ?'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    DropdownButtonFormField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        helperText: 'Sélectionnez votre Status',
                                        labelText: 'Status',
                                      ),
                                      value: dropdownValue,
                                      items: <String>[
                                        '',
                                        '1. Épouse d\'\honneur (mariée légalement)',
                                        '2. Appelée à Régner (non mariée)',
                                        '3. Demoiselle d\'\honneur (jeune fille non mariée de X à X ans)',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValue = newValue!;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value == '') {
                                          return "Sélectionnez un status";
                                        }
                                        //return null;
                                      },
                                      // onSaved: (value) {
                                      //   memberStatus = value.toString();
                                      // },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                        'Voulez-vous confirmer votre présence ?'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Non'),
                                  child: const Text('Non'),
                                ),
                                TextButton(
                                  child: const Text('Oui'),
                                  onPressed: () async {
                                    member.flag = !member.flag;
                                    setState(() {
                                      members[index] = member;
                                      //print(member.crowdNumber);
                                    });
                                    Navigator.pop(context, 'Oui');
                                    await writePresenceStorage(
                                        member, memberLine);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Aucune donnée',
                      //style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 120,
                    ),
                    ElevatedButton(
                      child: const Text('Actualiser'),
                      onPressed: () async {
                        initState();
                        print('Actualiser');
                      },
                    ),
                    const SizedBox(
                      height: 170,
                    )
                  ],
                ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 15, 8.0, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    var countNewPerson =
                        await ReadCounter.NewPersonStorageBis2();
                    if (countNewPerson == null) {
                      setState(() {
                        countNewPerson = '0';
                      });
                    }
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Alert Nouvelle Personne'),
                        content: Text(
                            'Nombre de nouvelles personnes: $countNewPerson'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    print('$countNewPerson');
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text("Inscriptions"),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    var countPresence = await ReadCounter.PresenceStorageBis();

                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Alert Présence'),
                        content: Text('Nombre de présences: $countPresence'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    print('$countPresence');
                  },
                  icon: const Icon(Icons.people),
                  label: const Text("Présences"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future searchMember(String query) async {
    final members = await Members.searchBis(query);

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.members = members;
    });
  }
}
