import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({super.key, required this.location});
  final ProjectLocation location;

  @override
  Widget build(BuildContext context) {
    final pinLocations = [LatLng(location.latitude, location.longitude)];
    final initialCameraPosition = CameraPosition(
      target: pinLocations[0],
      zoom: 15,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.projectDetailMapTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: mSmallPadding),
          AspectRatio(
            aspectRatio: 22 / 9,
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: GoogleMap(
                zoomControlsEnabled: false,
                zoomGesturesEnabled: false,
                scrollGesturesEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                initialCameraPosition: initialCameraPosition,
                onTap: (argument) {
                  // _navigateToDestination(argument.latitude, argument.longitude);
                },
                markers: pinLocations
                    .map((location) => Marker(
                          markerId: MarkerId(location.toString()),
                          position: location,
                        ))
                    .toSet(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> _navigateToDestination(double lat, double lng) async {
  //   final Uri url = Platform.isIOS ? Uri.parse('http://maps.apple.com/?daddr=$lat,$lng&dirflg=d') : Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');

  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'ไม่สามารถเปิดแผนที่นำทางได้';
  //   }
  // }
}
