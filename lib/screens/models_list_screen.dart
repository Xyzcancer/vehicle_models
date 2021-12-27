import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/blocs/manufacturer_models_bloc.dart';
import 'package:test_project/widgets/widget_keys.dart';

class ModelsListScreen extends StatefulWidget {
  final String manufacturerName;
  const ModelsListScreen({Key? key, required this.manufacturerName})
      : super(key: key);

  @override
  _ModelsListScreenState createState() => _ModelsListScreenState();
}

class _ModelsListScreenState extends State<ModelsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.manufacturerName),
      ),
      body: BlocConsumer(
        bloc: context.read<ManufacturerModelsBloc>(),
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ManufacturerModelsStateInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ManufacturerModelsStateFetchFailed) {
            return Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Failed to get list of models'),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context
                            .read<ManufacturerModelsBloc>()
                            .add(ManufacturerModelsEventFetchModels());
                      },
                      child: const Text('Try Again')),
                ],
              ),
            );
          }

          var bloc = context.read<ManufacturerModelsBloc>();

          return ListView.builder(
            key: const Key(WidgetKeys.modelsListView),
            itemCount: context.read<ManufacturerModelsBloc>().models.length,
            itemBuilder: (context, index) {
              var model = bloc.models[index];

              return ListTile(
                title: Text('${bloc.makeNames[model.makeId]} ${model.name}'),
              );
            },
          );
        },
      ),
    );
  }
}
