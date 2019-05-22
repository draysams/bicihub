// Copyright 2017 The Chromium ors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;
import 'dart:convert';
import 'journey.dart';
import 'statistics.dart';
import 'mainpage.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import 'WeatherData.dart';
import 'ForecastData.dart';
import 'WeatherItem.dart';
import 'package:http/http.dart' as http;

import 'swide_widget.dart';

import 'fireSymptomDatabase.dart';

import 'chatScreen3.dart';

const List<Color> coolColors = const <Color>[
  const Color.fromARGB(255, 255, 59, 48),
  const Color.fromARGB(255, 255, 149, 0),
  const Color.fromARGB(255, 255, 204, 0),
  const Color.fromARGB(255, 76, 217, 100),
  const Color.fromARGB(255, 90, 200, 250),
  const Color.fromARGB(255, 0, 122, 255),
  const Color.fromARGB(255, 88, 86, 214),
  const Color.fromARGB(255, 255, 45, 85),
];

const List<String> coolColorNames = const <String>[
  'Sarcoline',
  'Coquelicot',
  'Smaragdine',
  'Mikado',
  'Glaucous',
  'Wenge',
  'Fulvous',
  'Xanadu',
  'Falu',
  'Eburnean',
  'Amaranth',
  'Australien',
  'Banan',
];



WeatherData weatherData;
ForecastData forecastData;

class Menu extends StatefulWidget {
  const Menu({this.colorItems, this.colorNameItems});

  final List<Color> colorItems;
  final List<String> colorNameItems;

  @override
  State createState() => new MenuState();
}

class MenuState extends State<Menu> {
  MenuState()
      : colorItems = new List<Color>.generate(50, (int index) {
          return coolColors[new math.Random().nextInt(coolColors.length)];
        }),
        colorNameItems = new List<String>.generate(50, (int index) {
          return coolColorNames[
              new math.Random().nextInt(coolColorNames.length)];
        });

  static const String routeName = '/cupertino/navigation';
  final List<Color> colorItems;
  final List<String> colorNameItems;

  StreamSubscription _subscriptionSession;

  List<FireSymptomQuery> sessions = new List<FireSymptomQuery>();
  List<String> pageNames = new List<String>();
  List<String> commonNames = new List<String>();
  List<String> probabilities = new List<String>();
  List<dynamic> evidences = new List<dynamic>();

  String currentUser = 'Dray';
  String currentUserId = '';
  String currentUserName = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  @override
  void dispose() {
    super.dispose();
    if (_subscriptionSession != null) {
      _subscriptionSession.cancel();
    }
  }

  loadWeather() async {
    setState(() {
      isLoading = true;
    });

    final weatherResponse = await http.get('https://api.openweathermap.org/data/2.5/weather?APPID=37829923901ea24f5abf53667954abe0&lat=53.293769&lon=-6.4283791&units=metric');
    final forecastResponse = await http.get('https://api.openweathermap.org/data/2.5/forecast?APPID=37829923901ea24f5abf53667954abe0&lat=-6.4283791&lon=-6.4283791&units=metric');

    // if (weatherResponse.statusCode == 200 &&
    //     forecastResponse.statusCode == 200) {
      return setState(() {
        weatherData = new WeatherData.fromJson(jsonDecode(weatherResponse.body));
        forecastData = new ForecastData.fromJson(jsonDecode(forecastResponse.body));
        isLoading = false;
      });
  }

  static const IconData statistics = IconData(
  0xf2b5, 
  fontFamily: CupertinoIcons.iconFont, 
  fontPackage: CupertinoIcons.iconFontPackage);
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      // Prevent swipe popping of this page. Use explicit exit buttons only.
      //onWillPop: () => new Future<bool>.value(true),
      onWillPop: () async => false,
      child: new CupertinoTabScaffold(
        tabBar: new CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.home),
              title: const Text('Home'),
            ),
            const BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.person_add),
              title: const Text('Groups'),
            ),
            const BottomNavigationBarItem(
              icon: Icon(statistics),
              title: const Text('Statistics'),
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return new DefaultTextStyle(
            style: const TextStyle(
              fontFamily: '.SF UI Text',
              fontSize: 17.0,
              color: CupertinoColors.black,
            ),
            child: new CupertinoTabView(
              builder: (BuildContext context) {
                switch (index) {
                  case 0:
                    return new HomeTab(
                      evidences: evidences,
                      colorItems: colorItems,
                      pageNames: pageNames,
                      commonNames: commonNames,
                      probabilities: probabilities,
                      currentUserName: currentUserName,
                      colorNameItems: colorNameItems,
                    );
                    break;
                  case 1:
                    return new ClinibotTab();
                    break;
                  case 2:
                    return new MainPage();
                    break;
                  default:
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class ExitButton extends StatelessWidget {
  const ExitButton();
  @override
  Widget build(BuildContext context) {
    return new CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Tooltip(
        message: 'Back',
        child: const Text('Sign Out'),
        excludeFromSemantics: true,
      ),
      onPressed: () {
        // The demo is on the root navigator.
        Navigator.of(context).pushNamed('/chatScreen');
        //Navigator.of(context, rootNavigator: true).pop();
      },
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab(
      {this.colorItems,
      this.colorNameItems,
      this.pageNames,
      this.commonNames,
      this.probabilities,
      this.currentUserName,
      this.evidences});

  final String currentUserName;
  final List<Color> colorItems;
  final List<String> pageNames;
  final List<dynamic> evidences;
  final List<String> commonNames;
  final List<String> probabilities;
  final List<String> colorNameItems;

  @override
  State createState() => new HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  static final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  final List<String> images = [
    "assets/wallpaper-1.jpeg",
    "assets/wallpaper-2.jpeg",
    "assets/wallpaper-3.jpeg",
    "assets/wallpaper-4.jpeg",
  ];

  final List<String> title = [
    "CARPOOL",
    "FORUMS",
    "INFO",
    "PLANNER",
  ];

  final List<String> subTitle = [
    "Share a ride",
    "Inform and be informed",
    "Get from A to B on time",
    "Mix and match vehicles",
  ];

  String camelCase(String text) {
    return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final MediaQueryData mediaQueryData = MediaQuery.of(context);
    //final double iconWidth = (mediaQueryData.size.width / 2) - 30;
    bool loaded = widget.pageNames.length > 0;
    String user = widget.currentUserName;
    String userTitle = user;
    int spaceIndex = widget.currentUserName.indexOf(' ');
    if (spaceIndex > 2) {
      userTitle = user.substring(0, spaceIndex);
    }

    Widget scrollView = CustomScrollView(
            slivers: <Widget>[
              new CupertinoSliverNavigationBar(
                largeTitle: new Text("$userTitle Blink"),
              ),
              new SliverPadding(
                // Top media padding consumed by CupertinoSliverNavigationBar.
                // Left/Right media padding consumed by Tab1RowItem.
                padding: MediaQuery
                    .of(context)
                    .removePadding(
                      removeTop: true,
                      removeLeft: true,
                      removeRight: true,
                    )
                    .padding,
                sliver: new SliverList(
                  delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return new Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Column(
                          children: <Widget>[
                             Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text('Where to?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: GestureDetector( 
                                onTap: () {
                                  Navigator.of(context).push(new CupertinoPageRoute<void>(
                                    builder: (BuildContext context) => new JourneyPage()
                                  ));
                                },
                                child: Image(
                                image: new AssetImage("assets/school.png"),
                                width: 400,
                                height: 170.0,
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                              )
                            )),
                            Padding(
                              padding: EdgeInsets.only(top:20.0, bottom: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(new CupertinoPageRoute<void>(
                                    builder: (BuildContext context) => new JourneyPage()
                                  ));
                                },
                                child: Image(
                                image: new AssetImage("assets/home.png"),
                                width: 400,
                                height: 170.0,
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                              )
                            )),

                            forecastData != null ? Container(
                              child: Container(
                                  height: 200.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                itemCount: forecastData.list.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => WeatherItem(weather: forecastData.list.elementAt(index))
                                ))): Container(),
                          ],
                          
                        ),  
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ),
            ],
          );

    //print(widget.evidences[0][0]['question']);
    var timeout = const Duration(seconds: 7);

    getMessage() async {
      setState(() {
        loaded = widget.pageNames.length > 0;
      });
      return new Future.delayed(
          timeout,
          () =>
              'Transfeed could not load any data please go online and chat with transfeed.');
    }

    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await getMessage(),
      //renderLoad: () => new Center(child: new CupertinoActivityIndicator()),
      renderLoad: () => new CustomScrollView(
            slivers: <Widget>[
              new CupertinoSliverNavigationBar(
                largeTitle: new Text("$userTitle Transfeed"),
                trailing: const ExitButton(),
              ),
              new SliverPadding(
                // Top media padding consumed by CupertinoSliverNavigationBar.
                // Left/Right media padding consumed by Tab1RowItem.
                padding: MediaQuery
                    .of(context)
                    .removePadding(
                      removeTop: true,
                      removeLeft: true,
                      removeRight: true,
                    )
                    .padding,
                sliver: new SliverList(
                  delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return new Padding(
                        padding: new EdgeInsets.symmetric(vertical: 250.0),
                        child: new CupertinoActivityIndicator(),
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ),
            ],
          ),
      renderError: ([error]) =>
          scrollView,
      renderSuccess: ({data}) => scrollView,
    );

    return new CupertinoPageScaffold(
      child: !loaded
          ? _asyncLoader
          : new CustomScrollView(
              slivers: <Widget>[
                new CupertinoSliverNavigationBar(
                  largeTitle: new Text("$userTitle Transfeed"),
                ),
                new SliverPadding(
                  // Top media padding consumed by CupertinoSliverNavigationBar.
                  // Left/Right media padding consumed by Tab1RowItem.
                  padding: MediaQuery
                      .of(context)
                      .removePadding(
                        removeTop: true,
                        removeLeft: true,
                        removeRight: true,
                      )
                      .padding,
                  sliver: widget.pageNames.length > 0
                      ? new SliverList(
                          delegate: new SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return new Tab1RowItem(
                                index: index,
                                lastItem: index == widget.pageNames.length - 1,
                                color: widget.colorItems[index],
                                pageName: widget.pageNames[index],
                                commonName: widget.commonNames[index],
                                probability: widget.probabilities[index],
                                evidences: widget.evidences[index],
                              );
                            },
                            childCount: widget.pageNames.length,
                          ),
                        )
                      : new SliverList(
                          delegate: new SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return new Padding(
                                padding:
                                    new EdgeInsets.symmetric(vertical: 230.0),
                                child: new Padding(
                                  padding: new EdgeInsets.all(20.0),
                                  child: new Center(
                                    child: new Text(
                                      'Transfeed could not load any data please go online and chat with transfeed.',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: 1,
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class Tab1RowItem extends StatelessWidget {
  const Tab1RowItem(
      {this.index,
      this.lastItem,
      this.color,
      this.pageName,
      this.commonName,
      this.probability,
      this.evidences});

  final int index;
  final bool lastItem;
  final Color color;
  final String pageName;
  final String commonName;
  final String probability;
  final List<dynamic> evidences;

  @override
  Widget build(BuildContext context) {
    final Widget row = new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(new CupertinoPageRoute<void>(
              builder: (BuildContext context) => new Tab1ItemPage(
                    color: color,
                    pageName: pageName,
                    commonName: commonName,
                    evidences: evidences,
                    index: index,
                    probability: probability,
                  ),
            ));
      },
      child: new SafeArea(
        top: false,
        bottom: false,
        child: new Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 8.0, bottom: 8.0, right: 8.0),
          child: new Row(
            children: <Widget>[
              new Container(
                child: new Text(
                  '$probability',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                height: 60.0,
                width: 60.0,
                padding: new EdgeInsets.only(top: 20.0),
                decoration: new BoxDecoration(
                  color: color,
                  borderRadius: new BorderRadius.circular(8.0),
                ),
              ),
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(pageName),
                      const Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 1.0)),
                      new Text(
                        commonName.toUpperCase(),
                        style: const TextStyle(
                          color: const Color(0xFF8E8E93),
                          fontSize: 13.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.share,
                  color: CupertinoColors.activeBlue,
                  semanticLabel: 'Share',
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    if (lastItem) {
      return row;
    }

    return new Column(
      children: <Widget>[
        row,
        new Container(
          height: 1.0,
          color: const Color(0xFFD9D9D9),
        ),
      ],
    );
  }
}

class Tab1ItemPage extends StatefulWidget {
  const Tab1ItemPage(
      {this.color,
      this.pageName,
      this.index,
      this.evidences,
      this.commonName,
      this.probability});

  final Color color;
  final String pageName;
  final int index;
  final List<dynamic> evidences;
  final String commonName;
  final String probability;

  @override
  State<StatefulWidget> createState() => new Tab1ItemPageState();
}

String mapsPageTitle = '';
String mapsPageMarkers = '';
class Tab1ItemPageState extends State<Tab1ItemPage> {
  @override
  void initState() {
    super.initState();
    relatedColors = new List<Color>.generate(10, (int index) {
      final math.Random random = new math.Random();
      return new Color.fromARGB(
        255,
        (widget.color.red + random.nextInt(100) - 50).clamp(0, 255),
        (widget.color.green + random.nextInt(100) - 50).clamp(0, 255),
        (widget.color.blue + random.nextInt(100) - 50).clamp(0, 255),
      );
    });
  }

  List<Color> relatedColors;

  @override
  Widget build(BuildContext context) {
    return new CupertinoPageScaffold(
      navigationBar: new CupertinoNavigationBar(
        middle: new Text(widget.pageName),
      ),
      child: new SafeArea(
        top: false,
        bottom: false,
        child: new ListView(
          children: <Widget>[
            const Padding(padding: const EdgeInsets.only(top: 16.0)),
            new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Container(
                    child: new Text(
                      '${widget.probability} pools',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    padding: new EdgeInsets.only(top: 50.0),
                    height: 128.0,
                    width: 128.0,
                    decoration: new BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: new BorderRadius.circular(24.0),
                    ),
                  ),
                  const Padding(padding: const EdgeInsets.only(left: 18.0)),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text(
                          widget.pageName,
                          style: const TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        const Padding(padding: const EdgeInsets.only(top: 6.0)),
                        new Text(
                          '${widget.commonName}'.toUpperCase(),
                          style: const TextStyle(
                            color: const Color(0xFF8E8E93),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        const Padding(
                            padding: const EdgeInsets.only(top: 20.0)),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                            ),
                            new CupertinoButton(
                              color: CupertinoColors.activeBlue,
                              minSize: 30.0,
                              padding: EdgeInsets.zero,
                              borderRadius: new BorderRadius.circular(32.0),
                              child: const Icon(CupertinoIcons.ellipsis,
                                  color: CupertinoColors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 28.0, bottom: 8.0),
              child: const Text(
                'INFO',
                style: const TextStyle(
                  color: const Color(0xFF646464),
                  letterSpacing: -0.60,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            new SizedBox(
              height: 600.0,
              child: new ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 10,
                  itemExtent: 160.0,
                  itemBuilder: (BuildContext context, int index) {
                    return new FXLeftSlide(
                      buttons: <FXRightSideButton>[
                        new FXRightSideButton(
                          name: 'GO',
                          onPress: () {},
                          backgroudColor:
                              'present' ==
                                      'present'
                                  ? CupertinoColors.activeGreen
                                  : CupertinoColors.destructiveRed,
                        ),
                      ],
                      child: new Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, bottom: 16.0, right: 16.0),
                        child: new Container(
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(8.0),
                            color: relatedColors[index],
                          ),
                          child: new Column(children: [
                            new Padding(
                              padding: new EdgeInsets.only(
                                  top: 15.0, left: 5.0),
                              child: GestureDetector(
                                onTap: () {
                                  //   );
                                },
                                child: Row(
                                children: <Widget> [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: CircleAvatar(
                                      radius: 60.0,
                                      backgroundImage:
                                          NetworkImage("http://assets.gcstatic.com/u/apps/asset_manager/uploaded/2015/03/businessman-on-phones-1421860994-custom-0.jpg"),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'Samuel Davies',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        letterSpacing: -0.60,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      'Going to Saggart from SAP',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ), 
                              ],), 
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class ClinibotTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: const Text('St. Mary\'s'),
        ),
        child: new ChatScreen()
        );
  }
}

class JourneyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: const Text('Choose Friends'),
        ),
        child: new JourneyScreen()
        );
  }
}

enum Tab2ConversationBubbleColor {
  blue,
  gray,
}

class Tab2ConversationBubble extends StatelessWidget {
  const Tab2ConversationBubble({this.text, this.color});

  final String text;
  final Tab2ConversationBubbleColor color;

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: const BorderRadius.all(const Radius.circular(18.0)),
        color: color == Tab2ConversationBubbleColor.blue
            ? CupertinoColors.activeBlue
            : CupertinoColors.lightBackgroundGray,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      child: new Text(
        text,
        style: new TextStyle(
          color: color == Tab2ConversationBubbleColor.blue
              ? CupertinoColors.white
              : CupertinoColors.black,
          letterSpacing: -0.4,
          fontSize: 14.0,
          fontWeight: color == Tab2ConversationBubbleColor.blue
              ? FontWeight.w300
              : FontWeight.w400,
        ),
      ),
    );
  }
}

class Tab2ConversationAvatar extends StatelessWidget {
  const Tab2ConversationAvatar({this.text, this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        gradient: new LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: <Color>[
            color,
            new Color.fromARGB(
              color.alpha,
              (color.red - 60).clamp(0, 255),
              (color.green - 60).clamp(0, 255),
              (color.blue - 60).clamp(0, 255),
            ),
          ],
        ),
      ),
      margin: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      child: new Text(
        text,
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class Tab2ConversationRow extends StatelessWidget {
  const Tab2ConversationRow({this.avatar, this.text});

  final Tab2ConversationAvatar avatar;
  final String text;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    if (avatar != null) children.add(avatar);

    final bool isSelf = avatar == null;
    children.add(
      new Tab2ConversationBubble(
        text: text,
        color: isSelf
            ? Tab2ConversationBubbleColor.blue
            : Tab2ConversationBubbleColor.gray,
      ),
    );
    return new SafeArea(
      child: new Row(
        mainAxisAlignment:
            isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isSelf ? CrossAxisAlignment.center : CrossAxisAlignment.end,
        children: children,
      ),
    );
  }
}

class Tab3Dialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new CupertinoPageScaffold(
      navigationBar: new CupertinoNavigationBar(
        leading: new CupertinoButton(
          child: const Text('Cancel'),
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ),
      child: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              CupertinoIcons.profile_circled,
              size: 160.0,
              color: const Color(0xFF646464),
            ),
            const Padding(padding: const EdgeInsets.only(top: 18.0)),
            new CupertinoButton(
              color: CupertinoColors.activeBlue,
              child: const Text('Sign in'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
