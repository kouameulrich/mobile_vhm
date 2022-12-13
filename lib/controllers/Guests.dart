import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/member.dart';
import 'package:http/http.dart' as http;

class Guests {
  static Future<List<Member>> search(String query) async {
    // Create storage
    final storage = new FlutterSecureStorage();

    //Read data storage member
    final readDataStore = await storage.read(key: 'memberStorage');

    final List members = jsonDecode(readDataStore!);

    //print(members.length);

    return members.map((json) => Member.fromJson(json)).where((member) {
      final fullNameLower = member.fullName.toLowerCase();
      final telLower = member.tel.toLowerCase();
      final searchLower = query.toLowerCase();

      return fullNameLower.contains(searchLower) ||
          telLower.contains(searchLower);
    }).toList();
  }
}
