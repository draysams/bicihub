import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> fetchMessage() async {
    print("In fetch message");
    var url = "https://api.infermedica.com/v2/parse";
    var body = json.encode({"text": "I feel smoach pain but no couoghing today"});
    Map headers = {
      'App-Key' : 'e71a9f25b06622b427c4ec0894b41ec4',
      'App-Id' : '8f007758',
      'Content-type' : "application/json", 
      'Accept': 'application/json',
    };
    // request.headers[HttpHeaders.CONTENT_TYPE] = 'application/json; charset=utf-8';
    // request.headers["App-Key"] = 'e71a9f25b06622b427c4ec0894b41ec4';
    // request.headers["App-Id"] = '8f007758';
    // request.bodyFields = body;
    // var future = client.send(request).then((response)
    //     => response.stream.bytesToString().then((value)
    //         => print(value.toString()))).catchError((error) => print(error.toString()));
    final response =
        await http.post(url, body: body, headers: headers);
    print("response : " + response.body.toString());

    return response;
}

// {
//     "results": {
//         "owner_type": "User",
//         "owner": {
//             "id": "aef2bedc-5877-4d8d-aea1-6149b455ea71",
//             "name": null,
//             "nickname": "samueldavies",
//             "image": "https://www.gravatar.com/avatar/9dea3e1af25d897c9c6392f362bbffe7?s=400&d=https://cdn.cai.tools.sap/website/home/user-no-photo-01.png",
//             "role": "developer",
//             "slug": "samueldavies",
//             "created_at": "2019-05-07T09:45:08.380Z",
//             "bots_count": 0,
//             "collaborations_count": 0
//         }
//     },
//     "message": "Owner rendered with success"
// }

class Message {
  final List text;
  String name;
  String presence;
  int counter;
  String id;
  String casualName;



  Message({this.text, this.name, this.presence, this.id, this.casualName});

  factory Message.fromJson(Map<String, dynamic> json, counter) {
    return new Message(
      text: json['mentions'],
      name: json['mentions'][counter]['name'],
      presence: json['mentions'][counter]['choice_id'],
      id: json['mentions'][counter]['id'],
      casualName: json['mentions'][counter]['orth'],
    );
  }
}

class RegisterMessage {
  String uuid;



  RegisterMessage({this.uuid});

  factory RegisterMessage.fromJson(Map<String, dynamic> json) {
    return new RegisterMessage(
      uuid: json['results'],
    );
  }
}

class DiagnosisMessage {
  Map question;
  List conditions;
  bool shouldStop;
  String questionText;
  String conditionId;
  String questionId;
  Map answerChoices;

  DiagnosisMessage({
    this.question, 
    this.conditions, 
    this.conditionId, 
    this.questionId,
    this.shouldStop, 
    this.questionText, 
    this.answerChoices
  });

  factory DiagnosisMessage.fromJson(Map<String, dynamic> json) {
    return new DiagnosisMessage(
      question: json['question'],
      conditions: json['conditions'],
      questionText: json['question']['text'],
      questionId: json['question']['items'][0]['id'],
      answerChoices: json['question']['choices'],
      shouldStop: json['should_stop'],
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'conditions': conditions,
    'questionText': questionText,
    'answerChoices': answerChoices,
    'shouldStop': shouldStop,
  };
}


class PushMessage {
  Map question;
  List conditions;
  bool shouldStop;
  String questionText;
  String conditionId;
  String questionId;
  Map answerChoices;

  PushMessage({
    this.question, 
    this.conditions, 
    this.conditionId, 
    this.questionId,
    this.shouldStop, 
    this.questionText, 
    this.answerChoices
  });

  factory PushMessage.fromJson(Map<String, dynamic> json) {
    return new PushMessage(
      question: json['question'],
      conditions: json['conditions'],
      questionText: json['question']['text'],
      questionId: json['question']['items'][0]['id'],
      answerChoices: json['question']['choices'],
      shouldStop: json['should_stop'],
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'conditions': conditions,
    'questionText': questionText,
    'answerChoices': answerChoices,
    'shouldStop': shouldStop,
  };
}