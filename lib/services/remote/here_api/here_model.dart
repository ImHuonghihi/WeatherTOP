class HereLocationData {
  String id, title, language, resultType, houseNumberType;
  HerePosition position;
  HereAddress address;

  // fromjson factory
  HereLocationData({
    required this.id,
    required this.title,
    required this.language,
    required this.resultType,
    required this.houseNumberType,
    required this.position,
    required this.address,
  });

  factory HereLocationData.fromJson(Map<String, dynamic> json) {
    return HereLocationData(
      id: json['id'],
      title: json['title'],
      language: json['language'],
      resultType: json['resultType'],
      houseNumberType: json['houseNumberType'],
      position: HerePosition(
        lat: json['position']['lat'],
        lng: json['position']['lng'],
      ),
      address: HereAddress(
        label: json['address']['label'],
        countryCode: json['address']['countryCode'],
        country: json['address']['country'],
        state: json['address']['state'],
        stateCode: json['address']['stateCode'],
        county: json['address']['county'],
        countyCode: json['address']['countyCode'],
        city: json['address']['city'],
        district: json['address']['district'],
        street: json['address']['street'],
        postalCode: json['address']['postalCode'],
        houseNumber: json['address']['houseNumber'],
      ),
    );
  }
}

class HereAddress {
  String label, countryCode, country, state, county, city, district, street, 
      houseNumber;
  String? stateCode, countyCode, postalCode;
  HereAddress({
    required this.label,
    required this.countryCode,
    required this.country,
    required this.state,
    this.stateCode,
    required this.county,
    this.countyCode,
    required this.city,
    required this.district,
    required this.street,
    this.postalCode,
    required this.houseNumber,
  });

}

class HerePosition {
  double lat, lng;
  HerePosition({
    required this.lat,
    required this.lng,
  });

}