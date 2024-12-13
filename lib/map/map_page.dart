import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:location/location.dart";

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();
  LatLng? _currentLocation;
  final Completer<GoogleMapController> _mapController = Completer();
  bool _firstTimeLocation = true;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  Future<void> _moveCameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition cameraPosition = CameraPosition(target: position, zoom: 18);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: 18,
                  ),
                  onCameraIdle: () {
                    if (_currentLocation != null) {
                      print('Current Location: $_currentLocation');
                    }
                  },
                  onCameraMove: (CameraPosition position) {
                    setState(() {
                      _currentLocation = position.target;
                    });
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                ),
          const Center(
            child: Icon(
              Icons.push_pin,
              size: 40,
              color: Colors.green,
            ),
          ),
          Positioned(
            bottom: 250,
            right: 0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              onPressed: () async {
                final locationData = await _locationController.getLocation();
                if (locationData.latitude != null &&
                    locationData.longitude != null) {
                  setState(() {
                    _currentLocation =
                        LatLng(locationData.latitude!, locationData.longitude!);
                  });

                  _moveCameraToPosition(_currentLocation!);
                }
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.my_location,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationController.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      Fluttertoast.showToast(
        msg: "Choose Precise Option in Location Permission",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 2,
      );
       await Future.delayed(Duration(milliseconds: 2000)); 
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        if (_firstTimeLocation) {
          setState(() {
            _currentLocation =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
          });
          _moveCameraToPosition(_currentLocation!);
          _firstTimeLocation = false;
        }
      }
    });
  }
}
