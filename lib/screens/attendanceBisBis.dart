import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_whm_2/models/member.dart';
import 'package:mobile_whm_2/models/memberBis.dart';
import 'package:mobile_whm_2/screens/guestBis.dart';
import 'package:mobile_whm_2/screens/loadDataBis.dart';
import 'package:overlay_support/overlay_support.dart';

import '../controllers/Members.dart';
import '../controllers/readCounter.dart';
import '../widgets/member_item.dart';
import '../widgets/member_item_bis.dart';
import '../widgets/search_widget.dart';
import 'guest.dart';
import 'loadData.dart';
import 'reset.dart';
import 'synchronisation.dart';

class attendanceBisBis extends StatefulWidget {
  const attendanceBisBis({Key? key}) : super(key: key);

  @override
  State<attendanceBisBis> createState() => _attendanceBisBisState();
}

class _attendanceBisBisState extends State<attendanceBisBis> {
  bool isLocalData = false;
  String query = '';
  bool hasInternet = false;
  late List members = [];
  final myProducts = List<String>.generate(1000, (i) => 'Product $i');
  List<MemberBis> attendanceStore = [];
  List attendanceIdStore = [];

  @override
  initState() {
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
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        background: color,
      );
    });
    showMembers();
    super.initState();
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
          membersStore.map((json) => MemberBis.fromJson(json)).toList();
    }
  }

  Future writePresenceStorage(MemberBis member, int memberLine) async {
    final storage = new FlutterSecureStorage();

    //Update member into list
    final data = await storage.read(key: 'memberStorage');
    final List members = jsonDecode(data!);
    final memberList = members.map((json) => MemberBis.fromJson(json)).toList();

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
      final List<MemberBis> dataToList =
          decodeData.map((json) => MemberBis.fromJson(json)).toList();

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
      appBar: AppBar(
        title: Text('VHM Présences'),
        //centerTitle: true,
        actions: [
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
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
                MaterialPageRoute(builder: (context) => const reset()),
              );
              print("Reset menu is selected.");
            } else if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const synchronisation()),
              );
              print("Synchoniser menu is selected.");
            } else if (value == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const loadDataBis()),
              );
            }
          }),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 15.0, 15.0, 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                        ),
                        child: Text('Nouvelle Personne'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const guestBis()),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              buildSearch(),
            ],
          ),
          isLocalData
              ? Expanded(
                  child: ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      MemberBis member = members[index];
                      final memberLine = index;
                      return MemberItemBis(
                        key: ValueKey(member.memberId),
                        item: member,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text('Alert Présence'),
                              content: Text(
                                  'Voulez-vous confirmer votre présence ?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Non'),
                                  child: Text('Non'),
                                ),
                                TextButton(
                                  child: Text('Oui'),
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
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Aucune donnée',
                      //style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 120,
                    ),
                    ElevatedButton(
                      child: Text('Actualiser'),
                      onPressed: () async {
                        initState();
                        print('Actualiser');
                      },
                    ),
                    SizedBox(
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
                        await ReadCounter.NewPersonStorageBis();
                    if (countNewPerson == null) {
                      setState(() {
                        countNewPerson = '0';
                      });
                    }
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Alert Nouvelle Personne'),
                        content: Text(
                            'Nombre de nouvelles personnes: $countNewPerson'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                    print('$countNewPerson');
                  },
                  icon: Icon(Icons.person_add),
                  label: Text("Inscriptions"),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    var countPresence = await ReadCounter.PresenceStorageBis();

                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Alert Présence'),
                        content: Text('Nombre de présences: $countPresence'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                    print('$countPresence');
                  },
                  icon: Icon(Icons.people),
                  label: Text("Présences"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Votre nom ou numéro de téléphone',
        onChanged: searchMember,
      );

  Future searchMember(String query) async {
    final members = await Members.searchBis(query);

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.members = members;
    });
  }
}
