import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationAPI {
  static const int locationServiceIsDisabled = 0;
  static const int allowedPermission = 1;
  static const int deniedPermission = 2;

  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  static Future<int> getLocation() async {
    int resultOfChecking = await _checkLocationServices();
    if (resultOfChecking == locationServiceIsDisabled) {
      return locationServiceIsDisabled;
    } else if (resultOfChecking == deniedPermission) {
      return deniedPermission;
    } else {
      return allowedPermission;
    }
  }

  static Future<int> _checkLocationServices() async {
    bool serviceEnabled;
    bool permissionAllowed;
    int result = locationServiceIsDisabled; //default

    serviceEnabled = await isLocationServiceEnabled();
    if (serviceEnabled) {
      permissionAllowed = await _isPermissionServiceAllowed();
      if (permissionAllowed) {
        result = allowedPermission;
      } else {
        result = deniedPermission;
      }
    }
    return result;
  }

  //Location Services
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<bool> _isPermissionServiceAllowed() async {
    LocationPermission permission;
    bool result = true;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever ||
          permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are denied');
        result = false;
      }
    }
    return result;
  }

  //Get Current Position
  static Future<Position> getPosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
