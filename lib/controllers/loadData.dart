import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_whm_2/models/memberBis.dart';

class LoadMemberData {
  var members;

  static Future getMemberData() async {
    //Get data by api url
    final url =
        Uri.parse('https://vasesdhonneurcdf.com/vhm/api/getAllMember/2');
    //url = Uri.parse('https://10.0.2.2:7002/api/Member/getAll?churchId=1');
    //Uri.parse('https://vasesdhonneurcdf.com/vhm/api/getAllMember/2');
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

  static Future getMemberDataBis() async {
    //Get data by api url
    final url = Uri.parse(
        'https://backendvhm.azurewebsites.net/api/Member/getAll?churchId=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List memberData;
      memberData = jsonData.map((json) => MemberBis.fromJson(json)).toList();
      final dataMemberStorage = json.encode(memberData);
      //final dataMemberStorage = json.encode(jsonData);

      return dataMemberStorage;
    } else {
      return '';
    }
  }
}
