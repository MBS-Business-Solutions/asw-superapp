import 'dart:async';
import 'dart:math';

import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/find_projects/widgets/map_search_result_widget.dart';
import 'package:AssetWise/src/features/projects/widget/filter_drawer_widget.dart';
import 'package:AssetWise/src/features/projects/widget/filter_outline_button.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/project_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/utils/googlemap_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MapSearchView extends StatefulWidget {
  const MapSearchView({super.key, required this.textController});
  static const String routeName = '/map_search_view';
  final TextEditingController textController; // Moved to the class level

  @override
  State<MapSearchView> createState() => _MapSearchViewState();
}

class _MapSearchViewState extends State<MapSearchView> {
  List<ProjectSearchItem> _searchResults = []; // List to hold search results
  CameraPosition? _initialCameraPosition;
  late StreamSubscription<bool> keyboardSubscription;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showResult = true;
  final Set<Marker> pinLocations = {};
  late ProjectProvider _projectProvider;
  GoogleMapController? _mapController;

  ProjectSearchItem? _selectedProjectSearchItem; // Variable to hold the selected project search item
  Position? _currentPosition; // Variable to hold the current position
  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        _showResult = !visible; // Update the state based on keyboard visibility
      });
    });
    _getCurrentPermission();
  }

  void _getCurrentPermission() async {
    _currentPosition = await context.read<ProjectProvider>().getCurrentLocation();
    setState(() {});
  }

  // first load after map init
  void _initLocations() async {
    setState(() {
      _searchResults = _projectProvider.searchResults; // Get the initial search results
      _updateMarker();
      final newPosition = GooglemapUtil.calculateCameraPosition(context, _searchResults.map((location) => LatLng(location.lat, location.lng)).toList());
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(newPosition));
    });

    _projectProvider.addListener(_updateSearchResults);
  }

  @override
  void dispose() {
    keyboardSubscription.cancel(); // Cancel the subscription when the widget is disposed
    super.dispose();
    _projectProvider.removeListener(_updateSearchResults);
  }

  void _updateSearchResults() async {
    _searchResults = _projectProvider.searchResults; // Update the search results
    await _updateMarker();
    setState(() {});
  }

  Future<void> _updateMarker() async {
    pinLocations.clear(); // Clear previous markers
    final locations = <LatLng>[];
    for (var index = 0; index < max(10, _searchResults.length); index++) {
      final item = _searchResults[index];
      var icon = _projectProvider.pinBitmapNormal?[item.brandId];
      if (item.id == _selectedProjectSearchItem?.id) {
        icon = _projectProvider.pinBitmapSelected?[item.brandId]; // Use the selected bitmap for the marker
      }

      final location = LatLng(item.lat, item.lng); // Assuming e has latitude and longitude properties
      locations.add(location);
      final marker = Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        icon: icon ?? BitmapDescriptor.defaultMarker, // Use the first bitmap for the marker
        onTap: () {
          setState(() {
            _selectedProjectSearchItem = item; // Update the selected project search item
            _updateMarker();
          });
        },
      );
      pinLocations.add(marker); // Add the marker to the set
    }
    // final newPosition = GooglemapUtil.calculateCameraPosition(context, locations);
    // _mapController?.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  @override
  Widget build(BuildContext context) {
    _projectProvider = context.read<ProjectProvider>();
    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context), // Dismiss the keyboard when tapping outside
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        endDrawer: FilterDrawerWidget(
          onClearFilter: _clearAllFilters,
        ),
        body: Stack(
          children: [
            _buildGoogleMap(),
            Align(
              alignment: Alignment.topCenter,
              child: _buildAppBar(),
            ),
            _buildBottomResultList(),
          ],
        ),
      ),
    );
  }

  SafeArea _buildAppBar() {
    final projectProvider = context.read<ProjectProvider>();
    return SafeArea(
      child: Container(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
              child: _buildSearchBar(context, context.read<ProjectProvider>()),
            ),
            const SizedBox(height: mMediumPadding),
            // Filter button
            FilterOutlineButton(
              filterStatus: projectProvider.projectStatus,
              selectedCode: projectProvider.selectedStatus,
              onChanged: (value) => projectProvider.setProjectStatus(value ?? ''),
            ),
          ],
        ),
      ),
    );
  }

  GoogleMap _buildGoogleMap() {
    return GoogleMap(
      onMapCreated: (controller) {
        _mapController = controller;
        _initLocations();
      },
      initialCameraPosition: _initialCameraPosition ??
          const CameraPosition(
            target: LatLng(13.7563, 100.5018), // Default to Bangkok
            zoom: 10,
          ),
      onTap: (argument) {
        CommonUtil.dismissKeyboard(context); // Dismiss the keyboard when tapping on the map
      },
      markers: pinLocations,
    );
  }

  Widget _buildBottomResultList() {
    // final searchResult = context.watch<ProjectProvider>().searchResults;
    // _initSearchResult(); // Initialize search results
    final containerHeight = MediaQuery.of(context).size.height * 0.35;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: _showResult ? 0 : -containerHeight,
      left: 0,
      right: 0,
      child: MapSearchResultWidget(
        containerHeight: containerHeight,
        currentPosition: _currentPosition,
        selectedProjectSearchItem: _selectedProjectSearchItem,
        onSelected: (value) {
          setState(() {
            _selectedProjectSearchItem = value; // Update the selected project search item
            _updateMarker(); // Update the markers
          });
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ProjectProvider provider) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: CommonUtil.colorTheme(context, darkColor: mDarkBackgroundColor, lightColor: Colors.white),
              borderRadius: BorderRadius.circular(99),
              boxShadow: Theme.of(context).brightness == Brightness.dark ? const [BoxShadow(color: Colors.white24, blurRadius: 10, spreadRadius: 1)] : null,
            ),
            child: TextField(
              controller: widget.textController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                hintText: AppLocalizations.of(context)!.mapSearchHint,
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: mGreyColor),
                    ),
                suffixIcon: Icon(
                  Icons.search,
                  color: CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: const Color(0xFFBABABA)),
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                provider.setSearchText(value);
              },
            ),
          ),
        ),
        const SizedBox(width: mDefaultPadding),
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
    );
  }

  void _clearAllFilters() {
    _projectProvider.clearFilter();
    widget.textController.clear();
  }
}
