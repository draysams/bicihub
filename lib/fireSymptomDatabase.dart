class FireSymptomQuery {
  String key;
  String sex;
  int age;
  List<dynamic> evidence;
  String condition;
  String commonName;
  String probability;

  FireSymptomQuery(this.sex, this.age, this.evidence,
      [this.condition, this.commonName, this.probability]);

  FireSymptomQuery.fromJson(Map<dynamic, dynamic> json)
      : sex = json['sex'],
        age = json['age'],
        evidence = json['evidence'];

  FireSymptomQuery.getJson(String key, Map<dynamic, dynamic> json)
      : sex = json[key]['sex'],
        age = json[key]['age'],
        condition = json[key]['condition'],
        commonName = json[key]['commonName'],
        probability = json[key]['probability'],
        evidence = json[key]['evidence'];

  FireSymptomQuery.mineJson(Map<dynamic, dynamic> json)
      : sex = json['sex'],
        age = json['age'],
        condition = json['condition'],
        commonName = json['commonName'],
        probability = json['probability'],
        evidence = json['evidence'];

  Map<String, dynamic> toJson() => {
        'sex': sex,
        'age': age,
        'evidence': evidence,
        'condition': condition,
        'commonName': commonName,
        'probability': probability
      };

}
