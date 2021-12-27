class Manufacturer {
  late int id;
  String? name;
  String? country;

  Manufacturer();

  Manufacturer.fromMap(Map<String, dynamic> map) {
    id = map['Mfr_ID'];
    name = map['Mfr_Name'];
    country = map['Country'];
  }
}
