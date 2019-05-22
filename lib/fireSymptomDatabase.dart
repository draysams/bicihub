import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

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

  FireSymptomQuery.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        age = snapshot.value['age'],
        sex = snapshot.value['sex'],
        condition = snapshot.value['condition'],
        commonName = snapshot.value['commonName'],
        probability = snapshot.value['probability'],
        evidence = snapshot.value["evidence"];

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

  static Future<StreamSubscription<Event>> getSessionStream(
      String userId, void onData(FireSymptomQuery fireSymptomQuery)) async {
    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child('sessions')
        .child(userId)
        .onValue
        .listen((Event event) {

      for (String key in event.snapshot.value.keys) {
        var fireSymptomQuery =
        new FireSymptomQuery.getJson(key, event.snapshot.value);
        onData(fireSymptomQuery);
      }
    });
    return subscription;
  }

  static Future<FireSymptomQuery> getSession(String userId, String sessionKey) async {
    Completer<FireSymptomQuery> completer = new Completer<FireSymptomQuery>();


    FirebaseDatabase.instance
        .reference()
        .child('sessions')
        .child(userId)
        .child(sessionKey)
        .once()
        .then((DataSnapshot snapshot) {
      var fireSymptomQuery = new FireSymptomQuery.mineJson(snapshot.value);
      completer.complete(fireSymptomQuery);
    });

    return completer.future;
  }
}
