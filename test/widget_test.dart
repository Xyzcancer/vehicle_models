// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test_project/api/model/make.dart';
import 'package:test_project/api/model/manufacturer.dart';
import 'package:test_project/api/model/model.dart';
import 'package:test_project/blocs/manufacturer_models_bloc.dart';
import 'package:test_project/blocs/manufacturers_bloc.dart';

import 'package:test_project/main.mocks.dart';
import 'package:test_project/screens/manufacturers_list_screen.dart';
import 'package:test_project/screens/models_list_screen.dart';

void main() {
  group('Manufacturers List Screen Tests', () {
    // success response - list is displaying
    // success response scroll at the end - loading for next page and list updated
    // success response scroll at the end - there is no more page
    // failed to get response with empty list - screen state error try again
    // failed to get response with empty list then tap try again with success response - list displaying
    // failed to get response with not empty list - last item in list with try again
    var mockProvider = MockManufacturerDataProvider();
    testWidgets('Success response - list is displaying',
        (WidgetTester tester) async {
      when(mockProvider.getManufacturers(any))
          .thenAnswer((realInvocation) async => [
                Manufacturer()
                  ..id = 1
                  ..name = 'Tesla',
                Manufacturer()
                  ..id = 2
                  ..name = 'BMW',
                Manufacturer()
                  ..id = 3
                  ..name = 'Audi',
              ]);

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => ManufacturersBloc(
            manufacturerDataProvider: mockProvider,
          )..add(ManufacturersBlocEventFetchByPage()),
          child: const ManufacturersListScreen(),
        ),
      ));

      await tester.pumpAndSettle();
      expect(find.text('Tesla'), findsWidgets);
      expect(find.text('BMW'), findsWidgets);
      expect(find.text('Audi'), findsWidgets);
    });

    testWidgets(
        'Success response scroll at the end - loading for next page and list updated',
        (WidgetTester tester) async {
      when(mockProvider.getManufacturers(1))
          .thenAnswer((realInvocation) async => [
                Manufacturer()
                  ..id = 1
                  ..name = 'Tesla',
                Manufacturer()
                  ..id = 2
                  ..name = 'BMW',
                Manufacturer()
                  ..id = 3
                  ..name = 'Audi',
              ]);
      when(mockProvider.getManufacturers(2))
          .thenAnswer((realInvocation) async => [
                Manufacturer()
                  ..id = 1
                  ..name = 'Mercedes',
                Manufacturer()
                  ..id = 2
                  ..name = 'Mazda',
                Manufacturer()
                  ..id = 3
                  ..name = 'Bentley',
                Manufacturer()
                  ..id = 1
                  ..name = 'Mercedes',
                Manufacturer()
                  ..id = 2
                  ..name = 'Mazda',
                Manufacturer()
                  ..id = 3
                  ..name = 'Bentley',
                Manufacturer()
                  ..id = 1
                  ..name = 'Mercedes',
                Manufacturer()
                  ..id = 2
                  ..name = 'Mazda',
                Manufacturer()
                  ..id = 3
                  ..name = 'Bentley',
                Manufacturer()
                  ..id = 1
                  ..name = 'Mercedes',
                Manufacturer()
                  ..id = 2
                  ..name = 'Mazda',
                Manufacturer()
                  ..id = 3
                  ..name = 'Bentley',
                Manufacturer()
                  ..id = 1
                  ..name = 'Mercedes',
                Manufacturer()
                  ..id = 2
                  ..name = 'Mazda',
                Manufacturer()
                  ..id = 3
                  ..name = 'Bentley',
                Manufacturer()
                  ..id = 1
                  ..name = 'Mercedes',
                Manufacturer()
                  ..id = 2
                  ..name = 'Mazda',
                Manufacturer()
                  ..id = 3
                  ..name = 'Bentley',
              ]);

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => ManufacturersBloc(
            manufacturerDataProvider: mockProvider,
          )..add(ManufacturersBlocEventFetchByPage()),
          child: const ManufacturersListScreen(),
        ),
      ));

      await tester.pumpAndSettle();
      expect(find.text('Mercedes'), findsWidgets);
      expect(find.text('Mazda'), findsWidgets);
      expect(find.text('Bentley'), findsWidgets);
    });

    testWidgets('Success response scroll at the end - there is no more page',
        (WidgetTester tester) async {
      when(mockProvider.getManufacturers(1))
          .thenAnswer((realInvocation) async => [
                Manufacturer()
                  ..id = 1
                  ..name = 'Tesla',
                Manufacturer()
                  ..id = 2
                  ..name = 'BMW',
                Manufacturer()
                  ..id = 3
                  ..name = 'Audi',
              ]);
      when(mockProvider.getManufacturers(2))
          .thenAnswer((realInvocation) async => []);

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => ManufacturersBloc(
            manufacturerDataProvider: mockProvider,
          )..add(ManufacturersBlocEventFetchByPage()),
          child: const ManufacturersListScreen(),
        ),
      ));

      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
        'Failed to get response with empty list - screen state error try again',
        (WidgetTester tester) async {
      when(mockProvider.getManufacturers(any))
          .thenAnswer((realInvocation) async => throw Exception());

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => ManufacturersBloc(
            manufacturerDataProvider: mockProvider,
          )..add(ManufacturersBlocEventFetchByPage()),
          child: const ManufacturersListScreen(),
        ),
      ));

      await tester.pumpAndSettle();
      expect(find.text('Failed to get list of manufacturers'), findsOneWidget);
    });

    testWidgets(
        'Failed to get response with empty list then tap try again with success response - list is displaying',
        (WidgetTester tester) async {
      when(mockProvider.getManufacturers(any))
          .thenAnswer((realInvocation) async => throw Exception());

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => ManufacturersBloc(
            manufacturerDataProvider: mockProvider,
          )..add(ManufacturersBlocEventFetchByPage()),
          child: const ManufacturersListScreen(),
        ),
      ));

      await tester.pumpAndSettle();
      when(mockProvider.getManufacturers(1))
          .thenAnswer((realInvocation) async => [
                Manufacturer()
                  ..id = 1
                  ..name = 'Tesla',
                Manufacturer()
                  ..id = 2
                  ..name = 'BMW',
                Manufacturer()
                  ..id = 3
                  ..name = 'Audi',
              ]);
      when(mockProvider.getManufacturers(2))
          .thenAnswer((realInvocation) async => []);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Tesla'), findsWidgets);
      expect(find.text('BMW'), findsWidgets);
      expect(find.text('Audi'), findsWidgets);
    });

    testWidgets(
        'failed to get response with not empty list - last item in list with try again',
        (WidgetTester tester) async {
      when(mockProvider.getManufacturers(1))
          .thenAnswer((realInvocation) async => [
                Manufacturer()
                  ..id = 1
                  ..name = 'Tesla',
                Manufacturer()
                  ..id = 2
                  ..name = 'BMW',
                Manufacturer()
                  ..id = 3
                  ..name = 'Audi',
              ]);
      when(mockProvider.getManufacturers(2))
          .thenAnswer((realInvocation) async => throw Exception());

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => ManufacturersBloc(
            manufacturerDataProvider: mockProvider,
          )..add(ManufacturersBlocEventFetchByPage()),
          child: const ManufacturersListScreen(),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Unable to load new page'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets(
        'failed to get response with not empty list tap try again - new page is displaying',
        (WidgetTester tester) async {
      when(mockProvider.getManufacturers(1))
          .thenAnswer((realInvocation) async => [
                Manufacturer()
                  ..id = 1
                  ..name = 'Tesla',
                Manufacturer()
                  ..id = 2
                  ..name = 'BMW',
                Manufacturer()
                  ..id = 3
                  ..name = 'Audi',
              ]);
      when(mockProvider.getManufacturers(2))
          .thenAnswer((realInvocation) async => throw Exception());

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => ManufacturersBloc(
            manufacturerDataProvider: mockProvider,
          )..add(ManufacturersBlocEventFetchByPage()),
          child: const ManufacturersListScreen(),
        ),
      ));

      await tester.pumpAndSettle();
      when(mockProvider.getManufacturers(2))
          .thenAnswer((realInvocation) async => [
                Manufacturer()
                  ..id = 1
                  ..name = 'Mercedes',
                Manufacturer()
                  ..id = 2
                  ..name = 'Mazda',
                Manufacturer()
                  ..id = 3
                  ..name = 'Bentley',
                Manufacturer()
                  ..id = 1
                  ..name = 'Mercedes',
                Manufacturer()
                  ..id = 2
                  ..name = 'Mazda',
                Manufacturer()
                  ..id = 3
                  ..name = 'Bentley',
                Manufacturer()
                  ..id = 1
                  ..name = 'Mercedes',
                Manufacturer()
                  ..id = 2
                  ..name = 'Mazda',
                Manufacturer()
                  ..id = 3
                  ..name = 'Bentley',
                Manufacturer()
                  ..id = 1
                  ..name = 'Mercedes',
                Manufacturer()
                  ..id = 2
                  ..name = 'Mazda',
                Manufacturer()
                  ..id = 3
                  ..name = 'Bentley',
                Manufacturer()
                  ..id = 1
                  ..name = 'Mercedes',
                Manufacturer()
                  ..id = 2
                  ..name = 'Mazda',
                Manufacturer()
                  ..id = 3
                  ..name = 'Bentley',
                Manufacturer()
                  ..id = 1
                  ..name = 'Mercedes',
                Manufacturer()
                  ..id = 2
                  ..name = 'Mazda',
                Manufacturer()
                  ..id = 3
                  ..name = 'Bentley',
              ]);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Mercedes'), findsWidgets);
      expect(find.text('Mazda'), findsWidgets);
      expect(find.text('Bentley'), findsWidgets);
    });
  });

  group('ModelsListScreen Tests', () {
    // success response - list is displaying
    // failed to get response with empty list - screen state error try again
    // failed to get response with empty list then tap try again with success response - list displaying

    testWidgets('success response - list is displaying',
        (WidgetTester tester) async {
      var mockProvider = MockManufacturerDataProvider();
      when(mockProvider.getMakesForManufacturer(any))
          .thenAnswer((realInvocation) async => [
                Make()
                  ..id = 448
                  ..name = 'MakeId448',
                Make()
                  ..id = 515
                  ..name = 'MakeId515'
              ]);

      when(mockProvider.getModelsForMakeId(448))
          .thenAnswer((realInvocation) async => [
                Model()
                  ..name = 'Model for make 448'
                  ..makeId = 448,
              ]);

      when(mockProvider.getModelsForMakeId(515))
          .thenAnswer((realInvocation) async => [
                Model()
                  ..name = 'Model for make 515'
                  ..makeId = 515,
              ]);
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => ManufacturerModelsBloc(
              manufacturerDataProvider: mockProvider, manufacturerId: 1085)
            ..add(ManufacturerModelsEventFetchModels()),
          child: const ModelsListScreen(manufacturerName: 'manufacturerName'),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text('MakeId448 Model for make 448'), findsOneWidget);
      expect(find.text('MakeId515 Model for make 515'), findsOneWidget);
      expect(find.text('manufacturerName'), findsOneWidget);
    });

    testWidgets('failed to get response  - screen state error try again',
        (WidgetTester tester) async {
      var mockProvider = MockManufacturerDataProvider();
      when(mockProvider.getMakesForManufacturer(any))
          .thenAnswer((realInvocation) async => throw Exception());

      when(mockProvider.getModelsForMakeId(448))
          .thenAnswer((realInvocation) async => [
                Model()
                  ..name = 'Model for make 448'
                  ..makeId = 448,
              ]);

      when(mockProvider.getModelsForMakeId(515))
          .thenAnswer((realInvocation) async => [
                Model()
                  ..name = 'Model for make 515'
                  ..makeId = 515,
              ]);
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => ManufacturerModelsBloc(
              manufacturerDataProvider: mockProvider, manufacturerId: 1085)
            ..add(ManufacturerModelsEventFetchModels()),
          child: const ModelsListScreen(manufacturerName: 'manufacturerName'),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Failed to get list of models'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets(
        'failed to get response and tap try again  - list is displaying',
        (WidgetTester tester) async {
      var mockProvider = MockManufacturerDataProvider();
      when(mockProvider.getMakesForManufacturer(any))
          .thenAnswer((realInvocation) async => throw Exception());

      when(mockProvider.getModelsForMakeId(448))
          .thenAnswer((realInvocation) async => [
                Model()
                  ..name = 'Model for make 448'
                  ..makeId = 448,
              ]);

      when(mockProvider.getModelsForMakeId(515))
          .thenAnswer((realInvocation) async => [
                Model()
                  ..name = 'Model for make 515'
                  ..makeId = 515,
              ]);
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (context) => ManufacturerModelsBloc(
              manufacturerDataProvider: mockProvider, manufacturerId: 1085)
            ..add(ManufacturerModelsEventFetchModels()),
          child: const ModelsListScreen(manufacturerName: 'manufacturerName'),
        ),
      ));

      await tester.pumpAndSettle();
      when(mockProvider.getMakesForManufacturer(any))
          .thenAnswer((realInvocation) async => [
                Make()
                  ..id = 448
                  ..name = 'MakeId448',
                Make()
                  ..id = 515
                  ..name = 'MakeId515'
              ]);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('MakeId448 Model for make 448'), findsOneWidget);
      expect(find.text('MakeId515 Model for make 515'), findsOneWidget);
    });
  });
}
