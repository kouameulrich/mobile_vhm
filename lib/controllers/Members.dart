import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_whm_2/models/memberBis.dart';
import '../models/member.dart';
import 'package:http/http.dart' as http;

class Members {
  static Future getMembers() async {
    // Create storage
    final storage = new FlutterSecureStorage();

    //Get data by api url
    final url =
        Uri.parse('https://vasesdhonneurcdf.com/vhm/api/getAllMember/2');
    //Uri.parse('http://vasesdhonneurcdf.com/vhm/api/getAllMember');
    //Uri.parse('https://backendvhm.azurewebsites.net/api/ChurchTypes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      final dataMemberStorage = json.encode(jsonData);

      return '$dataMemberStorage';
    } else {
      return '';
    }
  }

  static readMembers() async {
    // Create storage
    final storage = new FlutterSecureStorage();

    //Read data storage member
    final readDataStore = await storage.read(key: 'memberStorage');

    final List members = jsonDecode(readDataStore!);

    return members.map((json) => Member.fromJson(json)).toList();
  }

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

  static Future<List<MemberBis>> searchBis(String query) async {
    // Create storage
    final storage = new FlutterSecureStorage();

    //Read data storage member
    final readDataStore = await storage.read(key: 'memberStorage');

    final List members = jsonDecode(readDataStore!);

    //print(members.length);

    return members.map((json) => MemberBis.fromJson(json)).where((member) {
      final fullNameLower = member.memberFullName.toLowerCase();
      final telLower = member.memberPhone.toLowerCase();
      final searchLower = query.toLowerCase();

      return fullNameLower.contains(searchLower) ||
          telLower.contains(searchLower);
    }).toList();
  }
}
