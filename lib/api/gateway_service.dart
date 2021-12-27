import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GatewayService {
  static final GatewayService _singleton = GatewayService._internal();

  factory GatewayService() {
    return _singleton;
  }

  GatewayService._internal();

  static const String _methodGetAllManufacturers =
      '/api/vehicles/GetAllManufacturers';
  static const String _methodGetMakesForManufacturer =
      '/api/vehicles/GetMakeForManufacturer/';
  static const String _methodGetModelsForMakeId =
      '/api/vehicles/GetModelsForMakeId/';

  static const String _format = 'json';

  final String _baseUrl = 'vpic.nhtsa.dot.gov'; //stage '95.217.112.73';
  final String _scheme = 'https';

  Uri _getUri({required String path, Map<String, dynamic>? params}) {
    return Uri(
      host: _baseUrl,
      scheme: _scheme,
      path: path,
      queryParameters: params,
    );
  }

  Future<String?> getAllManufacturers(int page) async {
    try {
      var response = await http.get(
        _getUri(path: _methodGetAllManufacturers, params: {
          'page': page.toString(),
          'format': _format,
        }),
      );
      debugPrint(response.body);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> getMakesByManufacturer(int manufacturerId) async {
    try {
      var response = await http.get(_getUri(
          path: _methodGetMakesForManufacturer + manufacturerId.toString(),
          params: {'format': _format}));
      debugPrint(response.body);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> getModelsByMakeId(int makeId) async {
    try {
      var response = await http.get(_getUri(
          path: _methodGetModelsForMakeId + makeId.toString(),
          params: {'format': _format}));
      debugPrint(response.body);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
