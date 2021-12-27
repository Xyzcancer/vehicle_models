import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:test_project/main.mocks.dart';
import 'package:test_project/providers/manufacturer_data_provider.dart';
import 'package:test_project/providers/preference_manager.dart';

void main() async {
  group('ManufacturerDataProvider unit tests', () {
    // no cache and no server response - exception
    // no cache and success server response - server response provided
    // has cache and has server response -  server response provided
    // has cache and no server response  - cache response provided
    var mockGateway = MockGatewayService();
    var mockPrefsManager = MockPreferenceManager();

    test('getManufacturer no cache and no server response - exception', () {
      when(mockPrefsManager.fetchManufacturersResponse(1))
          .thenAnswer((realInvocation) => null);
      when(mockGateway.getAllManufacturers(1))
          .thenAnswer((realInvocation) => throw Exception());
      var dataProvider = ManufacturerDataProvider(
          gatewayService: mockGateway, preferenceManager: mockPrefsManager);
      expect(() => dataProvider.getManufacturers(1), throwsA(isA<Exception>()));
    });

    test('getMakesForManufacturer no cache and no server response - exception',
        () {
      when(mockPrefsManager.fetchMakesForManufacturerResponse(1))
          .thenAnswer((realInvocation) => null);
      when(mockGateway.getMakesByManufacturer(1))
          .thenAnswer((realInvocation) => throw Exception());
      var dataProvider = ManufacturerDataProvider(
          gatewayService: mockGateway, preferenceManager: mockPrefsManager);
      expect(() => dataProvider.getMakesForManufacturer(1),
          throwsA(isA<Exception>()));
    });

    test('getModelsForMakeId no cache and no server response - exception', () {
      when(mockPrefsManager.fetchModelsForMakeIdResponse(1))
          .thenAnswer((realInvocation) => null);
      when(mockGateway.getModelsByMakeId(1))
          .thenAnswer((realInvocation) => throw Exception());
      var dataProvider = ManufacturerDataProvider(
          gatewayService: mockGateway, preferenceManager: mockPrefsManager);
      expect(
          () => dataProvider.getModelsForMakeId(1), throwsA(isA<Exception>()));
    });

    test('getManufacturers no cache and success server response - list loaded',
        () async {
      when(mockPrefsManager.fetchManufacturersResponse(1))
          .thenAnswer((realInvocation) => null);
      when(mockPrefsManager.saveManufacturersResponse(any, any))
          .thenAnswer((realInvocation) async => null);
      when(mockGateway.getAllManufacturers(1)).thenAnswer(
          (realInvocation) async =>
              File('lib/jsons/manufacturers_1.json').readAsStringSync());
      var dataProvider = ManufacturerDataProvider(
          gatewayService: mockGateway, preferenceManager: mockPrefsManager);

      var response = await dataProvider.getManufacturers(1);
      expect(response.isNotEmpty, true);
    });

    test(
        'getMakesForManufacturer no cache and success server response - server list provided',
        () async {
      when(mockPrefsManager.fetchMakesForManufacturerResponse(1028))
          .thenAnswer((realInvocation) => null);
      when(mockPrefsManager.saveMakesForManufacturerResponse(any, any))
          .thenAnswer((realInvocation) async => null);
      when(mockGateway.getMakesByManufacturer(1028)).thenAnswer(
          (realInvocation) async =>
              File('lib/jsons/makes_1085.json').readAsStringSync());
      var dataProvider = ManufacturerDataProvider(
          gatewayService: mockGateway, preferenceManager: mockPrefsManager);
      var response = await dataProvider.getMakesForManufacturer(1028);
      expect(response.isNotEmpty, true);
    });

    test(
        'getModelsForMakeId no cache and Success server response - server list provided',
        () async {
      when(mockPrefsManager.fetchModelsForMakeIdResponse(1))
          .thenAnswer((realInvocation) => null);
      when(mockPrefsManager.saveModelsForMakeIdResponse(any, any))
          .thenAnswer((realInvocation) async => null);
      when(mockGateway.getModelsByMakeId(1)).thenAnswer(
          (realInvocation) async =>
              File('lib/jsons/models_448.json').readAsStringSync());
      var dataProvider = ManufacturerDataProvider(
          gatewayService: mockGateway, preferenceManager: mockPrefsManager);
      var response = await dataProvider.getModelsForMakeId(1);
      expect(response.isNotEmpty, true);
    });

    test(
        'getManufacturers has cache and success server response - server list provided',
        () async {
      when(mockPrefsManager.fetchManufacturersResponse(1)).thenAnswer(
          (realInvocation) =>
              File('lib/jsons/manufacturers_2.json').readAsStringSync());
      when(mockPrefsManager.saveManufacturersResponse(any, any))
          .thenAnswer((realInvocation) async => null);
      when(mockGateway.getAllManufacturers(1)).thenAnswer(
          (realInvocation) async =>
              File('lib/jsons/manufacturers_1.json').readAsStringSync());
      var dataProvider = ManufacturerDataProvider(
          gatewayService: mockGateway, preferenceManager: mockPrefsManager);

      var response = await dataProvider.getManufacturers(1);
      expect(response.first.id, 955);
    });

    test(
        'getMakesForManufacturer has cache and Success Server Response - server list provided',
        () async {
      when(mockPrefsManager.fetchMakesForManufacturerResponse(1085)).thenAnswer(
          (realInvocation) =>
              File('lib/jsons/makes_1080.json').readAsStringSync());
      when(mockPrefsManager.saveMakesForManufacturerResponse(any, any))
          .thenAnswer((realInvocation) async => null);
      when(mockGateway.getMakesByManufacturer(1085)).thenAnswer(
          (realInvocation) async =>
              File('lib/jsons/makes_1085.json').readAsStringSync());
      var dataProvider = ManufacturerDataProvider(
          gatewayService: mockGateway, preferenceManager: mockPrefsManager);
      var response = await dataProvider.getMakesForManufacturer(1085);
      expect(response.first.name, 'TOYOTA');
    });

    test(
        'getModelsForMakeId no cache and Success server response - server list provided',
        () async {
      when(mockPrefsManager.fetchModelsForMakeIdResponse(448)).thenAnswer(
          (realInvocation) =>
              File('lib/jsons/models_527.json').readAsStringSync());
      when(mockPrefsManager.saveModelsForMakeIdResponse(any, any))
          .thenAnswer((realInvocation) async => null);
      when(mockGateway.getModelsByMakeId(448)).thenAnswer(
          (realInvocation) async =>
              File('lib/jsons/models_448.json').readAsStringSync());
      var dataProvider = ManufacturerDataProvider(
          gatewayService: mockGateway, preferenceManager: mockPrefsManager);
      var response = await dataProvider.getModelsForMakeId(448);
      expect(response.first.makeId, 448);
    });

    test(
        'getManufacturers has cache and no server response - cache list provided',
        () async {
      when(mockPrefsManager.fetchManufacturersResponse(1)).thenAnswer(
          (realInvocation) =>
              File('lib/jsons/manufacturers_2.json').readAsStringSync());
      when(mockPrefsManager.saveManufacturersResponse(any, any))
          .thenAnswer((realInvocation) async => null);
      when(mockGateway.getAllManufacturers(1))
          .thenAnswer((realInvocation) async => null);
      var dataProvider = ManufacturerDataProvider(
          gatewayService: mockGateway, preferenceManager: mockPrefsManager);

      var response = await dataProvider.getManufacturers(1);
      expect(response.first.id, 1080);
    });

    test(
        'getMakesForManufacturer has cache and Success Server Response - cache list provided',
        () async {
      when(mockPrefsManager.fetchMakesForManufacturerResponse(1085)).thenAnswer(
          (realInvocation) =>
              File('lib/jsons/makes_1080.json').readAsStringSync());
      when(mockPrefsManager.saveMakesForManufacturerResponse(any, any))
          .thenAnswer((realInvocation) async => null);
      when(mockGateway.getMakesByManufacturer(1085))
          .thenAnswer((realInvocation) async => null);
      var dataProvider = ManufacturerDataProvider(
          gatewayService: mockGateway, preferenceManager: mockPrefsManager);
      var response = await dataProvider.getMakesForManufacturer(1085);
      expect(response.first.name, 'GEELY');
    });

    test(
        'getModelsForMakeId no cache and Success server response - cache list provided',
        () async {
      when(mockPrefsManager.fetchModelsForMakeIdResponse(448)).thenAnswer(
          (realInvocation) =>
              File('lib/jsons/models_527.json').readAsStringSync());
      when(mockPrefsManager.saveModelsForMakeIdResponse(any, any))
          .thenAnswer((realInvocation) async => null);
      when(mockGateway.getModelsByMakeId(448))
          .thenAnswer((realInvocation) async => null);
      var dataProvider = ManufacturerDataProvider(
          gatewayService: mockGateway, preferenceManager: mockPrefsManager);
      var response = await dataProvider.getModelsForMakeId(448);
      expect(response.first.makeId, 527);
    });
  });

  group('PreferenceManager unit tests', () {
    test('Manufacturers. Save response and check if prefs called', () async {
      var mockSharedPrefs = MockSharedPreferences();
      when(mockSharedPrefs.setString('ALL_MANUFACTURERS_PAGE_1', any))
          .thenAnswer((realInvocation) async => true);
      var prefs = PreferenceManager(preferences: mockSharedPrefs);

      prefs.saveManufacturersResponse(
          File('lib/jsons/manufacturers_1.json').readAsStringSync(), 1);

      verify(mockSharedPrefs.setString('ALL_MANUFACTURERS_PAGE_1', any))
          .called(1);
    });

    test(
        'Manufacturers. Save different response by different key check if keys are correct',
        () async {
      var mockSharedPrefs = MockSharedPreferences();
      when(mockSharedPrefs.setString('ALL_MANUFACTURERS_PAGE_1', any))
          .thenAnswer((realInvocation) async => true);
      when(mockSharedPrefs.setString('ALL_MANUFACTURERS_PAGE_2', any))
          .thenAnswer((realInvocation) async => true);
      var prefs = PreferenceManager(preferences: mockSharedPrefs);
      prefs.saveManufacturersResponse(
          File('lib/jsons/manufacturers_1.json').readAsStringSync(), 1);
      prefs.saveManufacturersResponse(
          File('lib/jsons/manufacturers_2.json').readAsStringSync(), 2);

      verifyInOrder([
        mockSharedPrefs.setString('ALL_MANUFACTURERS_PAGE_1', any),
        mockSharedPrefs.setString('ALL_MANUFACTURERS_PAGE_2', any)
      ]);
    });

    test('Manufacturers. Check if getter called', () async {
      var mockSharedPrefs = MockSharedPreferences();
      when(mockSharedPrefs.getString('ALL_MANUFACTURERS_PAGE_1'))
          .thenReturn('response');

      var prefs = PreferenceManager(preferences: mockSharedPrefs);
      prefs.fetchManufacturersResponse(1);
      verify(mockSharedPrefs.getString('ALL_MANUFACTURERS_PAGE_1')).called(1);
    });

    test('Manufacturers. Check if getter uses right keys', () async {
      var mockSharedPrefs = MockSharedPreferences();
      when(mockSharedPrefs.getString('ALL_MANUFACTURERS_PAGE_1'))
          .thenReturn('response');
      when(mockSharedPrefs.getString('ALL_MANUFACTURERS_PAGE_2'))
          .thenReturn('response');
      when(mockSharedPrefs.getString('ALL_MANUFACTURERS_PAGE_3'))
          .thenReturn('response');

      var prefs = PreferenceManager(preferences: mockSharedPrefs);
      prefs.fetchManufacturersResponse(1);
      prefs.fetchManufacturersResponse(2);
      prefs.fetchManufacturersResponse(3);

      verifyInOrder([
        mockSharedPrefs.getString('ALL_MANUFACTURERS_PAGE_1'),
        mockSharedPrefs.getString('ALL_MANUFACTURERS_PAGE_2'),
        mockSharedPrefs.getString('ALL_MANUFACTURERS_PAGE_3')
      ]);
    });

    test('Makes. Save response and check if prefs called', () async {
      var mockSharedPrefs = MockSharedPreferences();
      when(mockSharedPrefs.setString('ALL_MAKES_FOR_MANUFACTURERS_ID_1', any))
          .thenAnswer((realInvocation) async => true);
      var prefs = PreferenceManager(preferences: mockSharedPrefs);

      prefs.saveMakesForManufacturerResponse(
          File('lib/jsons/manufacturers_1.json').readAsStringSync(), 1);

      verify(mockSharedPrefs.setString('ALL_MAKES_FOR_MANUFACTURERS_ID_1', any))
          .called(1);
    });

    test(
        'Makes. Save different response by different key check if keys are correct',
        () async {
      var mockSharedPrefs = MockSharedPreferences();
      when(mockSharedPrefs.setString('ALL_MAKES_FOR_MANUFACTURERS_ID_1', any))
          .thenAnswer((realInvocation) async => true);
      when(mockSharedPrefs.setString('ALL_MAKES_FOR_MANUFACTURERS_ID_2', any))
          .thenAnswer((realInvocation) async => true);
      var prefs = PreferenceManager(preferences: mockSharedPrefs);
      prefs.saveMakesForManufacturerResponse(
          File('lib/jsons/manufacturers_1.json').readAsStringSync(), 1);
      prefs.saveMakesForManufacturerResponse(
          File('lib/jsons/manufacturers_2.json').readAsStringSync(), 2);

      verifyInOrder([
        mockSharedPrefs.setString('ALL_MAKES_FOR_MANUFACTURERS_ID_1', any),
        mockSharedPrefs.setString('ALL_MAKES_FOR_MANUFACTURERS_ID_2', any)
      ]);
    });

    test('Makes. Check if getter called', () async {
      var mockSharedPrefs = MockSharedPreferences();
      when(mockSharedPrefs.getString('ALL_MAKES_FOR_MANUFACTURERS_ID_1'))
          .thenReturn('response');

      var prefs = PreferenceManager(preferences: mockSharedPrefs);
      prefs.fetchMakesForManufacturerResponse(1);
      verify(mockSharedPrefs.getString('ALL_MAKES_FOR_MANUFACTURERS_ID_1'))
          .called(1);
    });

    test('Makes. Check if getter uses right keys', () async {
      var mockSharedPrefs = MockSharedPreferences();
      when(mockSharedPrefs.getString('ALL_MAKES_FOR_MANUFACTURERS_ID_1'))
          .thenReturn('response');
      when(mockSharedPrefs.getString('ALL_MAKES_FOR_MANUFACTURERS_ID_2'))
          .thenReturn('response');
      when(mockSharedPrefs.getString('ALL_MAKES_FOR_MANUFACTURERS_ID_3'))
          .thenReturn('response');

      var prefs = PreferenceManager(preferences: mockSharedPrefs);
      prefs.fetchMakesForManufacturerResponse(1);
      prefs.fetchMakesForManufacturerResponse(2);
      prefs.fetchMakesForManufacturerResponse(3);

      verifyInOrder([
        mockSharedPrefs.getString('ALL_MAKES_FOR_MANUFACTURERS_ID_1'),
        mockSharedPrefs.getString('ALL_MAKES_FOR_MANUFACTURERS_ID_2'),
        mockSharedPrefs.getString('ALL_MAKES_FOR_MANUFACTURERS_ID_3')
      ]);
    });

    test('Models. Save response and check if prefs called', () async {
      var mockSharedPrefs = MockSharedPreferences();
      when(mockSharedPrefs.setString('ALL_MODELS_FOR_MAKE_ID_1', any))
          .thenAnswer((realInvocation) async => true);
      var prefs = PreferenceManager(preferences: mockSharedPrefs);

      prefs.saveModelsForMakeIdResponse(
          File('lib/jsons/manufacturers_1.json').readAsStringSync(), 1);

      verify(mockSharedPrefs.setString('ALL_MODELS_FOR_MAKE_ID_1', any))
          .called(1);
    });

    test(
        'Models. Save different response by different key check if keys are correct',
        () async {
      var mockSharedPrefs = MockSharedPreferences();
      when(mockSharedPrefs.setString('ALL_MODELS_FOR_MAKE_ID_1', any))
          .thenAnswer((realInvocation) async => true);
      when(mockSharedPrefs.setString('ALL_MODELS_FOR_MAKE_ID_2', any))
          .thenAnswer((realInvocation) async => true);
      var prefs = PreferenceManager(preferences: mockSharedPrefs);
      prefs.saveModelsForMakeIdResponse(
          File('lib/jsons/manufacturers_1.json').readAsStringSync(), 1);
      prefs.saveModelsForMakeIdResponse(
          File('lib/jsons/manufacturers_2.json').readAsStringSync(), 2);

      verifyInOrder([
        mockSharedPrefs.setString('ALL_MODELS_FOR_MAKE_ID_1', any),
        mockSharedPrefs.setString('ALL_MODELS_FOR_MAKE_ID_2', any)
      ]);
    });

    test('Models. Check if getter called', () async {
      var mockSharedPrefs = MockSharedPreferences();
      when(mockSharedPrefs.getString('ALL_MODELS_FOR_MAKE_ID_1'))
          .thenReturn('response');

      var prefs = PreferenceManager(preferences: mockSharedPrefs);
      prefs.fetchModelsForMakeIdResponse(1);
      verify(mockSharedPrefs.getString('ALL_MODELS_FOR_MAKE_ID_1')).called(1);
    });

    test('Models. Check if getter uses right keys', () async {
      var mockSharedPrefs = MockSharedPreferences();
      when(mockSharedPrefs.getString('ALL_MODELS_FOR_MAKE_ID_1'))
          .thenReturn('response');
      when(mockSharedPrefs.getString('ALL_MODELS_FOR_MAKE_ID_2'))
          .thenReturn('response');
      when(mockSharedPrefs.getString('ALL_MODELS_FOR_MAKE_ID_3'))
          .thenReturn('response');

      var prefs = PreferenceManager(preferences: mockSharedPrefs);
      prefs.fetchModelsForMakeIdResponse(1);
      prefs.fetchModelsForMakeIdResponse(2);
      prefs.fetchModelsForMakeIdResponse(3);

      verifyInOrder([
        mockSharedPrefs.getString('ALL_MODELS_FOR_MAKE_ID_1'),
        mockSharedPrefs.getString('ALL_MODELS_FOR_MAKE_ID_2'),
        mockSharedPrefs.getString('ALL_MODELS_FOR_MAKE_ID_3')
      ]);
    });
  });
}
