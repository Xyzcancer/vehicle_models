import 'dart:convert';

import 'package:test_project/api/model/make.dart';
import 'package:test_project/api/model/responses/response_keys.dart';

class GetMakesByManufacturerResponse {
  List<Make> makes = [];

  GetMakesByManufacturerResponse.fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    if (map[ResponseKeys.results] != null) {
      List<Map<String, dynamic>> makesArray =
          List.castFrom(map[ResponseKeys.results]);
      for (var make in makesArray) {
        makes.add(Make.fromMap(make));
      }
    }
  }
}
