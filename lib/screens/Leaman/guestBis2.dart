// ignore_for_file: body_might_complete_normally_nullable, use_build_context_synchronously, prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_whm_2/models/guestPost2.dart';
import 'package:mobile_whm_2/models/memberBis2.dart';
import 'package:mobile_whm_2/screens/Leaman/attendanceBisBis2.dart';

class guestBis2 extends StatefulWidget {
  const guestBis2({Key? key}) : super(key: key);

  @override
  State<guestBis2> createState() => _guestBis2State();
}

class _guestBis2State extends State<guestBis2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String dropdownValue = '';
  String dropdownValueLeamanInvited = '';
  String dropdownValue3 = '';
  String dropdownValueChurch = '';
  String query = '';
  final controllerCity = TextEditingController();
  // RadioButtonController leamanInvitedController;
  late String leamanLastName,
      leamanFirstName,
      leamanPhone,
      leamanStatus,
      leamanChurch,
      leamanChurchInfo,
      leamanInvited;
  late Object leamanGender;
  // late Object leamanStatus;
  late String leamanDateOfEntry;
  late int churchId;
  late int leamanTypeId;

  //Object? NewPersonGendle, NewPersonResigence;

  List<GuestPost2> newPersonStorage = [];

  var searchResponse = '';
  var resultSearch;
  var searchGuest;

  Future searchGest(phone) async {
    //create storage
    final storage = new FlutterSecureStorage();

    // check if storage leaman exist
    final checkStorageleaman = await storage.containsKey(key: 'leamanStorage');
    print("checkStorageleaman: $checkStorageleaman");

    if (checkStorageleaman == true) {
      final data = await storage.read(key: 'leamanStorage');
      final List leamans = jsonDecode(data!);
      print("leamans: $leamans");
      final leamanList =
          leamans.map((json) => MemberBis2.fromJson(json)).toList();
      final resultSearch =
          leamanList.where((x) => x.memberPhone == phone.toString()).toList();
      if (resultSearch.isNotEmpty) {
        return "leaman";
      }

      final checkStorageGuest =
          await storage.containsKey(key: 'mewPersonStorage');
      print("checkStorageGuest: $checkStorageGuest");
      if (checkStorageGuest == true) {
        final dataGuest = await storage.read(key: 'mewPersonStorage');
        final guests = jsonDecode(dataGuest!);
        print("guests TRUE: $guests");
        final leamanList =
            guests.map((json) => GuestPost2.fromJson(json)).toList();
        final searchGuest =
            leamanList.where((x) => x.leamanPhone == phone).toList();
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
        final leamanList =
            guests.map((json) => GuestPost2.fromJson(json)).toList();
        final searchGuest =
            leamanList.where((x) => x.leamanPhone == phone).toList();
        if (searchGuest.isNotEmpty) {
          return "guest";
        }
        return "vide";
      }
      return "vide";
    }
  }

  Future writeGuestStorage(
    String leamanLastName,
    String leamanFirstName,
    String leamanPhone,
    String leamanInvited,
    Object leamanGender,
    Object leamanStatus,
    Object leamanChurch,
    String leamanChurchInfo,
  ) async {
    final leamanDateOfEntry = DateTime.now();
    final leamanGenderString = leamanGender.toString();
    final leamanStatusString = leamanStatus.toString();
    final leamanChurchString = leamanChurch.toString();

    GuestPost2 newPerson = GuestPost2(
      leamanLastName: leamanLastName,
      leamanFirstName: leamanFirstName,
      leamanPhone: leamanPhone,
      leamanDateOfEntry: leamanDateOfEntry.toString(),
      leamanGender: leamanGenderString,
      leamanStatus: leamanStatusString,
      leamanChurch: leamanChurchString,
      leamanChurchInfo: leamanChurchInfo,
      leamanInvited: leamanInvited,
    );

    print('memberLastName: ${newPerson.leamanLastName}');
    print('memberFirstName: ${newPerson.leamanFirstName}');
    print('memberPhone: ${newPerson.leamanPhone}');
    print('memberDateOfEntry: ${newPerson.leamanDateOfEntry}');
    print('memberInvitedBy: ${newPerson.leamanInvited}');
    print('memberGender: ${newPerson.leamanGender}');
    print('memberGender: ${newPerson.leamanStatus}');
    print('churchId: ${newPerson.leamanChurch}');
    print('memberTypeId: ${newPerson.leamanChurchInfo}');

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

      //Read data storage leaman
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
        title: Text('Enregistrement Face à Face'),
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
                            leamanLastName = value!;
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
                      leamanFirstName = value!;
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
                      leamanPhone = value!;
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
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: 'Sélectionnez votre Status',
                      labelText: 'Votre Status',
                    ),
                    value: dropdownValue3,
                    items: <String>[
                      '',
                      '1. Épouse d\'\honneur (mariée légalement)',
                      '2. Appelée à Régner (non mariée)',
                      '3. Demoiselle d\'\honneur (14 à 21 ans)',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue3 = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value == '') {
                        return "Sélectionnez un status";
                      }
                      //return null;
                    },
                    onSaved: (value) {
                      leamanStatus = value.toString();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: 'Choisissez une option',
                      labelText: 'Quelle est votre assemblée ?',
                    ),
                    value: dropdownValueChurch,
                    items: <String>[
                      '',
                      'Centre de la foi',
                      'Assemblée soeur VH',
                      'Autre',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValueChurch = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value == '') {
                        return "Choisissez une option";
                      }
                      //return null;
                    },
                    onSaved: (value) {
                      leamanChurch = value.toString();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    onSaved: (value) {
                      leamanChurchInfo = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Saisissez le nom de l\'\assemblée',
                      labelText: 'Assemblée',
                    ),
                  ),
                ),
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
                      leamanGender = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: 'Êtes-vous un invité ?',
                      labelText: 'Invité',
                    ),
                    value: dropdownValueLeamanInvited,
                    items: <String>['', 'Oui', 'Non']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValueLeamanInvited = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value == '') {
                        return "Sélectionnez une option";
                      }
                      //return null;
                    },
                    onSaved: (value) {
                      leamanInvited = value.toString();
                    },
                  ),
                ),
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
                                  title: Text('Alerte'),
                                  content: Text(
                                      'Voulez-vous valider votre enregistrement ?'),
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
                                            await searchGest(leamanPhone);

                                        switch (search) {
                                          case "leaman":
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
                                                leamanLastName,
                                                leamanFirstName,
                                                leamanPhone,
                                                leamanInvited,
                                                leamanGender,
                                                leamanStatus,
                                                leamanChurch,
                                                leamanChurchInfo,
                                              );
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(SnackBar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    content: Text(
                                                        'Enregistrement réussi')));
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      guestBis2(),
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
