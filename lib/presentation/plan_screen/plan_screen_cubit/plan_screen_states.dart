
class PlanScreenStates {}

class PlanScreenInitialState extends PlanScreenStates {}

class PlanScreenLoadingState extends PlanScreenStates {}

class PlanScreenLoadedState extends PlanScreenStates {}

class TravelLocationLoadingState extends PlanScreenStates {}

class TravelLocationLoadedState extends PlanScreenStates {}

class TravelLocationErrorState extends PlanScreenStates {
  final String message;

  TravelLocationErrorState(this.message);
}

class PlanScreenErrorState extends PlanScreenStates {
  final String message;

  PlanScreenErrorState(this.message);
}

