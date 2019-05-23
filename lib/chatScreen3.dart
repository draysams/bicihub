import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'platform_adaptive.dart';
import 'chatScreen2.dart';
import 'fireSymptomDatabase.dart';
import 'metaEvidenceDatabase.dart';

import 'dart:convert';
import 'dart:async';
import 'maps.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Clinibot',
      theme:
          defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme : kIOSTheme,
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class Extras {
  bool disableGroups = false;

  Extras.fromJson(Map<String, bool> json)
      : disableGroups = json['disable_groups'];

  Map<String, bool> toJson() => {
        'disable_groups': disableGroups,
      };
}

class SymptomQuery {
  String sex;
  int age;
  List<Evidence> evidence;
  Extras extras;

  SymptomQuery(this.sex, this.age, this.evidence, this.extras);

  SymptomQuery.fromJson(Map<String, dynamic> json)
      : sex = json['sex'],
        age = json['age'],
        evidence = json['evidence'],
        extras = json['extras'];

  Map<String, dynamic> toJson() => {
        'sex': sex,
        'age': age,
        'evidence': evidence,
        'extras': extras,
      };
}



class Evidence {
  String id;
  String choiceId;
  bool initial;

  Evidence(this.id, this.choiceId, this.initial);

  Evidence.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        choiceId = json['choice_id'],
        initial = json['initial'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'choice_id': choiceId,
        'initial': initial,
      };
}


class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  List<ChatMessage> _messages = [];
  TextEditingController _textController = new TextEditingController();


  String currentUserName = '';

  bool passedBio = true;
  bool inDiagnosis = false;
  bool flagged = false;
  bool numericQuery;
  String newId;
  String questionText;
  int questionIndex = 0;
  String sex;
  int age;
  List<Evidence> evidence = new List<Evidence>();
  List<MetaEvidence> metaEvidence = new List<MetaEvidence>();
  var avatar = const Avatar(
    text: 'CB',
    color: const Color(0xFFFD5015),
  );

  SymptomQuery symptomQuery;
  FireSymptomQuery fireSymptomQuery;

  String googleMapsApiKey = 'AIzaSyBT5L0KUg6VezSD0Z8rTvA2vwiYJhdIMTA';

  List<String> bioQuestions = [
    'Hiya, how can I help you today?'
  ];

  @override
  void initState() {
    super.initState();
      _addMessage('Heyy, \n What time are we meeting', avatar);
      new Timer(const Duration(seconds: 2), () {
        _addMessage("How does 8:10 AM sound?", avatar);
      return;
      });

    // new Timer(const Duration(seconds: 2), () {
    //     _addMap('https://maps.googleapis.com/maps/api/staticmap?center=53.293852%2C-6.4237298&zoom=10&size=800x600&key=' + googleMapsApiKey, avatar);
    //   return;
    //   });
  }

  @override
  void dispose() {
  super.dispose();
    for (ChatMessage message in _messages) {
      if(message.animationController != null) {
        message.animationController.dispose();
      }
    }
  }

  void handleSubmitted(String text) {
    if (text == "") {} else {
      _textController.clear();
      if (passedBio && !inDiagnosis) {
        _addMessage(text);
        sendDiagnosis(text);
      } else if (passedBio && inDiagnosis) {
        print("passed bio : $text");
        _addMessage("Please answer my questions with the buttons provided.", avatar);
        sendDiagnosis(text);
      }
    }
  }
  
  bool isNumeric(string) => num.tryParse(string) != null;

  void _handleUnpassed(String text) {
    if (text == "") {} else {
      while (questionIndex <= 1) {
        _textController.clear();
        _addMessage(text);
        if(!flagged) {
          questionIndex++;
        }
        //flagged == true ? null : questionIndex++;
        return;
      }
      setState(() {
        passedBio = true;
        age = age;
        sex = sex;
      });
    }
  }

  void handleDiagnosis(String text) {
    var evidenceJson = {
      "id": newId,
      "choice_id": text,
    };
    var questionEvidenceJson = {
      "id": newId,
      "choice_id": text,
      "question": questionText,
    };
    var newEvidence = new Evidence.fromJson(evidenceJson);
    evidence.add(newEvidence);
    var newMetaEvidence = new MetaEvidence.fromJson(questionEvidenceJson);
    metaEvidence.add(newMetaEvidence);
    setState(() {
      inDiagnosis = true;
      symptomQuery = new SymptomQuery(
          sex, age, evidence, new Extras.fromJson({'disable_groups': true}));
      fireSymptomQuery = new FireSymptomQuery(sex, age, metaEvidence);
    });
  }

  Future<http.Response> sendDiagnosis(String queryText) async {
     print("In send diagnosis");
    var url = "https://api.cai.tools.sap/build/v1/dialog";
    //var body = json.encode({"text": "$text"});
    var body = json.encode({
      "message": {
          "type": "text",
          "content": queryText
      },
      "conversation_id": "test-1533969037613",
      "log_level": "info"
    });
    Map<String, String> headers = {
      'Authorization': 'Token 3c43937adf4db3c0ff963f3972edc708',
      'x-uuid': 'aef2bedc-5877-4d8d-aea1-6149b455ea71',
      'Content-type': "application/json",
      'Accept': 'application/json',
    };

    var response = await http.post(url, body: body, headers: headers);

    final responseJson = json.decode(response.body);
    var answerText = responseJson['results']['messages'][0]['content'];
    print('The ID is ' + responseJson['results']['messages'].toString());
    
     setState(() {
        questionText = answerText;
      });

    if (queryText == 'Where should we meet?' || 
         queryText.trim() ==  'where should we meet?' || 
         queryText.trim() == 'meeting point?'|| 
         queryText.trim() ==  'meeting point' ||
         queryText.trim() ==  'where do we meet?' ||
         queryText.trim() ==  'where do we meet?' ) {
      new Timer(const Duration(seconds: 1), () {
        _addMessage('Let\'s meet at your house?.', avatar);
      });
    } else if (queryText == 'Sure' ||
               queryText == 'sure' ||
               queryText == 'yes' ||
               queryText == 'awesome' ||
               queryText == 'yhup' ||
               queryText == 'agreed' ||
               queryText == 'yeah') {
      _addMessage('Awesome, let\'s meet at 8:10 AM at your house', avatar);
      new Timer(const Duration(seconds: 1), () {
        _addMap('https://maps.googleapis.com/maps/api/staticmap?center=53.293852%2C-6.4237298&zoom=10&size=800x600&key=' + googleMapsApiKey, 'bike_parking', avatar);
        return;
      },);
    } else {
      new Timer(const Duration(seconds: 1), () {
        _addMessage('You can ask \n"where do we meet?"\n\n And type "agreed" when done.', avatar);
      }); 
    }

    if (questionText == 'car_parking' || questionText == 'all_car_parks') {
      _addMessage('Tap the map below to view\nall car parks in your area.', avatar);
      new Timer(const Duration(seconds: 1), () {
        _addMap('https://maps.googleapis.com/maps/api/staticmap?center=53.293852%2C-6.4237298&zoom=10&size=800x600&key=' + googleMapsApiKey, 'car_parking', avatar);
        return;
      });
    } else if (questionText == 'disabled_parking') {
      _addMessage('Tap the map below to view\nthe available disabled car parks', avatar);
      new Timer(const Duration(seconds: 1), () {
        _addMap('https://maps.googleapis.com/maps/api/staticmap?center=53.293852%2C-6.4237298&zoom=10&size=800x600&key=' + googleMapsApiKey, 'disabled_parking', avatar);
        return;
      });
    } else if (questionText == 'charging_points') {
      _addMessage('Tap the map below to view\nthe available EV charge points', avatar);
      new Timer(const Duration(seconds: 1), () {
        _addMap('https://maps.googleapis.com/maps/api/staticmap?center=53.293852%2C-6.4237298&zoom=10&size=800x600&key=' + googleMapsApiKey, 'charging_points', avatar);
        return;
      });
    } else if (questionText == 'maintenance') {
      _addMessage('There is currently no maintenance schedule near you.', avatar);
    } else if (questionText == 'bike_parking') {
      _addMessage('Awesome, let\'s meet at 8:10 AM at my house', avatar);
      new Timer(const Duration(seconds: 1), () {
        _addMap('https://maps.googleapis.com/maps/api/staticmap?center=53.293852%2C-6.4237298&zoom=10&size=800x600&key=' + googleMapsApiKey, 'bike_parking', avatar);
        return;
      });
    } else if (questionText == 'nearest_car_park') {
      _addMessage('Tap the map below to view\ntake you the nearest car park.', avatar);
      new Timer(const Duration(seconds: 1), () {
        _addMap('https://maps.googleapis.com/maps/api/staticmap?center=53.293852%2C-6.4237298&zoom=10&size=800x600&key=' + googleMapsApiKey, 'nearest_car_park', avatar);
        return;
      });
    } else if (questionText == 'nearest_charge_point') {
      _addMessage('Tap the map below to take you to\nthe nearest charge point.', avatar);
      new Timer(const Duration(seconds: 1), () {
        _addMap('https://maps.googleapis.com/maps/api/staticmap?center=53.293852%2C-6.4237298&zoom=10&size=800x600&key=' + googleMapsApiKey, 'nearest_charge_point', avatar);
        return;
      });

    } else if (questionText == 'general_parking') {
      _addMessage('Do you want : \n' +
        '    - Car parking,\n' +
        '    - Disabled parking, or \n' +
        '    - Bicycle parking? \n', avatar);
    }
    
    return response;
  }

  void handleStopCondition(bool shouldStop) {
    if (shouldStop) {}
  }

  void _addMessage(String text, [Avatar avatar]) {
    bool answerButtons = text == 'strikeAnswers';
    var animationController = new AnimationController(
      duration: new Duration(milliseconds: 700),
      vsync: this,
    );
    var message = new ChatMessage(
        text: text, avatar: avatar, animationController: animationController);

    var message1 = new ChatMessage(
        text: 'Yes', avatar: avatar, animationController: animationController);

    var message2 = new ChatMessage(
        text: 'No', avatar: avatar, animationController: animationController);

    var message3 = new ChatMessage(
        text: "Don't know",
        avatar: avatar,
        animationController: animationController);
    setState(() {
      if(!answerButtons) {
        _messages.insert(0, message);
      } else {
        _messages.insert(0, message1);
        _messages.insert(0, message2);
        _messages.insert(0, message3);
      }
    });
    animationController?.forward();
  }

  void _addMap(String mapImage, String text, [Avatar avatar]) {
    var animationController = new AnimationController(
      duration: new Duration(milliseconds: 700),
      vsync: this,
    );
    var message = new ChatMessage(
        mapImage: mapImage, text : text, avatar: avatar, animationController: animationController);
    setState(() {
      _messages.insert(0, message);
    });
    animationController?.forward();
  }

  void handleAnswers(String text) {
    if (
      text== 'car_parking' || 
      text== 'all_car_parks' ||
      text== 'disabled_parking' ||
      text== 'charging_points' ||
      text== 'maintenance' ||
      text== 'bike_parking' ||
      text== 'nearest_car_park' ||
      text== 'nearest_charge_point'
     ) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapsPage(
          title: text,
        )),
      );
    } else {
      print('Do not launch : ' + text);
    }
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new PlatformAdaptiveContainer(
            child: new Row(
              children: [
                new Flexible(
                  child: new TextField(
                    scrollPadding: EdgeInsets.only(bottom: 40),
                    maxLines: 4,
                    maxLength: 120,
                    keyboardType: TextInputType.multiline,
                    controller: _textController,
                    onSubmitted: handleSubmitted,
                    decoration: InputDecoration.collapsed(hintText: 'Send a message'),
                  ),
                ),
                new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 4.0),
                    padding: EdgeInsets.only(bottom: 40.0),
                    child: new Row( 
                    children: <Widget>[
                      new PlatformAdaptiveButton(
                        icon: new Icon(Icons.send),
                        onPressed: passedBio
                            ? () => handleSubmitted(_textController.text)
                            : () => _handleUnpassed(_textController.text),
                        child: new Text('Send'),
                    ),
                    IconButton(
                      icon: Icon(CupertinoIcons.location),
                      onPressed: () {
                        Navigator.of(context).push(new CupertinoPageRoute<void>(
                          builder: (BuildContext context) => new MapsPage(title: 'Group Location'),
                        ));
                      },
                    ),
                    
                    ]),
                ),
              ]
            )));
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(colors: [Colors.blue[800], Colors.green[600]],
                begin: const FractionalOffset(0.5, 0.0),
                end: const FractionalOffset(0.0, 0.5),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp
            ),
          ),
        
        child: new Column(children: [
      new Flexible(
          child: new ListView.builder(
        padding: new EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (_, int index) => new GestureDetector(
              onTap: () => handleAnswers(_messages[index].text),
              child: new ChatMessageListItem(_messages[index]),
            ),
        itemCount: _messages.length,
      )),
      new Divider(height: 1.0),
      new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer()),
      new Padding(padding: new EdgeInsets.only(top: 50.0))
    ])));
  }
}

class ChatMessage {
  ChatMessage({this.text, this.mapImage, this.avatar, this.animationController});
  final String text;
  final String mapImage;
  final Avatar avatar;
  final AnimationController animationController;
}

class ChatMessageListItem extends StatelessWidget {
  ChatMessageListItem(this.message);

  final ChatMessage message;
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    if (message.avatar != null) children.add(message.avatar);

    final bool isSelf = message.avatar == null;
    
    if (message.mapImage != null) {
      children.add(
        new ConversationBubble(
          mapImage: message.mapImage,
          color: isSelf ? BubbleColor.blue : BubbleColor.gray,
        ));
    } else {
      children.add(
        new ConversationBubble(
          text: message.text,
          color: isSelf ? BubbleColor.blue : BubbleColor.gray,
        ),
      );
    }

    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: message.animationController, curve: Curves.fastOutSlowIn),
        child: new Container(
          child: new Row(
            mainAxisAlignment:
                isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
                isSelf ? CrossAxisAlignment.center : CrossAxisAlignment.end,
            children: [
              new Row(
                children: children,
              )
            ],
          ),
        ));
  }
}
