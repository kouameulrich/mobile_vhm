import 'dart:convert';
import 'package:mobile_whm_2/_api/dioClient.dart';
import 'package:mobile_whm_2/models/agent.dart';

class ApiService {
  final DioClient _dioClient;
  ApiService(this._dioClient);

  Future<Agent> getUserConnected(String username) async{
    String agentEndpoint = '/agents/$username/slim/byusername';
    final  response = await _dioClient.get(agentEndpoint);
    return  Agent.fromJson(response.data);
  }

}