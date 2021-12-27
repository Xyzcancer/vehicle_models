import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/api/gateway_service.dart';
import 'package:test_project/blocs/manufacturers_bloc.dart';
import 'package:test_project/providers/manufacturer_data_provider.dart';
import 'package:test_project/providers/preference_manager.dart';
import 'package:test_project/screens/manufacturers_list_screen.dart';

@GenerateMocks([
  GatewayService,
  PreferenceManager,
  ManufacturerDataProvider,
  SharedPreferences
])
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ListenableProvider(
      create: (context) => ManufacturerDataProvider(
          gatewayService: GatewayService(),
          preferenceManager: PreferenceManager(preferences: sharedPreferences)),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => ManufacturersBloc(
          manufacturerDataProvider: context.read<ManufacturerDataProvider>(),
        )..add(ManufacturersBlocEventFetchByPage()),
        child: const ManufacturersListScreen(),
      ),
    );
  }
}
