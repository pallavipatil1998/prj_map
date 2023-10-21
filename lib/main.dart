import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  late GoogleMapController _mapController;
  late LatLng _currentLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkBeforeGettingLocation();
  }

  var initPos=CameraPosition(target: LatLng(21.0298849,75.5350794),zoom: 10);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map"),),

      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
        },
        onTap: (location) {
          print("Location: ${location.latitude},${location.longitude}");
        },
        // initialCameraPosition: initPos,

        initialCameraPosition: _currentLocation != null
            ? CameraPosition(target: _currentLocation, zoom: 15)
            : initPos,
        markers: _currentLocation == null
            ? {} // No markers if current location is not available
            : {

          Marker(
            markerId: MarkerId("currentLocation"),
            position: _currentLocation,
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: "Current Location"),
          ),

        Marker(markerId: MarkerId("1"),
          position: LatLng(19.0826068,72.5514993),
          infoWindow: InfoWindow(
            title: "Mumbai"
          ),
          icon: BitmapDescriptor.defaultMarker,


          
        ),
          Marker(markerId: MarkerId("1"),
            position: LatLng(18.5248706,73.6981483),
            infoWindow: InfoWindow(
              title: "Pune",
            ),
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              print("taped on marker");
            },



          ),
          Marker(markerId: MarkerId("1"),
            position: LatLng(19.9911053,73.7210774),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: "Nasik"
            ),
            onTap: () {
              print("taped on marker");
            },



          ),
          Marker(markerId: MarkerId("1"),
            position: LatLng(23.0205342,72.2500582),
            infoWindow: InfoWindow(
              title: "Aehmdabad"
            ),
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              print("taped on marker");
            },



          ),
          Marker(markerId: MarkerId("1"),
            position: LatLng(22.724205,75.6990314),
            infoWindow: InfoWindow(
              title: "Indore"
            ),
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              print("taped on marker");
            },



          )
        },
      )
    );
  }


  void checkBeforeGettingLocation()async{
    bool servicedEnabled;
    LocationPermission permission;

    servicedEnabled=await Geolocator.isLocationServiceEnabled();

    if(!servicedEnabled){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enable Location Services!!!")));
    }else{
      //GPS is on
      permission=await Geolocator.checkPermission();
      if(permission==LocationPermission.denied){
        permission=await Geolocator.requestPermission();
        if(permission==LocationPermission.denied){
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please allow app to request your current location")));
        }else if(permission== LocationPermission.deniedForever){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You\'ve denied this permission forever, therfore you wont be able to access this particular feature!!")));
        }else{
          getCurrentLocation();
          // getContinousLocation();

        }
      }else{
        getCurrentLocation();
        // getContinousLocation();

      }

    }
  }


  void getCurrentLocation()async{
    var pos= await Geolocator.getCurrentPosition();
    print("Location: ${pos.latitude},${pos.longitude}");
    setState(() {
      _currentLocation = LatLng(pos.latitude, pos.longitude);
    });

  }

  void getContinousLocation(){

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
      timeLimit: Duration(seconds: 20)
    );
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) {
          print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
        });
  }

}


