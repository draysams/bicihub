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

  String personText = 'Bike Mate';
  String groupText = 'Bike Group';

  @override
  void initState() {
    super.initState();
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
              groupText = groupText == 'Bike Group' ? 'Walk Group' : 'Bike Group';
              personText = personText == 'Walk Mate' ? 'Bike Mate' : 'Walk Mate';
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
                      iconPressed[index] = false;
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
                                        backgroundImage:
                                            NetworkImage("http://assets.gcstatic.com/u/apps/asset_manager/uploaded/2015/03/businessman-on-phones-1421860994-custom-0.jpg"),
                                        backgroundColor: Colors.blueAccent,
                                      ),
                                    ),
                                    Text(personText + index.toString()),
                                    Padding(
                                      padding: EdgeInsets.only(left: 140.0),
                                      child: IconButton(
                                        icon: iconPressed[index] == false ? Icon(CupertinoIcons.add_circled) : Icon(CupertinoIcons.clear_thick, color: Colors.green),
                                        onPressed: () {
                                          setState(() {
                                            iconPressed[index] = true;
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

  List<bool> iconPressed;
}
