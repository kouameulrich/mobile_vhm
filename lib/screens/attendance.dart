import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_whm_2/screens/loadData.dart';
import 'package:mobile_whm_2/screens/reset.dart';
import 'package:mobile_whm_2/controllers/readCounter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/member.dart';
import '../controllers/Members.dart';
import '../widgets/member_item.dart';
import '../widgets/search_widget.dart';

class attendance extends StatefulWidget {
  const attendance({Key? key}) : super(key: key);

  @override
  State<attendance> createState() => _attendanceState();
}

class _attendanceState extends State<attendance> {
  bool hasInternet = false;
  String query = '';
  List<Member> members = [];
  bool isLocalData = false;
  bool isLoadLocalData = true;

  bool isLoading = true;

  String $CheckingText = '';

  List memberStorage = [];

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
    isLocalDataChecking();
    init();
    //checkLocalData();
    super.initState();
  }

  Future init() async {
    try {
      final members = await Members.search(query);

      setState(() => this.members = members);
      return '$members';
    } catch (e) {
      return e;
    }
  }

  Future writePresenceStorage(Member member) async {
    // Create storage
    final storage = new FlutterSecureStorage();

    //Update member list
    final readListMemberStorage = await storage.read(key: 'memberStorage');
    final listMember = jsonDecode(readListMemberStorage!);

    print(listMember);

    final data = jsonEncode(listMember);
    await storage.write(key: 'memberStorage', value: data);

    final readDataStore = await storage.containsKey(key: 'presenceStorage');

    if (readDataStore == false) {
      setState(() {
        memberStorage.add(member);
      });

      final memberPresenceStorageValue = json.encode(memberStorage);
      final CounterMemberPresenceStorageValue = memberStorage.length.toString();
      await storage.write(
          key: 'presenceStorage', value: memberPresenceStorageValue);
      await storage.write(
          key: 'counterPresenceStorage',
          value: CounterMemberPresenceStorageValue);

      print(memberStorage.length);

      print(CounterMemberPresenceStorageValue);
    } else {
      //Read data storage member
      final readDataStore = await storage.read(key: 'presenceStorage');
      final List memberStorage = jsonDecode(readDataStore!);

      setState(() {
        memberStorage.add(member);
      });

      final memberPresenceStorageValue = json.encode(memberStorage);
      final CounterMemberPresenceStorageValue = memberStorage.length.toString();
      await storage.write(
          key: 'presenceStorage', value: memberPresenceStorageValue);
      await storage.write(
          key: 'counterPresenceStorage',
          value: CounterMemberPresenceStorageValue);

      print(memberStorage.length);
    }
  }

  Future isLocalDataChecking() async {
    final storage = new FlutterSecureStorage();

    // verified existing local secure storage
    final readDataStore = await storage.read(key: 'memberStorage');

    if (readDataStore == null) {
      setState(() {
        isLocalData = false;
        isLoading = false;
      });
    } else {
      //Read data storage member
      final List members = jsonDecode(readDataStore);
      setState(() {
        isLocalData = true;
        isLoading = false;
      });
      return members;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VHM PRESENCE'),
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
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const nemPersonPage()),
                          );*/
                        },
                      ),
                    )
                  ],
                ),
              ),
              buildSearch(),
            ],
          ),
          isLoading ? Center(child: CircularProgressIndicator()) : Container(),
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
                                  onPressed: () {
                                    member.presence = !member.presence;
                                    setState(() {
                                      members[index] = member;
                                      //print(member.crowdNumber);
                                    });
                                    writePresenceStorage(member);
                                    Navigator.pop(context, 'Oui');
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
                    if (countPresence == null) {
                      setState(() {
                        countPresence = '0';
                      });
                    }
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

          /*Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                Member member = members[index];

                return MemberItem(
                  key: ValueKey(member.id),
                  item: member,
                  onTap: () {
                    /*showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Alert Présence'),
                        content: Text('Voulez-vous confirmer votre présence ?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Non'),
                            child: Text('Non'),
                          ),
                          TextButton(
                            child: Text('Oui'),
                            onPressed: () {
                              member.presence = !member.presence;
                              setState(() {
                                members[index] = member;
                                //print(member.crowdNumber);
                              });
                              writePresenceStorage(member);
                              Navigator.pop(context, 'Oui');
                            },
                          ),
                        ],
                      ),
                    );*/
                  },
                );
              },
            ),
          ),*/
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
