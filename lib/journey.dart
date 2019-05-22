import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'maps.dart';
import 'menu.dart';

class JourneyScreen extends StatefulWidget {
  @override
  State createState() => new JourneyScreenState();
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


class JourneyScreenState extends State<JourneyScreen> with TickerProviderStateMixin {

  String googleMapsApiKey = 'AIzaSyBT5L0KUg6VezSD0Z8rTvA2vwiYJhdIMTA';

  List<String> bioQuestions = [
    'Hiya, how can I help you today?'
  ];
  List<String> bikerNames = [
    'Amina',
    'Teju',
    'Nacho',
    'Samuel',
    'Liz',
    'Jose',
    'Davies',
    'Ben',
    'Peter',
    'Jason'
  ];
   List<String> walkerNames = [
    'Sarnava',
    'Bose',
    'Felix',
    'Murphy',
    'Gavin',
    'Musa',
    'Usiph',
    'Calvin',
    'Mensah',
    'Kwaku'
  ];

  List<bool> feedbackButton = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

    List<String> bikerImages = [
    'assets/avatars1.jpg',
    'assets/avatars2.jpg',
    'assets/avatars3.jpg',
    'assets/avatars4.jpg',
    'assets/avatars5.jpg',
    'assets/avatars6.jpg',
    'assets/avatars7.jpg',
    'assets/avatars8.jpg',
    'assets/avatars9.jpg',
    'assets/avatars10.jpg',
  ];

    List<String> walkerImages = [
    'assets/avatars10.jpg',
    'assets/avatars9.jpg',
    'assets/avatars8.jpg',
    'assets/avatars7.jpg',
    'assets/avatars6.jpg',
    'assets/avatars5.jpg',
    'assets/avatars4.jpg',
    'assets/avatars3.jpg',
    'assets/avatars2.jpg',
    'assets/avatars1.jpg',
  ];

  List<String> nameList;
  List<String> nameImage;

  String personText = 'Bike Mate';
  String groupText = 'Bike Group';

  double calculatePadding(int index) {
    double padding = 180.0;
    if(nameList[index].length == 6) {
      padding = 180;
    } else  if(nameList[index].length == 5) {
      padding = 190;
    } else  if(nameList[index].length == 4) {
      padding = 200;
    } else  if(nameList[index].length == 3) {
      padding = 210;
    } else  if(nameList[index].length == 2) {
      padding = 210;
    }
    return padding;
  }

 
  @override
  void initState() {
    super.initState();
    nameList = bikerNames;
    nameImage = bikerImages;
  }

  @override
  void dispose() {
    super.dispose();
  }

    Widget build(BuildContext context) {
    return new Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 80),
          child: CurvedNavigationBar(
          backgroundColor: Colors.blueAccent,
          items: <Widget>[
            Icon(Icons.directions_bike, size: 30),
            Icon(Icons.directions_walk, size: 30),
          ],
          onTap: (index) {
            setState(() {
              if (nameList[0] == bikerNames[0]){
               nameList = walkerNames;
               nameImage = walkerImages;
              } else {
                nameList = bikerNames;
                nameImage = bikerImages;
              }
            });
          },
        )),
        body: Container(
          color: Colors.white24,
          child:Padding(
            padding: EdgeInsets.only(top:90),
          child: Column(
            children: <Widget>[
              new SizedBox(
                height: 580.0,
                child: new ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 10,
                    itemExtent: 80.0,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: new Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0),
                          child: new Container(
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                            child: new Column(children: [
                              new Padding(
                                padding: new EdgeInsets.only( left: 5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MapsPage(
                                        title: 'Group Location',
                                      )),
                                    );
                                  },
                                  child: Row(
                                  children: <Widget> [
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundImage:AssetImage(nameImage[index]),
                                        backgroundColor: Colors.blueAccent,
                                      ),
                                    ),
                                    Text(nameList[index]),
                                    Padding(
                                      padding: EdgeInsets.only(left: calculatePadding(index)),
                                      child: IconButton(
                                        icon: feedbackButton[index] == false? 
                                          Icon(CupertinoIcons.add_circled, color: Colors.blueAccent,) : 
                                          Icon(CupertinoIcons.check_mark_circled, color: Colors.greenAccent),
                                        onPressed: () {
                                          setState(() {
                                            feedbackButton[index] = feedbackButton[index] == true ? false : true;
                                          });
                                        },
                                      ),
                                    )
                                ],), 
                                ),
                              ),
                            ]),
                          ),
                        ),
                      );
                    }),

              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.of(context).push(new CupertinoPageRoute<void>(
                    builder: (BuildContext context) => new ClinibotTab()
                  ));
                },
                child: Text('Create Group',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blueAccent,
              ),
              ])
            ),
        ));
  }
}
