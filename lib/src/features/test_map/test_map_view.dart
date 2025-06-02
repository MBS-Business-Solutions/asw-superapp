import 'dart:math';

import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestGoogleMap extends StatefulWidget {
  const TestGoogleMap({super.key});

  @override
  State<TestGoogleMap> createState() => _TestGoogleMapState();
}

class _TestGoogleMapState extends State<TestGoogleMap> {
  late CameraPosition _initialCameraPosition;

  static final pinLocations = [
    const LatLng(13.7463, 100.5018), // Original pin
    const LatLng(13.7563, 100.5018), // ~10m north
    const LatLng(13.8663, 100.5018), // ~10m east
  ];

  static final CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(
      pinLocations.map((e) => e.latitude).reduce((a, b) => a + b) / pinLocations.length,
      pinLocations.map((e) => e.longitude).reduce((a, b) => a + b) / pinLocations.length,
    ),
    zoom: 0, // Will be calculated dynamically
  );

  @override
  void initState() {
    super.initState();
  }

  CameraPosition _calculateCameraPosition() {
    double minLat = pinLocations[0].latitude;
    double maxLat = pinLocations[0].latitude;
    double minLng = pinLocations[0].longitude;
    double maxLng = pinLocations[0].longitude;

    for (LatLng location in pinLocations) {
      minLat = min(minLat, location.latitude);
      maxLat = max(maxLat, location.latitude);
      minLng = min(minLng, location.longitude);
      maxLng = max(maxLng, location.longitude);
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    LatLng center = LatLng(
      (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
      (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
    );

    double zoom = _calculateZoom(bounds);

    return CameraPosition(
      target: center,
      zoom: zoom,
    );
  }

  double _calculateZoom(LatLngBounds bounds) {
    const double globeWidth = 256; // a magic number from Google Maps API
    double angle = max(
      bounds.northeast.longitude - bounds.southwest.longitude,
      bounds.northeast.latitude - bounds.southwest.latitude,
    );

    return (log(MediaQuery.of(context).size.width * 0.6 * 360 / globeWidth / angle) / log(2));
  }

  @override
  Widget build(BuildContext context) {
    _initialCameraPosition = _calculateCameraPosition();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: pinLocations
                .map((location) => Marker(
                      markerId: MarkerId(location.toString()),
                      position: location,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Location: ${location.latitude}, ${location.longitude}',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        );
                      },
                    ))
                .toSet(),
          ),
          Positioned.fill(
              child: IgnorePointer(
            child: Image.asset('assets/images/Background.png', fit: BoxFit.fill),
          )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Stack(
                  children: [
                    IconButton(
                      icon: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white, // Background color of the circle
                        ),
                        child: const Icon(
                          Icons.close_sharp,
                          color: mGreyColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Positioned.fill(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'แผนที่',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
