import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_whm_2/controllers/Guests.dart';
import 'package:mobile_whm_2/models/guest.dart';
import 'package:mobile_whm_2/models/guestPost.dart';
import 'package:mobile_whm_2/screens/attendanceBis.dart';
import 'package:mobile_whm_2/screens/attendanceBisBis.dart';

import '../main.dart';
import '../models/member.dart';
import '../models/memberBis.dart';

class guestBis extends StatefulWidget {
  const guestBis({Key? key}) : super(key: key);

  @override
  State<guestBis> createState() => _guestBisState();
}

class _guestBisState extends State<guestBis> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String dropdownValue = '';
  String dropdownValue2 = 'Treichville';
  String query = '';
  final controllerCity = TextEditingController();
  late String memberLastName, memberFirstName, memberPhone, memberInvitedBy;
  late Object memberGender;
  late String memberDateOfEntry;
  late int churchId;
  late int memberTypeId;

  //Object? NewPersonGendle, NewPersonResigence;

  List<GuestPost> newPersonStorage = [];

  var searchResponse = '';
  var resultSearch;
  var searchGuest;

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

    print('memberLastName: ${newPerson.memberLastName}');
    print('memberFirstName: ${newPerson.memberFirstName}');
    print('memberPhone: ${newPerson.memberPhone}');
    print('memberDateOfEntry: ${newPerson.memberDateOfEntry}');
    print('memberInvitedBy: ${newPerson.memberInvitedBy}');
    print('memberGender: ${newPerson.memberGender}');
    print('churchId: ${newPerson.churchId}');
    print('memberTypeId: ${newPerson.memberTypeId}');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle Personne'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 15.0, 15.0, 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Saisissez votre nom s'il vous plait";
                            }
                            //return null;
                          },
                          onSaved: (value) {
                            memberLastName = value!;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Saisissez votre nom',
                            labelText: 'Nom',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Saisissez vos prénoms s'il vous plait";
                      }
                      //return null;
                    },
                    onSaved: (value) {
                      memberFirstName = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Saisissez vos prénoms',
                      labelText: 'Prénoms',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Saisissez votre numéro de téléphone s'il vous plait";
                      }
                      //return null;
                    },
                    onSaved: (value) {
                      memberPhone = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Saisissez votre numéro',
                      labelText: 'Numéro de téléphone',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    /*validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Saisissez le nom de l'inviteur";
                      }
                      //return null;
                    },*/
                    onSaved: (value) {
                      memberInvitedBy = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Saisissez le nom de l'inviteur",
                      labelText: "Nom de l'inviteur",
                    ),
                  ),
                ),
                /*Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Saisissez votre numéro de téléphone s'il vous plait";
                      }
                      //return null;
                    },
                    onSaved: (value) {
                      NewPersonNameWhoInviteNumber = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Saisissez le numéro de l'inviteur",
                      helperText: "Qui vous a invité ?",
                      labelText: "Numéro de l'inviteur",
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),*/
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: 'Sélectionnez votre genre',
                      labelText: 'Genre',
                    ),
                    value: dropdownValue,
                    items: <String>['', 'Homme', 'Femme']
                        .map<DropdownMenuItem<String>>((String value) {
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
                        return "Sélectionnez un genre";
                      }
                      //return null;
                    },
                    onSaved: (value) {
                      memberGender = value!;
                    },
                  ),
                ),
                /*Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Lieu d'habitaton",
                    ),
                    value: dropdownValue2,
                    items: <String>['Treichville', 'Marcory']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue2 = newValue!;
                      });
                    },
                    onSaved: (value) {
                      NewPersonResigence = value;
                    },
                  ),
                ),*/
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(50),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text('Alerte Nouvelle Personne'),
                                  content: Text(
                                      'Voulez-vous valider votre inscription ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Non'),
                                      child: Text('Non'),
                                    ),
                                    TextButton(
                                      child: Text('Oui'),
                                      onPressed: () async {
                                        final search =
                                            await searchGest(memberPhone);

                                        switch (search) {
                                          case "member":
                                            {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                        'Vous êtes déjà membre')));
                                            }
                                            break;

                                          case "guest":
                                            {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                        'Vous êtes déjà enregistré')));
                                            }
                                            break;

                                          case "vide":
                                            {
                                              await writeGuestStorage(
                                                memberLastName,
                                                memberFirstName,
                                                memberPhone,
                                                memberInvitedBy,
                                                memberGender,
                                              );
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(SnackBar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    content: Text(
                                                        'Enregistrement réussi')));
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      attendanceBisBis(),
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
                                        /*if (search == 'membre') {

                                        } else if (search == 'guest') {

                                        } else if (search == 'vide') {
                                          await writeGuestStorage(
                                            NewPersonName,
                                            NewPersonfirstName,
                                            NewPersonNumber,
                                            NewPersonNameWhoInvite,
                                            NewPersonGendle,
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  attendanceBis(),
                                            ),
                                          );
                                        }*/
                                        print(search);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: const Text('Valider'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
