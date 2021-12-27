import 'package:flutter/material.dart';
import 'package:test_project/api/gateway_service.dart';
import 'package:test_project/api/model/make.dart';
import 'package:test_project/api/model/manufacturer.dart';
import 'package:test_project/api/model/model.dart';
import 'package:test_project/api/model/responses/get_makes_for_manufacturer_response.dart';
import 'package:test_project/api/model/responses/get_manufacturers_response.dart';
import 'package:test_project/api/model/responses/get_models_by_make_response.dart';
import 'package:test_project/providers/preference_manager.dart';

class ManufacturerDataProvider extends ChangeNotifier {
  final GatewayService gatewayService;
  final PreferenceManager preferenceManager;

  ManufacturerDataProvider(
      {required this.gatewayService, required this.preferenceManager});

  Future<List<Manufacturer>> getManufacturers(int page) async {
    var response = await gatewayService.getAllManufacturers(page);
    if (response != null) {
      preferenceManager.saveManufacturersResponse(response, page);
      return GetManufacturersResponse.fromJson(response).manufacturers;
    } else {
      var localCache = preferenceManager.fetchManufacturersResponse(page);
      if (localCache != null) {
        return GetManufacturersResponse.fromJson(localCache).manufacturers;
      } else {
        throw Exception(
            'failed to get all manufacturers response for page $page');
      }
    }
  }

  Future<List<Make>> getMakesForManufacturer(int manufacturerId) async {
    var response = await gatewayService.getMakesByManufacturer(manufacturerId);
    if (response != null) {
      preferenceManager.saveMakesForManufacturerResponse(
          response, manufacturerId);
      return GetMakesByManufacturerResponse.fromJson(response).makes;
    } else {
      var localCache =
          preferenceManager.fetchMakesForManufacturerResponse(manufacturerId);
      if (localCache != null) {
        return GetMakesByManufacturerResponse.fromJson(localCache).makes;
      } else {
        throw Exception(
            'failed to get all makes response for manufacturerId $manufacturerId');
      }
    }
  }

  Future<List<Model>> getModelsForMakeId(int makeId) async {
    var response = await gatewayService.getModelsByMakeId(makeId);
    if (response != null) {
      preferenceManager.saveModelsForMakeIdResponse(response, makeId);
      return GetModelsByMakeResponse.fromJson(response).models;
    } else {
      var localCache = preferenceManager.fetchModelsForMakeIdResponse(makeId);
      if (localCache != null) {
        return GetModelsByMakeResponse.fromJson(localCache).models;
      } else {
        throw Exception('failed to get all models response for makeId $makeId');
      }
    }
  }
}
