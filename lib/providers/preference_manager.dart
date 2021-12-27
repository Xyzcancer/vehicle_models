import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  final SharedPreferences preferences;

  PreferenceManager({required this.preferences});

  static const String _allManufacturerPagePrefixKey = 'ALL_MANUFACTURERS_PAGE_';
  static const String _allMakesForManufacturerIdPrefixKey =
      'ALL_MAKES_FOR_MANUFACTURERS_ID_';
  static const String _allModelsForMakeIdPrefixKey = 'ALL_MODELS_FOR_MAKE_ID_';

  String? fetchManufacturersResponse(int page) {
    return preferences.getString(_manufacturersKeyForPage(page));
  }

  Future saveManufacturersResponse(String response, int page) async {
    preferences.setString(_manufacturersKeyForPage(page), response);
  }

  String? fetchMakesForManufacturerResponse(int manufacturerId) {
    return preferences.getString(_makesKeyForManufacturerId(manufacturerId));
  }

  Future saveMakesForManufacturerResponse(
      String response, int manufacturerId) async {
    preferences.setString(_makesKeyForManufacturerId(manufacturerId), response);
  }

  String? fetchModelsForMakeIdResponse(int makeId) {
    return preferences.getString(_modelsKeyForMakeId(makeId));
  }

  Future saveModelsForMakeIdResponse(String response, int makeId) async {
    preferences.setString(_modelsKeyForMakeId(makeId), response);
  }

  //Key helpers

  String _manufacturersKeyForPage(int page) {
    return '$_allManufacturerPagePrefixKey$page';
  }

  String _makesKeyForManufacturerId(int manufacturerId) {
    return '$_allMakesForManufacturerIdPrefixKey$manufacturerId';
  }

  String _modelsKeyForMakeId(int makeId) {
    return '$_allModelsForMakeIdPrefixKey$makeId';
  }
}
