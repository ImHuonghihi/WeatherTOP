import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedHandler {
  static SharedPreferences? sharedPrefInstance;

  static String favoriteLocationsListKey = 'favoriteLocationList';
  static String favoriteLocationsTempListKey = 'favoriteLocationTempList';

  static initSharedPref() async {
    await SharedPreferences.getInstance().then((value) {
      sharedPrefInstance = value;
      debugPrint('Shared Initialized');
    });
  }

  static saveListInSharedPref(String key, list) {
    setSharedPref(
      key,
      list,
    ); //Encode to cast it to string as shared pref can not save data as map */
  }

  static getListFromSharedPref(String key) {
    dynamic res = getSharedPref(key);
    dynamic list = [];
    if (res.runtimeType == bool) {
      return list;
    } else {
      list = res;
      return list;
    }
  }

  static getSharedPref(String key) {
    try {
      dynamic sharedValue = sharedPrefInstance!.get(key);
      if (sharedValue.runtimeType.toString() == 'Null') {
        return false; //false means there is no saved in shared preference
      } else {
        return sharedValue;
      }
    } catch (error) {
      return false;
    }
  }

  static Future<bool> setSharedPref(String key, dynamic value) async {
    bool isSetPref = false;

    switch (value.runtimeType) {
      case int:
        isSetPref = await sharedPrefInstance!.setInt(key, value);
        break;
      case double:
        isSetPref = await sharedPrefInstance!.setDouble(key, value);
        break;
      case bool:
        isSetPref = await sharedPrefInstance!.setBool(key, value);
        break;
      case List<String>:
        isSetPref = await sharedPrefInstance!.setStringList(key, value);
        break;
      default:
        isSetPref = await sharedPrefInstance!.setString(key, value);
        break;
    }

    return isSetPref;
  }

  static removeSharedPref(String key) => sharedPrefInstance!.remove(key);

  static clearSharedPref() => sharedPrefInstance!.clear();
}
