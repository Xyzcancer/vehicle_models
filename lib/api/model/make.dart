class Make {
  late int id;
  String? name;

  Make();

  Make.fromMap(Map<String, dynamic> map) {
    id = map['Make_ID'];
    name = map['Make_Name'];
  }
}
