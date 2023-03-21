class HereLocationData {
  String id, title, resultType;
  String? language, houseNumberType;
  HerePosition? position;
  HereAddress? address;

  // fromjson factory
  HereLocationData({
    required this.id,
    required this.title,
     this.language,
     required this.resultType,
     this.houseNumberType,
     this.position,
     this.address,
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
  final String label;
  String? countryCode, country, state, county, city, district, street, 
      houseNumber, stateCode, countyCode, postalCode;
  HereAddress({
    required this.label,
    this.countryCode,
    this.country,
    this.state,
    this.stateCode,
    this.county,
    this.countyCode,
    this.city,
    this.district,
    this.street,
    this.postalCode,
    this.houseNumber,
  });

}

class HerePosition {
  double lat, lng;
  HerePosition({
    required this.lat,
    required this.lng,
  });

}