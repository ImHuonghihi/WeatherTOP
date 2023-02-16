abstract class HomeScreenStates {}

class HomeScreenInitState extends HomeScreenStates {}

class LocationServicesDisabledState extends HomeScreenStates {}

class DeniedPermissionState extends HomeScreenStates {}

class LocationSuccessfullySetState extends HomeScreenStates {}

class LoadingSettingLocationState extends HomeScreenStates {}

class LoadingGettingPositionState extends HomeScreenStates {}

class AskToAllowPermissionState extends HomeScreenStates {}

//Weather API States
class LoadingDataFromWeatherAPIState extends HomeScreenStates {}

class SuccessfullyLoadedDataFromWeatherAPIState extends HomeScreenStates {}

class FailedToLoadDataFromWeatherAPIState extends HomeScreenStates {}
