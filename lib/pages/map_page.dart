import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:location/location.dart";

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();
  static const LatLng current = LatLng(10.785635464267408, 78.73486462147547);
  LatLng? _currentP;
  final Completer<GoogleMapController> _mapController = Completer();
  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const SafeArea(child: Center(child: Text("Loading")))
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              initialCameraPosition:
                  const CameraPosition(target: current, zoom: 18),
              markers: {
                Marker(
                    markerId: const MarkerId("current"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _currentP!),
              },
            ),
    );
  }

  Future<void> camerPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition cameraPosition = CameraPosition(target: pos, zoom: 18);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }
    permissionGranted = await _locationController.requestPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationController.onLocationChanged.listen(
      (LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(() {
            _currentP =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            camerPosition(_currentP!);
          });
        }
      },
    );
  }
}
