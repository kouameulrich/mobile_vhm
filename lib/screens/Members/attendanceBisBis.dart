import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_whm_2/models/memberBis.dart';
import 'package:mobile_whm_2/screens/Members/guestBis.dart';
import 'package:mobile_whm_2/screens/Members/loadDataBis.dart';
import 'package:mobile_whm_2/widgets/default.colors.dart';
import 'package:mobile_whm_2/widgets/member_item_bis.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../controllers/Members.dart';
import '../../controllers/readCounter.dart';
import 'reset.dart';
import 'synchronisation.dart';

class AttendanceBisBis extends StatefulWidget {
  const AttendanceBisBis({Key? key}) : super(key: key);

  @override
  State<AttendanceBisBis> createState() => _AttendanceBisBisState();
}

class _AttendanceBisBisState extends State<AttendanceBisBis> {
  bool isLocalData = false;
  String query = '';
  bool hasInternet = false;
  late List<MemberBis> members = [];
  final myProducts = List<String>.generate(1000, (i) => 'Product $i');
  List<MemberBis> attendanceStore = [];
  List attendanceIdStore = [];

  late TextEditingController searchController;
  bool _showClearIcon = false;

  @override
  void initState() {
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

  Future<void> showMembers() async {
    final storage = const FlutterSecureStorage();
    final readDataStore = await storage.read(key: 'memberStorage');

    if (readDataStore == null) {
      setState(() {
        isLocalData = false;
      });
    } else {
      final membersStore = jsonDecode(readDataStore);
      setState(() {
        isLocalData = true;
      });
      return this.members =
          membersStore.map((json) => MemberBis.fromJson(json)).toList();
    }
  }

  Future<void> writePresenceStorage(MemberBis member, int memberLine) async {
    final storage = const FlutterSecureStorage();
    final data = await storage.read(key: 'memberStorage');
    final List membersList = jsonDecode(data!);
    final memberList =
        membersList.map((json) => MemberBis.fromJson(json)).toList();

    setState(() {
      memberList[memberLine] = member;
    });

    final listUpdate = jsonEncode(memberList);
    await storage.write(key: 'memberStorage', value: listUpdate);

    final checkAttendanceStore =
        await storage.containsKey(key: 'presenceStorage');
    final checkAttendanceIdStore =
        await storage.containsKey(key: 'presenceIdStorage');

    if (!checkAttendanceStore || !checkAttendanceIdStore) {
      setState(() {
        attendanceStore.add(member);
        attendanceIdStore.add(member.memberId);
      });

      final dataEncoded = json.encode(attendanceStore);
      final dataIdEncoded = json.encode(attendanceIdStore);
      await storage.write(key: 'presenceStorage', value: dataEncoded);
      await storage.write(key: 'presenceIdStorage', value: dataIdEncoded);
    } else {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.blueFondCadre,
      appBar: AppBar(
        title: const Text('VHM Présences'),
        actions: [
          PopupMenuButton(
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
            },
            onSelected: (value) {
              if (value == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const reset()),
                );
              } else if (value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const synchronisation()),
                );
              } else if (value == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const loadDataBis()),
                );
              }
            },
          ),
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
                            builder: (context) => const guestBis(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
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
                        width: 3,
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black12,
                      ),
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
                      final memberLine = index;
                      final MemberBis member = members[index];
                      return MemberItemBis(
                        key: ValueKey(member.memberId),
                        item: member,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Alerte Présence'),
                              content: SizedBox(
                                height: 140,
                                child: Column(
                                  children: [
                                    Lottie.asset(
                                      'animations/read.json',
                                      repeat: true,
                                      reverse: true,
                                      fit: BoxFit.cover,
                                      height: 100,
                                    ),
                                    const Text(
                                      'Voulez-vous confirmer votre présence ?',
                                      textAlign: TextAlign.center,
                                    ),
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
                    ),
                    const SizedBox(
                      height: 120,
                    ),
                    ElevatedButton(
                      child: const Text('Actualiser'),
                      onPressed: () async {
                        initState();
                      },
                    ),
                    const SizedBox(
                      height: 170,
                    )
                  ],
                ),
        ],
      ),
    );
  }

  Future<void> searchMember(String query) async {
    final members = await Members.searchBis(query);

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.members = members;
    });
  }
}
