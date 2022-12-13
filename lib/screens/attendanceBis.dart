import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_whm_2/models/member.dart';
import 'package:overlay_support/overlay_support.dart';

import '../controllers/Members.dart';
import '../controllers/readCounter.dart';
import '../widgets/member_item.dart';
import '../widgets/search_widget.dart';
import 'guest.dart';
import 'loadData.dart';
import 'reset.dart';
import 'synchronisation.dart';

class attendanceBis extends StatefulWidget {
  const attendanceBis({Key? key}) : super(key: key);

  @override
  State<attendanceBis> createState() => _attendanceBisState();
}

class _attendanceBisState extends State<attendanceBis> {
  bool isLocalData = false;
  String query = '';
  bool hasInternet = false;
  List<Member> members = [];
  final myProducts = List<String>.generate(1000, (i) => 'Product $i');
  List<Member> attendanceStore = [];

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

    if (readDataStore == null) {
      setState(() {
        isLocalData = false;
      });
    } else {
      //Read data storage member
      final List members = jsonDecode(readDataStore);
      print(members.length);
      setState(() {
        isLocalData = true;
      });
      return this.members =
          members.map((json) => Member.fromJson(json)).toList();
    }
  }

  Future writePresenceStorage(Member member) async {
    //Update member into list
    final storage = new FlutterSecureStorage();
    final data = await storage.read(key: 'memberStorage');
    final List members = jsonDecode(data!);
    final memberList = members.map((json) => Member.fromJson(json)).toList();

    print(memberList[member.id].presence);
    setState(() {
      memberList[member.id] = member;
    });
    print(memberList[member.id].presence);
    final listUpdate = jsonEncode(memberList);
    await storage.write(key: 'memberStorage', value: listUpdate);

    //Write attendance score in local storage
    final checkAttendanceStore =
        await storage.containsKey(key: 'presenceStorage');

    if (checkAttendanceStore == false) {
      setState(() {
        attendanceStore.add(member);
      });

      final dataEncoded = json.encode(attendanceStore);
      await storage.write(key: 'presenceStorage', value: dataEncoded);
      print(dataEncoded.length);
    } else {
      //Read data storage member
      final readAttendanceData = await storage.read(key: 'presenceStorage');
      final List decodeData = jsonDecode(readAttendanceData!);
      final List<Member> dataToList =
          decodeData.map((json) => Member.fromJson(json)).toList();

      setState(() {
        dataToList.add(member);
      });

      final dataEncoded = json.encode(dataToList);
      await storage.write(key: 'presenceStorage', value: dataEncoded);

      print(dataEncoded.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VHM PRESENCE BIS'),
        //centerTitle: true,
        actions: [
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Text("Reset"),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text("Syncroniser"),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text("Charger données"),
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
                MaterialPageRoute(builder: (context) => const loadData()),
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
                                builder: (context) => const guest()),
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
                      Member member = members[index];
                      return MemberItem(
                        key: ValueKey(member.id),
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
                                    member.presence = !member.presence;
                                    setState(() {
                                      members[index] = member;
                                      //print(member.crowdNumber);
                                    });
                                    Navigator.pop(context, 'Oui');
                                    await writePresenceStorage(member);
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
                    var countNewPerson = await ReadCounter.NewPersonStorage();
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
                    var countPresence = await ReadCounter.PresenceStorage();

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
    final members = await Members.search(query);

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.members = members;
    });
  }
}
