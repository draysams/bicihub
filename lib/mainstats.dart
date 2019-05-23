import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'model.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MainStats extends StatefulWidget {
  const MainStats(
      {this.title, this.markerType});

  final String title;
  final String markerType;
  @override
  _MainStatsState createState() => _MainStatsState();
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

var data = [
  new ClicksPerYear('2016', 12, Colors.red),
  new ClicksPerYear('2017', 42, Colors.yellow),
  new ClicksPerYear('2018', 32, Colors.green),
];

var series = [
  new charts.Series(
    id: 'Clicks',
    domainFn: (ClicksPerYear clickData, _) => clickData.year,
    measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
    colorFn: (ClicksPerYear clickData, _) => clickData.color,
    data: data,
  ),
];

var chart = new charts.BarChart(
  series,
  animate: true,
);
var chartWidget = new Padding(
  padding: new EdgeInsets.all(32.0),
  child: new SizedBox(
    height: 200.0,
    child: chart,
  ),
);

class _MainStatsState extends State<MainStats> {
  bool mapToggle = true;
  bool clientsToggle = true;
  bool resetToggle = false;

  String pageTitle;

  Position currentLocation;

  var clients = [];

  double lastLatitude;
  double lastLongitude;
  var currentClient;
  var currentBearing;

  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{

  };

  Marker processedMarker;
  MarkerId markerId;

  List parseTitle() {
    List markers;

    if ('${widget.title}' == 'car_parking' || '${widget.title}' == 'all_car_parks') {
      markers = carParkingJson;
    } else if ('${widget.title}' == 'disabled_parking') {
      markers = disabledParkingJson;
    } else if ('${widget.title}' == 'charging_points') {
    } else if ('${widget.title}' == 'maintenance') {
    } else if ('${widget.title}' == 'bike_parking') {
      markers = bikeJsonMarkers;
    } else if ('${widget.title}' == 'nearest_car_park') {
      markers = carParkingJson[0];
    } else if ('${widget.title}' == 'nearest_charge_point') {
      pageTitle = 'Charging Points';
    } else {

    }

    return markers;
  }


  void initState() {
    super.initState();
  }

  Widget clientCard(client) {
    return Padding(
        padding: EdgeInsets.only(left: 2.0, top: 10.0),
        child: GestureDetector(
            onTap: () {
              setState(() {
                currentClient = client;
                currentBearing = 90.0;
              });
              zoomInMarker(client);
            },
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                  height: 100.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                    client['clientName'],
                    textAlign: TextAlign.center))),
            )));
  }

  zoomInMarker(client) {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
                double.parse(client['latitude']), double.parse(client['longitude'])),
            zoom: 17.0,
            bearing: 90.0,
            tilt: 45.0)))
        .then((val) {
      setState(() {
        resetToggle = true;
      });
    });
  }

  resetCamera() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 10.0))).then((val) {
             setState(() {
                     resetToggle = false;
             });
        });
  }

  addBearing() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(double.parse(currentClient['latitude']), 
        double.parse(currentClient['longitude'])
        ),
        bearing: currentBearing == 360.0 ? currentBearing : currentBearing + 90.0,
        zoom: 17.0,
        tilt: 45.0
      )
    )
      ).then((val) {
        setState(() {
        if(currentBearing == 360.0) {}
        else {
          currentBearing = currentBearing + 90.0;
        }
      });
    });
  }

    removeBearing() {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(double.parse(currentClient['latitude']), 
          double.parse(currentClient['longitude'])
        ),
        bearing: currentBearing == 0.0 ? currentBearing : currentBearing - 90.0,
        zoom: 17.0,
        tilt: 45.0
      )
      )
      ).then((val) {
        setState(() {
          if(currentBearing == 0.0) {}
          else {
            currentBearing = currentBearing - 90.0;
          }
        });
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Statistics'), 
          flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  const Color(0xFF3366FF),
                  const Color(0xFF00CCFF),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        ),
        body: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(colors: [Colors.blue[800], Colors.green[600]],
                begin: const FractionalOffset(0.5, 0.0),
                end: const FractionalOffset(0.0, 0.5),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp
            ),
          ),
          child: Column(
          children: 
            <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 35),
            child: CircleAvatar(
                radius: 90.0,
                backgroundImage:AssetImage('assets/trophy2.jpg'),
                backgroundColor: Colors.blueAccent,
              ),
            ),

            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: 180.0, top: 20.0),
                  child: Text('My Trip',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                    color: Colors.white,
                  ),),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: 70.0, top: 20.0),
                  child: Text('Distance Covered',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 50.0, top: 20.0),
                  child: Text('6.78 KM',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),),
                )
              ],
            ),

            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: 70.0, top: 20.0),
                  child: Text('Saved Trees',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 90.0, top: 20.0),
                  child: Text('3x',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),),
                )
              ],
            ),

            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: 70.0, top: 20.0),
                  child: Text('Time ',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 135.0, top: 20.0),
                  child: Text('36 Minutes',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),),
                )
              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: 65.0, top: 10.0),
            child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left:8.0),
                      child: Text(
                        "Notify parents?",
                        style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                      ),),
                      Padding(
                        padding: EdgeInsets.only(left: 70.0),
                      child: CupertinoSwitch(
                        value: _switchValue,
                        onChanged: (bool value) {
                          setState(() {
                            _switchValue = value;
                          });
                        },
                      ),
                      ),
                    ],
                  ),
            ),
            Padding(
              padding: EdgeInsets.only(left:8.0, top: 70),
              child: Center(
                child: Text(
                "Hoooray!!, You have travelled around \nPheonix Park twice",
                textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: 15.0,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
              ),),),
            Padding(
              padding: EdgeInsets.only(top: 120),
              child: CupertinoButton(
                color: Colors.green,
                child: Text('Done',
                style: TextStyle(
                  color: Colors.white,
                ),),
                onPressed: () {

                },
              ),
            ),
          ],
        )));

  }
  bool _switchValue = false;

  void onMapCreated(controller) {
    resetToggle = true;
    setState(() {
      mapController = controller;
      Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
      });
    });
    });
  }
}
