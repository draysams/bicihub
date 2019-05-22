import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'model.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage(
      {this.title, this.markerType});

  final String title;
  final String markerType;
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
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
          //make first character capital and replace '_' with '  '
          title: Text('Statistics'), 
        ),
        body: Column(
          children: 
            <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 35),
            child: CircleAvatar(
                radius: 90.0,
                backgroundImage:
                    NetworkImage("https://banner2.kisspng.com/20180403/cuw/kisspng-trophy-computer-icons-prize-gold-medal-prize-5ac3ed9941a138.2167077015227897852688.jpg"),
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
                  ),),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: 50.0, top: 20.0),
                  child: Text('Distance Covered',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 30.0, top: 20.0),
                  child: Text('30,000 KM',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),),
                )
              ],
            ),

            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: 50.0, top: 20.0),
                  child: Text('Saved Trees'),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 136.0, top: 20.0),
                  child: Text('3x'),
                )
              ],
            ),

            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: 50.0, top: 20.0),
                  child: Text('Time '),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 180.0, top: 20.0),
                  child: Text('36 Minutes'),
                )
              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: 44.0, top: 20.0),
            child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left:10.0),
                      child: Text(
                        "Notify parents?"
                      ),),
                      Padding(
                        padding: EdgeInsets.only(left: 110.0),
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
              padding: EdgeInsets.only(top: 200),
              child: CupertinoButton(
                color: Colors.green,
                child: Text('Done'),
                onPressed: () {

                },
              ),
            ),
          ],
        ));

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
