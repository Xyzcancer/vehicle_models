import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/blocs/manufacturer_models_bloc.dart';
import 'package:test_project/blocs/manufacturers_bloc.dart';
import 'package:test_project/providers/manufacturer_data_provider.dart';
import 'package:test_project/screens/models_list_screen.dart';

class ManufacturersListScreen extends StatefulWidget {
  const ManufacturersListScreen({Key? key}) : super(key: key);

  @override
  _ManufacturersListScreenState createState() =>
      _ManufacturersListScreenState();
}

class _ManufacturersListScreenState extends State<ManufacturersListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manufacturers List'),
      ),
      body: BlocConsumer(
        bloc: context.read<ManufacturersBloc>(),
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ManufacturersBlocStateInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ManufacturersBlocStateFetchFailed &&
              context.read<ManufacturersBloc>().manufacturers.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Failed to get list of manufacturers'),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context
                            .read<ManufacturersBloc>()
                            .add(ManufacturersBlocEventFetchByPage());
                      },
                      child: const Text('Try Again')),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: context.read<ManufacturersBloc>().manufacturersCount,
            itemBuilder: (context, index) {
              var manufacturers =
                  context.read<ManufacturersBloc>().manufacturers;
              if (index == manufacturers.length) {
                if (state is ManufacturersBlocStateFetchFailed) {
                  return Center(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Unable to load new page'),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              context
                                  .read<ManufacturersBloc>()
                                  .add(ManufacturersBlocEventFetchByPage());
                            },
                            child: const Text('Try Again')),
                      ],
                    ),
                  );
                }
                context
                    .read<ManufacturersBloc>()
                    .add(ManufacturersBlocEventFetchByPage());
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return ListTile(
                title: Text(manufacturers[index].name ?? 'No Name'),
                subtitle: Text(manufacturers[index].country ?? 'No Country'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return BlocProvider(
                        create: (context) => ManufacturerModelsBloc(
                            manufacturerDataProvider:
                                context.read<ManufacturerDataProvider>(),
                            manufacturerId: manufacturers[index].id)
                          ..add(ManufacturerModelsEventFetchModels()),
                        child: ModelsListScreen(
                          manufacturerName:
                              manufacturers[index].name ?? 'Unknown',
                        ),
                      );
                    }),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
