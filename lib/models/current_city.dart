class CurrentCountryDetails {
  dynamic currentCountry;
  dynamic currentCity;
  dynamic currentSunRise;
  dynamic currentSunSet;
  dynamic currentLat;
  dynamic currentLon;

  CurrentCountryDetails({
    required this.currentCountry,
    required this.currentCity,
    required this.currentLat,
    required this.currentLon,
    required this.currentSunRise,
    required this.currentSunSet,
  });

  CurrentCountryDetails.fromApi(json) {
    currentCountry = json['country'];
    currentCity = json['name'];
    currentLat = json['coord']['lat'];
    currentLon = json['coord']['lon'];
    currentSunRise = json['sunrise'];
    currentSunSet = json['sunset'];
  }
}
