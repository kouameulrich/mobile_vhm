import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_whm_2/models/guestPost.dart';

class SendData {
  static Future postPresence() async {
    // Create storage
    final storage = new FlutterSecureStorage();

    //Read data storage guest
    final readDataStore = await storage.read(key: 'presenceIdStorage');
    final List presenceIdStorage = jsonDecode(readDataStore!);
    print(presenceIdStorage.length);
    print(presenceIdStorage);
    /*final List<GuestPost> dataToList =
        newPersonStorage.map((json) => GuestPost.fromJson(json)).toList();*/

    for (int i = 0; i <= presenceIdStorage.length - 1; i++) {
      var eventMemberJoinDate = DateTime.now().toString();
      var churchId = 1;
      print(
          'print for: ${presenceIdStorage[i]} - ${eventMemberJoinDate} - ${churchId}');

      var url =
          Uri.parse('https://backendvhm.azurewebsites.net/api/EventMember/add');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "eventMemberJoinDate": eventMemberJoinDate,
          "eventId": null,
          "memberId": presenceIdStorage[i],
          "churchId": churchId
        }),
      );
      var sendResponse;
      if (response.statusCode == 200) {
        sendResponse = response.body;
        print('response.statusCode == ${response.statusCode}');
      } else {
        sendResponse = null;
        print('response.statusCode ==  ${response.statusCode}');
        print('response.statusCode ==  ${response.body}');
      }
      print(sendResponse);
    }
  }

  static Future postGuest() async {
    var sendResponse;
    var responseAlert;
    // Create storage
    final storage = new FlutterSecureStorage();

    //Read data storage guest
    final readDataStore = await storage.read(key: 'mewPersonStorage');

    if (readDataStore != null) {
      final List newPersonStorage = jsonDecode(readDataStore);
      print(newPersonStorage.length);

      final List<GuestPost> dataToList =
          newPersonStorage.map((json) => GuestPost.fromJson(json)).toList();
      print('List<GuestPost> dataToList: ${dataToList[0].memberLastName}');

      for (int i = 0; i <= dataToList.length - 1; i++) {
        var url =
            Uri.parse('https://backendvhm.azurewebsites.net/api/Member/add');
        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "memberLastName": dataToList[i].memberLastName,
            "memberFirstName": dataToList[i].memberFirstName,
            "memberPhone": dataToList[i].memberPhone,
            "memberDateOfEntry": dataToList[i].memberDateOfEntry,
            "memberInvitedBy": dataToList[i].memberInvitedBy,
            "memberGender": dataToList[i].memberGender,
            "churchId": dataToList[i].churchId,
            "memberTypeId": dataToList[i].memberTypeId
          }),
        );

        if (response.statusCode == 200) {
          sendResponse = response.body;
          if (sendResponse != '') {
            List dataId = [];
            final readAttendanceIdData =
                await storage.read(key: 'presenceIdStorage');
            if (readAttendanceIdData == null) {
              dataId.add(sendResponse);

              final dataIdEncoded = json.encode(dataId);
              await storage.write(
                  key: 'presenceIdStorage', value: dataIdEncoded);
              print('dataId.length == ${dataId.length}');
              print('dataId == ${dataId}');
            } else {
              final List decodeIdData = jsonDecode(readAttendanceIdData);
              decodeIdData.add(sendResponse);

              final dataIdEncoded = json.encode(decodeIdData);
              await storage.write(
                  key: 'presenceIdStorage', value: dataIdEncoded);
              print('presenceIdStore.length == ${decodeIdData.length}');
              print('presenceIdStore == ${decodeIdData}');
            }
          }
          print('response.statusCode == ${response.statusCode}');
        } else {
          responseAlert = 'error';
          print('response.statusCode ==  ${response.statusCode}');
          print('response.statusCode ==  ${response.body}');
          return responseAlert;
        }
        print(sendResponse);
      }
      //return sendResponse;
    }
    responseAlert = 'success';
    return responseAlert;
  }
}
