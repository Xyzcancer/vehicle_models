class Model {
  String? name;
  late int makeId;

  Model();

  Model.fromMap(Map<String, dynamic> map) {
    name = map['Model_Name'];
    makeId = map['Make_ID'];
  }
}
