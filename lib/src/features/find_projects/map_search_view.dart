import 'dart:async';
import 'dart:math';

import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/projects/widget/filter_drawer_widget.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/utils/googlemap_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapSearchView extends StatefulWidget {
  const MapSearchView({super.key});
  static const String routeName = '/map_search_view';

  @override
  State<MapSearchView> createState() => _MapSearchViewState();
}

class _MapSearchViewState extends State<MapSearchView> {
  late CameraPosition _initialCameraPosition;
  late StreamSubscription<bool> keyboardSubscription;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showResult = true;
  static final pinLocations = [
    const LatLng(13.7463, 100.5018), // Original pin
    const LatLng(13.7563, 100.5218), // ~10m north
    const LatLng(13.8663, 100.5018), // ~10m east
  ];

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print('Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        _showResult = !visible; // Update the state based on keyboard visibility
      });
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel(); // Cancel the subscription when the widget is disposed
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initialCameraPosition = GooglemapUtil.calculateCameraPosition(context, pinLocations, zoomFactor: 0.6);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context), // Dismiss the keyboard when tapping outside
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        endDrawer: const FilterDrawerWidget(),
        body: Stack(
          children: [
            _buildGoogleMap(),
            Align(
              alignment: Alignment.topCenter,
              child: _buildAppBar(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomResultList(),
            ),
          ],
        ),
      ),
    );
  }

  SafeArea _buildAppBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: mScreenEdgeInsetValue, horizontal: mScreenEdgeInsetValue),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
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
                      AppLocalizations.of(context)!.mapTitle,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey[800]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: mSmallPadding,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: CommonUtil.colorTheme(context, darkColor: mDarkCardBackgroundColor, lightColor: mLightCardBackgroundColor),
                      borderRadius: BorderRadius.circular(50.0), // Stadium shape
                    ),
                    child: TextField(
                      autofocus: false,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: mDefaultPadding),
                        suffixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        _doSearch(searchText: 'on submitted');
                        CommonUtil.dismissKeyboard(context); // Dismiss the keyboard when search is submitted
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: mMediumPadding,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CommonUtil.colorTheme(context, darkColor: mDarkCardBackgroundColor, lightColor: mLightCardBackgroundColor), // Background color of the circle
                  ),
                  child: IconButton(
                    onPressed: () {
                      CommonUtil.dismissKeyboard(context);
                      _scaffoldKey.currentState?.openEndDrawer(); // Open the drawer when the button is pressed
                    },
                    icon: const Icon(Icons.filter_list, color: mGreyColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  GoogleMap _buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: _initialCameraPosition,
      onTap: (argument) {
        CommonUtil.dismissKeyboard(context); // Dismiss the keyboard when tapping on the map
      },
      markers: pinLocations
          .map((location) => Marker(
                markerId: MarkerId(location.toString()),
                position: location,
                onTap: () {
                  showModalBottomSheet(
                    enableDrag: true,
                    barrierColor: Colors.transparent,
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
    );
  }

  Widget _buildBottomResultList() {
    return Offstage(
      offstage: !_showResult,
      child: Container(
        decoration: BoxDecoration(
          color: CommonUtil.colorTheme(context, darkColor: mDarkCardBackgroundColor, lightColor: mLightCardBackgroundColor).withOpacity(0.94),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.30,
        padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue, vertical: mDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: mSmallPadding),
              child: Center(
                child: Container(
                  width: 32,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.0), // Stadium shape
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: mDefaultPadding,
            ),
            Text('ผลการค้นหา : 3 รายการ', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(
              height: mSmallPadding,
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(top: 0, bottom: MediaQuery.of(context).padding.bottom),
                itemCount: 10, // Replace with your actual data count
                separatorBuilder: (context, index) => Divider(
                  color: mGreyColor.withOpacity(0.2),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.access_time),
                        const SizedBox(width: mDefaultPadding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ชื่อโครงการ $index', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
                              Text('ระยะทาง 10 กม.', style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                              Text('โคงการใหม่ | เริ่มต้น 1.69 ล้านบาท', style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              child: Transform.rotate(
                                angle: pi, // Rotate 180 degrees
                                child: const Icon(
                                  Icons.subdirectory_arrow_left_sharp,
                                  size: 15,
                                  color: mBrightPrimaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: mSmallPadding),
                            Text('25.7 กม.', style: Theme.of(context).textTheme.labelSmall!.copyWith(color: mBrightPrimaryColor)),
                          ],
                        )
                      ],
                    ), // Replace with your actual data
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _doSearch({String? searchText}) {
    print('do search with text: $searchText');
  }
}
