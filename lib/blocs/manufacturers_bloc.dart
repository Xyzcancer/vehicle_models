import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/api/model/manufacturer.dart';
import 'package:test_project/providers/manufacturer_data_provider.dart';

abstract class ManufacturersBlocEvent {}

class ManufacturersBlocEventFetchByPage extends ManufacturersBlocEvent {}

abstract class ManufacturersBlocState {}

class ManufacturersBlocStateInitial extends ManufacturersBlocState {}

class ManufacturersBlocStateFetched extends ManufacturersBlocState {}

class ManufacturersBlocStateFetchFailed extends ManufacturersBlocState {
  final String errorMessage;

  ManufacturersBlocStateFetchFailed(this.errorMessage);
}

class ManufacturersBloc
    extends Bloc<ManufacturersBlocEvent, ManufacturersBlocState> {
  ManufacturersBloc({required this.manufacturerDataProvider})
      : super(ManufacturersBlocStateInitial()) {
    on<ManufacturersBlocEventFetchByPage>((event, emit) async {
      if (_isLoading) {
        return;
      }
      _isLoading = true;
      try {
        var response =
            await manufacturerDataProvider.getManufacturers(page + 1);
        if (response.isEmpty) {
          _hasMore = false;
        } else {
          page++;
          manufacturers.addAll(response);
        }
        _isLoading = false;
        emit(ManufacturersBlocStateFetched());
      } catch (e) {
        _isLoading = false;
        emit(ManufacturersBlocStateFetchFailed(e.toString()));
      }
    });
  }

  final ManufacturerDataProvider manufacturerDataProvider;

  List<Manufacturer> manufacturers = [];
  int page = 0;
  bool _hasMore = true;
  bool _isLoading = false;

  int get manufacturersCount {
    return _hasMore ? manufacturers.length + 1 : manufacturers.length;
  }
}
