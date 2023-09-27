import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_whm_2/models/guestPost.dart';
import 'package:mobile_whm_2/screens/Members/attendanceBisBis.dart';
import 'package:mobile_whm_2/widgets/Zone_de_saisie.dart';
import 'package:mobile_whm_2/widgets/default.colors.dart';
import 'package:intl/intl.dart';

import '../../models/memberBis.dart';

class guestBis extends StatefulWidget {
  const guestBis({Key? key}) : super(key: key);

  @override
  State<guestBis> createState() => _guestBisState();
}

class _guestBisState extends State<guestBis> {
  final _formKey = GlobalKey<FormState>();
  List<GuestPost> newPersonStorage = [];

  TextEditingController _selectedValue = TextEditingController();
  TextEditingController membersFistNameController = TextEditingController();
  TextEditingController membersLastNameController = TextEditingController();
  TextEditingController memberPhoneController = TextEditingController();
  TextEditingController memberInvitedByController = TextEditingController();
  TextEditingController memberGenderController = TextEditingController();
  List<String> listOfGender = [
    'Homme',
    'Femme',
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    _selectedValue.dispose();
    membersFistNameController.dispose();
    membersLastNameController.dispose();
    memberPhoneController.dispose();
    memberInvitedByController.dispose();
    memberGenderController.dispose();
    super.dispose();
  }

  Future searchGest(phone) async {
    //create storage
    final storage = new FlutterSecureStorage();

    // check if storage member exist
    final checkStorageMember = await storage.containsKey(key: 'memberStorage');
    print("checkStorageMember: $checkStorageMember");

    if (checkStorageMember == true) {
      final data = await storage.read(key: 'memberStorage');
      final List members = jsonDecode(data!);
      print("members: $members");
      final memberList =
          members.map((json) => MemberBis.fromJson(json)).toList();
      final resultSearch =
          memberList.where((x) => x.memberPhone == phone.toString()).toList();
      if (resultSearch.isNotEmpty) {
        return "member";
      }

      final checkStorageGuest =
          await storage.containsKey(key: 'mewPersonStorage');
      print("checkStorageGuest: $checkStorageGuest");
      if (checkStorageGuest == true) {
        final dataGuest = await storage.read(key: 'mewPersonStorage');
        final guests = jsonDecode(dataGuest!);
        print("guests TRUE: $guests");
        final memberList =
            guests.map((json) => GuestPost.fromJson(json)).toList();
        final searchGuest =
            memberList.where((x) => x.memberPhone == phone).toList();
        if (searchGuest.isNotEmpty) {
          return "guest";
        }
        return "vide";
      }
      return "vide";
    } else {
      final checkStorageGuest =
          await storage.containsKey(key: 'mewPersonStorage');
      print("checkStorageGuest: $checkStorageGuest");
      if (checkStorageGuest == true) {
        final dataGuest = await storage.read(key: 'mewPersonStorage');
        final List guests = jsonDecode(dataGuest!);
        print("guests FALSE: $guests");
        final memberList =
            guests.map((json) => GuestPost.fromJson(json)).toList();
        final searchGuest =
            memberList.where((x) => x.memberPhone == phone).toList();
        if (searchGuest.isNotEmpty) {
          return "guest";
        }
        return "vide";
      }
      return "vide";
    }
  }

  Future writeGuestStorage(
    String memberLastName,
    String memberFirstName,
    String memberPhone,
    String memberInvitedBy,
    Object memberGender,
  ) async {
    final memberDateOfEntry = DateTime.now();
    final memberGenderString = memberGender.toString();

    GuestPost newPerson = GuestPost(
      memberLastName: memberLastName,
      memberFirstName: memberFirstName,
      memberPhone: memberPhone,
      memberDateOfEntry: memberDateOfEntry.toString(),
      memberInvitedBy: memberInvitedBy,
      memberGender: memberGenderString,
      churchId: 1,
      memberTypeId: 1,
    );

    // Create storage
    final storage = new FlutterSecureStorage();

    final readDataStore = await storage.containsKey(key: 'mewPersonStorage');

    if (readDataStore == false) {
      setState(() {
        newPersonStorage.add(newPerson);
      });
      print('mewPersonStorage length: ${newPersonStorage.length}');

      final newPersonStorageValue = json.encode(newPersonStorage);

      print('newPersonStorageValue: ${newPersonStorageValue}');

      await storage.write(
          key: 'mewPersonStorage', value: newPersonStorageValue);
    } else {
      print('Stop');

      //Read data storage member
      final readDataStore = await storage.read(key: 'mewPersonStorage');
      final newPersonStorage = jsonDecode(readDataStore!);

      /*newPersonStorage =
          dataDecode.map((json) => GuestPost.fromJson(json)).toList();*/

      setState(() {
        newPersonStorage.add(newPerson);
      });

      print('new person: ${newPersonStorage}');
      final newPersonStorageValue = json.encode(newPersonStorage);

      await storage.write(
          key: 'mewPersonStorage', value: newPersonStorageValue);

      print(newPersonStorage.length);
    }

    //print(readDataStore);

    // Write value
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.blueFondCadre,
      appBar: AppBar(
        backgroundColor: Defaults.blueAppBar,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('NOUVELLE PERSONNE'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Defaults.blueFondCadre),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Theme(
                  data: ThemeData(primarySwatch: Defaults.primaryBleuColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 3, left: 13, right: 13),
                        child: Column(
                          children: [
                            // --------------- CHAMP DE SAISIE 1 ---------- //
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text('Saisissez votre nom')),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ZoneSaisie(
                                  context, membersFistNameController),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // --------------- CHAMP DE SAISIE 2 ---------- //
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text('Saisissez vos prénoms')),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ZoneSaisie(
                                  context, membersLastNameController),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // --------------- CHAMP DE SAISIE 3 ---------- //
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text('Saisissez votre numéro')),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ZoneSaisie(context, memberPhoneController),
                            ),
                            // --------------- CHAMP DE SAISIE 4 ---------- //
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text("Saisissez le nom de l'inviteur")),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ZoneSaisie(
                                  context, memberInvitedByController),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // --------------- CHAMP DE SAISIE 5 ---------- //
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text('Sélectionnez votre genre')),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  fillColor: Defaults.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                ),
                                value: _selectedValue.text.isNotEmpty
                                    ? _selectedValue.text
                                    : null,
                                hint: const Text(
                                  'Genre',
                                ),
                                isExpanded: true,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedValue.text = value!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value == '') {
                                    return "Sélectionnez un genre";
                                  } else {
                                    return null;
                                  }
                                },
                                items: listOfGender.map((String val) {
                                  return DropdownMenuItem(
                                    value: val,
                                    child: Text(
                                      val,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 15, left: 0, right: 0, top: 15),
                              child: ElevatedButton(
                                onPressed: () async {
                                  onSave();
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Defaults.bluePrincipal)),
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 15, left: 0, right: 0, top: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.save_alt_rounded,
                                        color: Defaults.white,
                                      ),
                                      Text(
                                        'Valider',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Defaults.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
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

  onSave() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Alerte Nouvelle Personne',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                Lottie.asset(
                  'animations/verif.json',
                  repeat: true,
                  reverse: true,
                  fit: BoxFit.cover,
                  height: 110,
                ),
                const Text(
                  'Voulez-vous valider votre inscription ?',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Non'),
              child: Text('Non'),
            ),
            TextButton(
              child: Text('Oui'),
              onPressed: () async {
                final search = await searchGest(memberPhoneController);

                switch (search) {
                  case "member":
                    {
                      Navigator.pop(context);
                      AlertDialog(
                        title: const Text(
                          'Alerte Nouvelle Personne',
                          textAlign: TextAlign.center,
                        ),
                        content: SizedBox(
                          height: 150,
                          child: Column(
                            children: [
                              Lottie.asset(
                                'animations/sorry.json',
                                repeat: true,
                                reverse: true,
                                fit: BoxFit.cover,
                                height: 110,
                              ),
                              const Text(
                                'Vous êtes déjà membre',
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
                    }
                    break;

                  case "guest":
                    {
                      Navigator.pop(context);
                      AlertDialog(
                        title: const Text(
                          'Alerte Nouvelle Personne',
                          textAlign: TextAlign.center,
                        ),
                        content: SizedBox(
                          height: 150,
                          child: Column(
                            children: [
                              Lottie.asset(
                                'animations/sorry.json',
                                repeat: true,
                                reverse: true,
                                fit: BoxFit.cover,
                                height: 110,
                              ),
                              const Text(
                                'Vous êtes déjà enregistré',
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
                    }
                    break;

                  case "vide":
                    {
                      await writeGuestStorage(
                        membersLastNameController.text,
                        membersFistNameController.text,
                        memberPhoneController.text,
                        memberInvitedByController.text,
                        memberGenderController.text,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Enregistrement réussi')));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceBisBis(),
                        ),
                      );
                    }
                    break;

                  default:
                    {
                      print("n'existe pas");
                    }
                    break;
                }
                print(search);
              },
            ),
          ],
        ),
      );
    }
  }
}
