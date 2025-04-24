import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GooglemapUtil {
  static CameraPosition calculateCameraPosition(BuildContext context, List<LatLng> pinLocations, {double zoomFactor = 0.6}) {
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

    double zoom = min(_calculateZoom(context, bounds, zoomFactor), 19);

    return CameraPosition(
      target: center,
      zoom: zoom,
    );
  }

  static _calculateZoom(BuildContext context, LatLngBounds bounds, double zoomFactor) {
    const double globeWidth = 256; // a magic number from Google Maps API
    double angle = max(
      bounds.northeast.longitude - bounds.southwest.longitude,
      bounds.northeast.latitude - bounds.southwest.latitude,
    );

    return (log(MediaQuery.of(context).size.width * zoomFactor * 360 / globeWidth / angle) / log(2));
  }

  static double calculateDistance(LatLng start, LatLng end) {
    const double R = 6371e3; // meters
    double lat1 = start.latitude * (pi / 180);
    double lat2 = end.latitude * (pi / 180);
    double deltaLat = (end.latitude - start.latitude) * (pi / 180);
    double deltaLon = (end.longitude - start.longitude) * (pi / 180);

    double a = sin(deltaLat / 2) * sin(deltaLat / 2) + cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // in meters
  }

  static double calculateDistanceInKm(LatLng start, LatLng end) {
    return calculateDistance(start, end) / 1000; // convert to kilometers
  }

  static Future<void> openGoogleMap(double lat, double lng) async {
    final googleMapUrl = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving");

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Google Maps';
    }
  }
}
