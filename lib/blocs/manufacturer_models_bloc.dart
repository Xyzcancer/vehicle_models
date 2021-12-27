import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/api/model/model.dart';
import 'package:test_project/providers/manufacturer_data_provider.dart';

abstract class ManufacturerModelsEvent {}

class ManufacturerModelsEventFetchModels extends ManufacturerModelsEvent {}

abstract class ManufacturerModelsState {}

class ManufacturerModelsStateInitial extends ManufacturerModelsState {}

class ManufacturerModelsStateFetched extends ManufacturerModelsState {}

class ManufacturerModelsStateFetchFailed extends ManufacturerModelsState {
  final String errorMessage;

  ManufacturerModelsStateFetchFailed(this.errorMessage);
}

class ManufacturerModelsBloc
    extends Bloc<ManufacturerModelsEvent, ManufacturerModelsState> {
  ManufacturerModelsBloc(
      {required this.manufacturerDataProvider, required this.manufacturerId})
      : super(ManufacturerModelsStateInitial()) {
    on<ManufacturerModelsEventFetchModels>((event, emit) async {
      try {
        var makes = await manufacturerDataProvider
            .getMakesForManufacturer(manufacturerId);
        for (var make in makes) {
          makeNames[make.id] = make.name ?? 'Unknown make name';
          var modelsResponse =
              await manufacturerDataProvider.getModelsForMakeId(make.id);
          models.addAll(modelsResponse);
        }
        emit(ManufacturerModelsStateFetched());
      } catch (e) {
        emit(ManufacturerModelsStateFetchFailed(e.toString()));
      }
    });
  }

  final ManufacturerDataProvider manufacturerDataProvider;
  final int manufacturerId;

  List<Model> models = [];
  Map<int, String> makeNames = {};
}
