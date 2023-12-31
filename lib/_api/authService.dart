
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_whm_2/_api/tokenStorageService.dart';

class AuthService{
  final TokenStorageService _tokenStorageService;
  Dio dio=Dio();

  AuthService(this._tokenStorageService);
  Future<int?> authenticateUser(String username, String password) async {
    _tokenStorageService.saveAgentUsername(username);

    String url = 'https://localhost:8080/auth/realms/protocol/openid-connect/token';
     final Response response= await dio.post(url,
          data:{
            "username": username,
            "password": password,
          },
        options: Options(contentType: Headers.formUrlEncodedContentType,
                          responseType: ResponseType.json)
      );
     if(response.statusCode == 200){
        print(json.encode(response.data));
       _tokenStorageService.saveToken(json.encode(response.data));
       print('--------------access-------------------');
       print(await _tokenStorageService.retrieveAccessToken());
       print('-----------refresh----------------------');
       print( await _tokenStorageService.retrieveRefreshToken());
       return response.statusCode;
     } else {
       debugPrint(
           "An Error Occurred during loggin in. Status code: ${response.statusCode} , body: ${response.data}");
       return response.statusCode;
     }
  }
}