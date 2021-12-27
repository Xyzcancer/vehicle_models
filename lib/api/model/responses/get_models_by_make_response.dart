import 'dart:convert';

import 'package:test_project/api/model/responses/response_keys.dart';

import '../model.dart';

class GetModelsByMakeResponse {
  List<Model> models = [];
  GetModelsByMakeResponse.fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    if (map[ResponseKeys.results] != null) {
      List<Map<String, dynamic>> modelsArray =
          List.castFrom(map[ResponseKeys.results]);
      for (var model in modelsArray) {
        models.add(Model.fromMap(model));
      }
    }
  }
}
