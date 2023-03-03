class GeonameData {
  late String country, name, timezone;
  late double lat, lon;
  late int population;

  GeonameData.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    name = json['name'];
    timezone = json['timezone'];
    lat = json['lat'];
    lon = json['lon'];
    population = json['population'];
  }
}

class TravelLocation {
  late String name, osm, xid, wikidata, kind;
  late double lat, lon;

  TravelLocation(
      {required this.name,
      required this.osm,
      required this.xid,
      required this.wikidata,
      required this.kind,
      required this.lat,
      required this.lon});

  TravelLocation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    osm = json['osm'];
    xid = json['xid'];
    wikidata = json['wikidata'];
    kind = json['kind'];
    lat = json['point']['lat'];
    lon = json['point']['lon'];
  }
}

class XIDData {
  late String kinds, geometry;
  late List<String> attributes;
  late double latMin, latMax, lonMin, lonMax, lon, lat;


  XIDData.fromJson(Map<String, dynamic> json) {
    kinds = json['kinds'];
    geometry = json['source']['geometry'];
    attributes = json['source']['attributes'];
    latMin = json['bbox']['lat_min'];
    latMax = json['bbox']['lat_max'];
    lonMin = json['bbox']['lon_min'];
    lonMax = json['bbox']['lon_max'];
    lon = json['point']['lon'];
    lat = json['point']['lat'];
  }
}
