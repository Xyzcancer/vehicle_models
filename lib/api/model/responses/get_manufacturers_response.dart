import 'dart:convert';

import 'package:test_project/api/model/manufacturer.dart';
import 'package:test_project/api/model/responses/response_keys.dart';

class GetManufacturersResponse {
  List<Manufacturer> manufacturers = [];

  GetManufacturersResponse.fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    if (map[ResponseKeys.results] != null) {
      List<Map<String, dynamic>> manufacturersArray =
          List.castFrom(map[ResponseKeys.results]);
      for (var manufacturer in manufacturersArray) {
        manufacturers.add(Manufacturer.fromMap(manufacturer));
      }
    }
  }
}
