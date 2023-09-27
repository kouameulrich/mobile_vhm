import 'dart:convert';

import 'package:appfres/_api/dioClient.dart';
import 'package:appfres/_api/endpoints.dart';
import 'package:appfres/models/agent.dart';
import 'package:appfres/models/dto/recensement.dto.dart';
import 'package:appfres/models/recensement.dart';

class ApiService {
  final DioClient _dioClient;
  ApiService(this._dioClient);

  Future<Agent> getUserConnected(String username) async{
    String agentEndpoint = '/agents/$username/slim/byusername';
    final  response = await _dioClient.get(agentEndpoint);
    return  Agent.fromJson(response.data);
  }

  Future<void> sendRecensement(List<Recensement> recensements) async{
    final resensementJson = convertRecencementToRecensementDto(recensements).map((e) => e.toJson()).toList();
    print(json.encode(resensementJson));
    await _dioClient.post(Endpoints.recensements, data: json.encode(resensementJson));
  }

  List<RecensementDto> convertRecencementToRecensementDto( List<Recensement> recensements){
    List<RecensementDto> recensementDto = [];
    for (var r in recensements) {
      RecensementDto r1 = RecensementDto(
        nomClient: r.nomClient,
        prenomClient: r.prenomClient,
        telephoneClient: r.telephoneClient,
        dateRecensement: r.dateRecensement!.substring(0,10),
        matriculeAgent: r.matriculeAgent,
        sexeClient: r.sexeClient == 'Feminin' ? 'F' : 'M',
        montantClient: r.montantClient,
      );
      recensementDto.add(r1);
    }
    return recensementDto;
  }
}