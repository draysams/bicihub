import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'model.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'menu.dart';

class MainPage extends StatefulWidget {
  const MainPage(
      {this.title, this.markerType});

  final String title;
  final String markerType;
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
          title: Text('Statistics',
          style: TextStyle(
            color: Colors.white,
          ),), 
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
      child:Column(
          children: 
            <Widget>[
              new Row(
              children: <Widget>[
                Padding(
                padding: EdgeInsets.only(left: 30.0, top: 35),
                child: CircleAvatar(
                radius: 20.0,
                backgroundImage: AssetImage('assets/avatars1.jpg'),
                backgroundColor: Colors.blueAccent,
              ),
            ),
              ],
            ),
              new Row(
              children: <Widget>[
                Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                    new Padding(
                    padding: EdgeInsets.only(left: 1.0, top: 20.0),
                    child: Text('Your position #5',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top:19.0),
                  child:Icon(Icons.arrow_upward, color: Colors.green)
                  )
                  
                  ]),
                  Row(
                        children: <Widget>[
                    new Padding(
                    padding: EdgeInsets.only(left: 15.0, top: 20.0),
                    child: Text('School position #9',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top:19.0),
                  child:Icon(Icons.arrow_downward, color: Colors.red)
                  )
                  
                  ]),
                    ]
                ),
                Padding(
                padding: EdgeInsets.only(left: 50.0, top: 10),
                child: CircleAvatar(
                radius: 80.0,
                backgroundImage:AssetImage('assets/activity2.jpg'),
                backgroundColor: Colors.blueAccent,
              ),
            ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: 140.0, top: 20.0),
                  child: Text('Your Stats',
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
                Row(
                  children: <Widget> [
                    Padding(
                      padding: EdgeInsets.only(left: 70.0, top: 50),
                      child: Text('Time Travelled',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 30.0, top: 50.0),
                      child: Text('5 h 28 m',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),),
                    )
                ],
                                ), 
              ],
            ),

            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: 70.0, top: 20.0),
                  child: Text('Top Speed',
                  style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 67.0, top: 20.0),
                  child: Text('23.3km/h',
                  style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),),
                )
              ],
            ),

            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: 70.0, top: 20.0),
                  child: Text('Time',
                  style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 120.0, top: 20.0),
                  child: Text('36 Minutes',
                  style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),),
                )
              ],
            ),

            Padding(
              padding: EdgeInsets.only(top: 190),
              child: CupertinoButton(
                color: Colors.green,
                child: Text('Start Journey',
                style: TextStyle(
                        color: Colors.white,
                      ),),
                onPressed: () {
                   Navigator.of(context).push(new CupertinoPageRoute<void>(
                    builder: (BuildContext context) => new JourneyPage()
                  ));
                },
              ),
            ),
          ],
        )));

  }

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
