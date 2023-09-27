import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_whm_2/models/guestPost.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_whm_2/models/guestPost2.dart';

class SendData {
  ///////// ----------- SYNCHRONISATION MEMBERS-------------
  static Future postPresence() async {
    // Create storage
    const storage = FlutterSecureStorage();

    //Read data storage guest
    final readDataStore = await storage.read(key: 'presenceIdStorage');
    final List presenceIdStorage = jsonDecode(readDataStore!);
    if (kDebugMode) {
      print(presenceIdStorage.length);
    }
    if (kDebugMode) {
      print(presenceIdStorage);
    }
    /*final List<GuestPost> dataToList =
        newPersonStorage.map((json) => GuestPost.fromJson(json)).toList();*/

    for (int i = 0; i <= presenceIdStorage.length - 1; i++) {
      var eventMemberJoinDate = DateTime.now().toString();
      var churchId = 1;
      if (kDebugMode) {
        print(
            'print for: ${presenceIdStorage[i]} - $eventMemberJoinDate - $churchId');
      }

      var url = Uri.parse(
          'https://backendvhm.azurewebsites.net/api/EventMember/mobileAdd');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "eventMemberJoinDate": null,
          "eventMemberJoinDay": null,
          "eventMemberJoinMonth": null,
          "eventMemberJoinYear": null,
          "eventId": null,
          "memberId": presenceIdStorage[i],
          "churchId": churchId
        }),
      );
      String? sendResponse;
      if (response.statusCode == 200) {
        sendResponse = response.body;
        if (kDebugMode) {
          print('response.statusCode == ${response.statusCode}');
        }
      } else {
        sendResponse = null;
        if (kDebugMode) {
          print('response.statusCode ==  ${response.statusCode}');
        }
        if (kDebugMode) {
          print('response.statusCode ==  ${response.body}');
        }
      }
      if (kDebugMode) {
        print(sendResponse);
      }
    }
  }

  static Future postPresenceLeaman() async {
    // Create storage
    const storage = FlutterSecureStorage();

    //Read data storage guest
    final readDataStore = await storage.read(key: 'presenceIdStorage');
    final List presenceIdStorage = jsonDecode(readDataStore!);
    if (kDebugMode) {
      print(presenceIdStorage.length);
    }
    if (kDebugMode) {
      print(presenceIdStorage);
    }
    /*final List<GuestPost> dataToList =
        newPersonStorage.map((json) => GuestPost.fromJson(json)).toList();*/

    for (int i = 0; i <= presenceIdStorage.length - 1; i++) {
      var eventMemberJoinDate = DateTime.now().toString();
      var churchId = 1;
      if (kDebugMode) {
        print(
            'print for: ${presenceIdStorage[i]} - $eventMemberJoinDate - $churchId');
      }

      var url = Uri.parse(
          'https://backendvhm.azurewebsites.net/api/EventMember/mobileAdd');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "leamanJoinDate": null,
          "leamanJoinDay": null,
          "leamanJoinMonth": null,
          "leamanJoinYear": null,
        }),
      );
      String? sendResponse;
      if (response.statusCode == 200) {
        sendResponse = response.body;
        if (kDebugMode) {
          print('response.statusCode == ${response.statusCode}');
        }
      } else {
        sendResponse = null;
        if (kDebugMode) {
          print('response.statusCode ==  ${response.statusCode}');
        }
        if (kDebugMode) {
          print('response.statusCode ==  ${response.body}');
        }
      }
      if (kDebugMode) {
        print(sendResponse);
      }
    }
  }

///////// ----------- SYNCHRONISATION NEW MEMBERS-------------
  static Future postGuest() async {
    String sendResponse;
    String responseAlert;
    // Create storage
    final storage = new FlutterSecureStorage();

    //Read data storage guest
    final readDataStore = await storage.read(key: 'mewPersonStorage');

    if (readDataStore != null) {
      final List newPersonStorage = jsonDecode(readDataStore);
      if (kDebugMode) {
        print(newPersonStorage.length);
      }

      final List<GuestPost> dataToList =
          newPersonStorage.map((json) => GuestPost.fromJson(json)).toList();
      if (kDebugMode) {
        print('List<GuestPost> dataToList: ${dataToList[0].memberLastName}');
      }

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

        if (kDebugMode) {
          print(response.statusCode);
        }

        if (response.statusCode == 200) {
          sendResponse = response.body;
          if (sendResponse != "") {
            // Add EventGuest
            var url = Uri.parse(
                'https://backendvhm.azurewebsites.net/api/EventGuest/AddEventGuestByMobile');
            final responseEventGuest = await http.post(
              url,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({
                "eventGuestJoinDate": null,
                "eventGuestJoinDay": null,
                "eventGuestJoinMonth": null,
                "eventGuestJoinYear": null,
                "eventId": null,
                "memberId": sendResponse,
                "churchId": dataToList[i].churchId
              }),
            );

            if (kDebugMode) {
              print(responseEventGuest.statusCode);
              print(responseEventGuest.body);
            }

            // storage memberId in local
            List dataId = [];
            final readAttendanceIdData =
                await storage.read(key: 'presenceIdStorage');
            if (readAttendanceIdData == null) {
              dataId.add(sendResponse);

              final dataIdEncoded = json.encode(dataId);
              await storage.write(
                  key: 'presenceIdStorage', value: dataIdEncoded);
              if (kDebugMode) {
                print('dataId.length == ${dataId.length}');
              }
              if (kDebugMode) {
                print('dataId == $dataId');
              }
            } else {
              final List decodeIdData = jsonDecode(readAttendanceIdData);
              decodeIdData.add(sendResponse);

              final dataIdEncoded = json.encode(decodeIdData);
              await storage.write(
                  key: 'presenceIdStorage', value: dataIdEncoded);
              if (kDebugMode) {
                print('presenceIdStore.length == ${decodeIdData.length}');
              }
              if (kDebugMode) {
                print('presenceIdStore == $decodeIdData');
              }
            }
          }
          if (kDebugMode) {
            print('response.statusCode == ${response.statusCode}');
          }
        } else {
          responseAlert = 'error';
          if (kDebugMode) {
            print('response.statusCode ==  ${response.statusCode}');
          }
          if (kDebugMode) {
            print('response.statusCode ==  ${response.body}');
          }
          return responseAlert;
        }
        if (kDebugMode) {
          print(sendResponse);
        }
      }
      //return sendResponse;
    }
    responseAlert = 'success';
    return responseAlert;
  }

// LEAMAN SEND DATA
  static Future postGuestLeaman() async {
    String sendResponse;
    String responseAlert;
    // Create storage
    final storage = new FlutterSecureStorage();

    //Read data storage guest
    final readDataStore = await storage.read(key: 'mewPersonStorage');

    if (readDataStore != null) {
      final List newPersonStorage = jsonDecode(readDataStore);
      if (kDebugMode) {
        print(newPersonStorage.length);
      }

      final List<GuestPost2> dataToList =
          newPersonStorage.map((json) => GuestPost2.fromJson(json)).toList();
      if (kDebugMode) {
        print('List<GuestPost2> dataToList: ${dataToList[0].leamanLastName}');
      }

      for (int i = 0; i <= dataToList.length - 1; i++) {
        // print(dataToList[i].leamanFirstName);
        var url =
            Uri.parse('https://backendvhm.azurewebsites.net/api/Leaman/add');
        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "leamanLastName": dataToList[i].leamanLastName,
            "leamanFirstName": dataToList[i].leamanFirstName,
            "leamanPhone": dataToList[i].leamanPhone,
            "leamanDateOfEntry": dataToList[i].leamanDateOfEntry,
            "leamanInvited": dataToList[i].leamanInvited,
            "leamanGender": dataToList[i].leamanGender,
            "leamanChurch": dataToList[i].leamanChurch,
            "leamanChurchInfo": dataToList[i].leamanChurchInfo
          }),
        );

        if (kDebugMode) {
          print(response.statusCode);
        }

        if (response.statusCode == 200) {
          sendResponse = response.body;
          print(sendResponse);
        } else {
          responseAlert = 'error';
          if (kDebugMode) {
            print('response.statusCode ==  ${response.statusCode}');
          }
          if (kDebugMode) {
            print('response.statusCode ==  ${response.body}');
          }
          return responseAlert;
        }
        if (kDebugMode) {
          print(sendResponse);
        }
      }
      //return sendResponse;
    }
    responseAlert = 'success';
    return responseAlert;
  }
}
