import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:test_project/api/model/make.dart';
import 'package:test_project/api/model/manufacturer.dart';
import 'package:test_project/blocs/manufacturer_models_bloc.dart';
import 'package:test_project/blocs/manufacturers_bloc.dart';
import 'package:test_project/main.mocks.dart';

void main() {
  group('ManufacturerListBloc tests', () {
    var mockManufacturersProvider = MockManufacturerDataProvider();
    blocTest('Test Multiple request page incremented once',
        setUp: () {
          when(mockManufacturersProvider.getManufacturers(1)).thenAnswer(
              (realInvocation) =>
                  Future.delayed(const Duration(seconds: 1), () {
                    return [];
                  }));
        },
        build: () => ManufacturersBloc(
            manufacturerDataProvider: mockManufacturersProvider),
        act: (ManufacturersBloc bloc) {
          bloc.add(ManufacturersBlocEventFetchByPage());
          bloc.add(ManufacturersBlocEventFetchByPage());
        },
        wait: const Duration(seconds: 1),
        expect: () => [isA<ManufacturersBlocStateFetched>()]);

    blocTest('Test Exception happened',
        setUp: () {
          when(mockManufacturersProvider.getManufacturers(1))
              .thenAnswer((realInvocation) => throw Exception());
        },
        build: () => ManufacturersBloc(
            manufacturerDataProvider: mockManufacturersProvider),
        act: (ManufacturersBloc bloc) {
          bloc.add(ManufacturersBlocEventFetchByPage());
        },
        expect: () => [isA<ManufacturersBlocStateFetchFailed>()]);

    blocTest('Test page is incrementing',
        setUp: () {
          when(mockManufacturersProvider.getManufacturers(1))
              .thenAnswer((realInvocation) async => [Manufacturer()]);
          when(mockManufacturersProvider.getManufacturers(2))
              .thenAnswer((realInvocation) async => [Manufacturer()]);
        },
        build: () => ManufacturersBloc(
            manufacturerDataProvider: mockManufacturersProvider),
        act: (ManufacturersBloc bloc) {
          bloc.add(ManufacturersBlocEventFetchByPage());
          bloc.add(ManufacturersBlocEventFetchByPage());
        },
        verify: (ManufacturersBloc bloc) {
          expect(bloc.page, 2);
        },
        expect: () => [
              isA<ManufacturersBlocStateFetched>(),
              isA<ManufacturersBlocStateFetched>()
            ]);
  });

  group('ManufacturerModelsBloc tests', () {
    var mockManufacturersProvider = MockManufacturerDataProvider();

    blocTest('Test Request makes for right manufacturer id',
        setUp: () {
          when(mockManufacturersProvider.getMakesForManufacturer(1085))
              .thenAnswer((realInvocation) async => []);
          when(mockManufacturersProvider.getModelsForMakeId(any))
              .thenAnswer((realInvocation) async => []);
        },
        build: () => ManufacturerModelsBloc(
            manufacturerDataProvider: mockManufacturersProvider,
            manufacturerId: 1085),
        act: (ManufacturerModelsBloc bloc) {
          bloc.add(ManufacturerModelsEventFetchModels());
        },
        verify: (ManufacturerModelsBloc bloc) {
          verify(mockManufacturersProvider.getMakesForManufacturer(1085))
              .called(1);
        },
        expect: () => [isA<ManufacturerModelsStateFetched>()]);

    blocTest('Test request for makes throws Exception ',
        setUp: () {
          when(mockManufacturersProvider.getMakesForManufacturer(any))
              .thenAnswer((realInvocation) => throw Exception());
        },
        build: () => ManufacturerModelsBloc(
            manufacturerDataProvider: mockManufacturersProvider,
            manufacturerId: 1085),
        act: (ManufacturerModelsBloc bloc) {
          bloc.add(ManufacturerModelsEventFetchModels());
        },
        expect: () => [isA<ManufacturerModelsStateFetchFailed>()]);

    blocTest('Test request for models throws Exception ',
        setUp: () {
          when(mockManufacturersProvider.getMakesForManufacturer(any))
              .thenAnswer((realInvocation) async => [
                    Make()..id = 448,
                    Make()..id = 515,
                  ]);
          when(mockManufacturersProvider.getModelsForMakeId(any))
              .thenAnswer((realInvocation) => throw Exception());
        },
        build: () => ManufacturerModelsBloc(
            manufacturerDataProvider: mockManufacturersProvider,
            manufacturerId: 1085),
        act: (ManufacturerModelsBloc bloc) {
          bloc.add(ManufacturerModelsEventFetchModels());
        },
        expect: () => [isA<ManufacturerModelsStateFetchFailed>()]);

    blocTest('Test request for all makes order',
        setUp: () {
          when(mockManufacturersProvider.getMakesForManufacturer(any))
              .thenAnswer((realInvocation) async => [
                    Make()..id = 448,
                    Make()..id = 515,
                  ]);

          when(mockManufacturersProvider.getModelsForMakeId(448))
              .thenAnswer((realInvocation) async => []);
          when(mockManufacturersProvider.getModelsForMakeId(515))
              .thenAnswer((realInvocation) async => []);
        },
        build: () => ManufacturerModelsBloc(
            manufacturerDataProvider: mockManufacturersProvider,
            manufacturerId: 1085),
        act: (ManufacturerModelsBloc bloc) {
          bloc.add(ManufacturerModelsEventFetchModels());
        },
        verify: (ManufacturerModelsBloc bloc) {
          verifyInOrder([
            mockManufacturersProvider.getModelsForMakeId(448),
            mockManufacturersProvider.getModelsForMakeId(515),
          ]);
        },
        expect: () => [isA<ManufacturerModelsStateFetched>()]);
  });
}
