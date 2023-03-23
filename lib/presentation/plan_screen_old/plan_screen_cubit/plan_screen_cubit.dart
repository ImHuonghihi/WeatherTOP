import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/services/remote/trip_api/api.dart';
import 'package:weather/services/remote/trip_api/trip_model.dart';

import 'plan_screen_states.dart';

class PlanScreenCubit extends Cubit<PlanScreenStates> {
  List<TravelLocation> locations = [];
  late double lat, lon;
  PlanScreenCubit() : super(PlanScreenInitialState());
  setCurrentLocation(double lat, double lon) {
    this.lat = lat;
    this.lon = lon;
    return this;
  }

  init() async {
    emit(PlanScreenLoadingState());
    try {
      await getTravelLocation();
      emit(PlanScreenLoadedState());
    } catch (e) {
      emit(PlanScreenErrorState(e.toString()));
    }
  }

  getTravelLocation() async {
    emit(TravelLocationLoadingState());
    try {
      var tripApi = TripAPI();
      locations = await tripApi.getPlacesByRadius(
        lat: lat,
        lon: lon,
        radius: 10000,
      );
      emit(TravelLocationLoadedState());
    } catch (e) {
      emit(TravelLocationErrorState(e.toString()));
    }
  }

  static PlanScreenCubit get(context) => BlocProvider.of(context);
}
