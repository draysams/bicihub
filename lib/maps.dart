import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'statistics.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';


class MapsPage extends StatefulWidget {
  const MapsPage(
      {this.title, this.markerType});

  final String title;
  final String markerType;
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
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

  void _add() {
    List contextMarkers = parseTitle();
    for (var marker in contextMarkers) {
      int random = Random().nextInt(10);
      double xMarker = lastLatitude = marker['X'];
      double yMarker = lastLongitude = marker['Y'];
      markerId = MarkerId((marker['location_stand']));
      processedMarker = Marker(
        icon: BitmapDescriptor.fromAsset('assets/avatars' + random .toString()+ '.jpg'),
        markerId: markerId,
        position: LatLng(
          yMarker,
          xMarker,
      ),
      infoWindow: InfoWindow(title: markerId.toString(), snippet: '*'),
      onTap: () {
        //_onMarkerTapped(markerId);
      },
      );
      markers[markerId] = processedMarker;
      clients.add({
        'clientName': marker['location_stand'].toString(),
        'longitude': xMarker.toString(),
        'latitude': yMarker.toString(),
      });
    }

    setState(() {
      markers[markerId] = processedMarker;
      clientsToggle = true;
    });
}


  void initState() {
    super.initState();
    parseTitle();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
        _add();
      });
    });
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
        CameraPosition(target: LatLng(53.2937658, -6.4283791), zoom: 10.0))).then((val) {
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

  bool started = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //make first character capital and replace '_' with '  '
          title: Text('${widget.title}'[0].toUpperCase() + '${widget.title}'.substring(1).replaceAll('_', ' ')), 
        ),
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height - 180.0,
                    width: double.infinity,
                    child: mapToggle
                        ? GoogleMap(
                            onMapCreated: onMapCreated,
                            initialCameraPosition:  CameraPosition(
                              target: LatLng(53.2937658, -6.4283791),
                              zoom: 10.0
                            ),
                            markers: Set<Marker>.of(markers.values),
                                
                          )
                        : Center(
                            child: Text(
                            'Loading.. Please wait..',
                            style: TextStyle(fontSize: 20.0),
                          ))),
                !started ? Positioned(
                  top: MediaQuery.of(context).size.height - 350.0,
                  left: 60.0,
                  right: 60.0,
                  child: Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      child:  Dismissible(
                        key: ObjectKey(1),
                        child: Container(
                          child: Card(
                            color: Colors.blue,
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                   setState(() {
                                    started = true;
                                  });
                              },
                              child: Container(
                                width: 300,
                                height: 100,
                                child: Center(
                                  child: Text('Swipe to start trip',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          
                        },
                      ))): Positioned(
                  top: MediaQuery.of(context).size.height - 350.0,
                  left: 60.0,
                  right: 60.0,
                  child: Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      child:  Dismissible(
                        key: ObjectKey(1),
                        child: Container(
                          child: Card(
                            color: Colors.green,
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                   
                              },
                              child: Container(
                                width: 300,
                                height: 100,
                                child: Center(
                                  child: Text('Swipe to end trip',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            started = false;
                          });
                          Navigator.of(context).push(new CupertinoPageRoute<void>(
                            builder: (BuildContext context) =>  StatisticsPage(),
                          ));
                        },
                      ))),
                Positioned(
                    top: MediaQuery.of(context).size.height - 300.0,
                    left: 10.0,
                    child: Container(
                        height: 125.0,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(bottom: 15.0),
                                children: clients.map((element) {
                                  return clientCard(element);
                                }).toList(),
                              ))),
                resetToggle
                    ? Positioned(
                        top: MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.height -
                            50.0),
                        right: 15.0,
                        child: FloatingActionButton(
                          heroTag: "btn1",
                          onPressed: resetCamera,
                          mini: true,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.refresh),
                        ))
                    : Container(),
                resetToggle
                    ? Positioned(
                        top: MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.height -
                            50.0),
                        right: 60.0,
                        child: FloatingActionButton(
                          heroTag: "btnw",
                          onPressed: addBearing,
                          mini: true,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.rotate_left
                        ))
                    )
                    : Container(),
                resetToggle
                    ? Positioned(
                        top: MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.height -
                            50.0),
                        right: 110.0,
                        child: FloatingActionButton(
                          heroTag: "btn3",
                          onPressed: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MapsPage(
                                    title: 'Statistics',
                                  )),
                                );
                          },
                          mini: true,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.rotate_right)
                        ))
                    : Container()
              ],
            )
          ],
        ));
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
