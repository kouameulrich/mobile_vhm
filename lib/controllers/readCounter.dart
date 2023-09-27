import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_whm_2/models/guest.dart';
import 'package:mobile_whm_2/models/guestPost.dart';
import 'package:mobile_whm_2/models/guestPost2.dart';
import 'package:mobile_whm_2/models/memberBis.dart';

import '../models/member.dart';

class ReadCounter {
  static Future<String?> NewPersonStorage() async {
    // Create storage
    final storage = new FlutterSecureStorage();

    //Read data storage member
    final readDataStore = await storage.read(key: 'mewPersonStorage');

    if (readDataStore == null) {
      final counter = '0';
      return counter;
    } else {
      final List dataDecoded = jsonDecode(readDataStore);
      final List<Guest> dataToList =
          dataDecoded.map((json) => Guest.fromJson(json)).toList();

      final counter = dataToList.length.toString();

      return counter;
    }
  }

  static Future<String?> NewPersonStorageBis() async {
    // Create storage
    final storage = new FlutterSecureStorage();

    //Read data storage member
    final readDataStore = await storage.read(key: 'mewPersonStorage');

    if (readDataStore == null) {
      final counter = '0';
      return counter;
    } else {
      final List dataDecoded = jsonDecode(readDataStore);
      final List<GuestPost> dataToList =
          dataDecoded.map((json) => GuestPost.fromJson(json)).toList();

      final counter = dataToList.length.toString();

      return counter;
    }
  }

  static Future<String?> NewPersonStorageBis2() async {
    // Create storage
    final storage = new FlutterSecureStorage();

    //Read data storage member
    final readDataStore = await storage.read(key: 'mewPersonStorage');

    if (readDataStore == null) {
      final counter = '0';
      return counter;
    } else {
      final List dataDecoded = jsonDecode(readDataStore);
      final List<GuestPost2> dataToList =
          dataDecoded.map((json) => GuestPost2.fromJson(json)).toList();

      final counter = dataToList.length.toString();

      return counter;
    }
  }

  static Future<String?> PresenceStorage() async {
    // Create storage
    final storage = new FlutterSecureStorage();

    //Read data storage member
    final readDataStore = await storage.read(key: 'presenceStorage');

    if (readDataStore == null) {
      final counter = '0';
      return counter;
    } else {
      final List dataDecoded = jsonDecode(readDataStore);
      final List<Member> dataToList =
          dataDecoded.map((json) => Member.fromJson(json)).toList();

      final counter = dataToList.length.toString();

      return counter;
    }
  }

  static Future<String?> PresenceStorageBis() async {
    // Create storage
    final storage = new FlutterSecureStorage();

    //Read data storage member
    final readDataStore = await storage.read(key: 'presenceStorage');

    if (readDataStore == null) {
      final counter = '0';
      return counter;
    } else {
      final List dataDecoded = jsonDecode(readDataStore);
      final List<MemberBis> dataToList =
          dataDecoded.map((json) => MemberBis.fromJson(json)).toList();

      final counter = dataToList.length.toString();

      return counter;
    }
  }
}
