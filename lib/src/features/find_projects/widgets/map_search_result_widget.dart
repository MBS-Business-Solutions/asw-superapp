import 'dart:math';

import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/find_projects/widgets/pin_widget.dart';
import 'package:AssetWise/src/features/projects/views/project_detail_view.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/project_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/utils/googlemap_util.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapSearchResultWidget extends StatefulWidget {
  const MapSearchResultWidget({
    super.key,
    required this.containerHeight,
    this.currentPosition,
    this.selectedProjectSearchItem,
    this.onSelected,
  });

  final double containerHeight;
  final Position? currentPosition;
  final ProjectSearchItem? selectedProjectSearchItem; // Variable to hold the selected project search item
  final ValueChanged<ProjectSearchItem?>? onSelected;
  @override
  State<MapSearchResultWidget> createState() => _MapSearchResultWidgetState();
}

class _MapSearchResultWidgetState extends State<MapSearchResultWidget> {
  ProjectSearchItem? selectedProjectSearchItem; // Variable to hold the selected project search item

  @override
  void didUpdateWidget(covariant MapSearchResultWidget oldWidget) {
    if (oldWidget.selectedProjectSearchItem != widget.selectedProjectSearchItem) {
      selectedProjectSearchItem = widget.selectedProjectSearchItem; // Update the selected project search item
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    selectedProjectSearchItem = widget.selectedProjectSearchItem; // Initialize the selected project search item
    super.initState();
  }

  // Callback for when a project is selected
  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(builder: (context, provider, child) {
      if (selectedProjectSearchItem != null) {
        return _buildSelectProject();
      } else {
        return _buildList(provider);
      }
    });
  }

  Widget _buildSelectProject() {
    return Container(
      decoration: BoxDecoration(
        color: CommonUtil.colorTheme(context, darkColor: mDarkCardBackgroundColor, lightColor: mLightCardBackgroundColor).withOpacity(0.94),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  widget.onSelected?.call(null);
                },
                icon: const Icon(
                  Icons.chevron_left,
                  color: mGreyColor,
                  size: 32,
                )),
            // header (back button)
            Padding(
              padding: const EdgeInsets.only(left: mScreenEdgeInsetValue, right: mScreenEdgeInsetValue, bottom: mSmallPadding),
              child: Column(
                children: [
                  // header
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PinWidget(
                          color: mTealColor,
                          imageUrl: selectedProjectSearchItem!.brandImage,
                        ), // Replace with your actual image URL
                        const SizedBox(width: mDefaultPadding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // title
                              Text(
                                selectedProjectSearchItem!.name,
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(selectedProjectSearchItem!.address, style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                              Text(
                                '${selectedProjectSearchItem!.status} | ${selectedProjectSearchItem!.textPrice}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: mGreyColor),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.currentPosition != null)
                          Column(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: CommonUtil.colorTheme(context, darkColor: const Color(0xFF444444), lightColor: const Color(0xFFF9F9F9)),
                                ),
                                child: Transform.rotate(
                                  angle: pi, // Rotate 180 degrees
                                  child: const Icon(
                                    Icons.subdirectory_arrow_left_sharp,
                                    size: 15,
                                    color: mTealColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: mSmallPadding),
                              Text(
                                  AppLocalizations.of(context)!.mapDistanceKM(
                                    GooglemapUtil.calculateDistanceInKm(
                                      LatLng(widget.currentPosition!.latitude, widget.currentPosition!.longitude),
                                      LatLng(selectedProjectSearchItem!.lat, selectedProjectSearchItem!.lng),
                                    ).toStringAsFixed(2),
                                  ),
                                  style: Theme.of(context).textTheme.labelSmall!.copyWith(color: mTealColor, fontWeight: FontWeight.bold)),
                            ],
                          )
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: mSmallPadding),
                  Row(
                    children: [
                      // Show project detail button
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Navigator.pushNamed(context, ProjectDetailView.routeName, arguments: {'projectId': selectedProjectSearchItem!.id}).then((value) {
                              widget.onSelected?.call(null); // Clear the selected project when navigating back
                            });
                          },
                          style: FilledButton.styleFrom(backgroundColor: mLightTealColor, foregroundColor: mTextOnLightTeal),
                          child: Text(
                            AppLocalizations.of(context)!.mapShowProjectDetail,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: mTextOnLightTeal,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: mDefaultPadding),
                      // Navigate to map button
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            GooglemapUtil.openGoogleMap(
                              selectedProjectSearchItem!.lat,
                              selectedProjectSearchItem!.lng,
                            );
                          },
                          style: FilledButton.styleFrom(backgroundColor: mTealColor, foregroundColor: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.mapNavigate,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(width: mMediumPadding),
                              const Icon(
                                Icons.gps_fixed_sharp,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(ProjectProvider provider) {
    final searchResults = provider.searchResults; // Get the search results from the provider
    return Container(
      decoration: BoxDecoration(
        color: CommonUtil.colorTheme(context, darkColor: mDarkCardBackgroundColor, lightColor: mLightCardBackgroundColor).withOpacity(0.94),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      height: widget.containerHeight,
      padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue, vertical: mDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: mSmallPadding),
            child: Center(
              child: Container(
                width: 32,
                height: 5,
                decoration: BoxDecoration(
                  color: CommonUtil.colorTheme(context, darkColor: Colors.white, lightColor: const Color(0xFFBABABA)),
                  borderRadius: BorderRadius.circular(50.0), // Stadium shape
                ),
              ),
            ),
          ),
          const SizedBox(
            height: mSmallPadding,
          ),
          // Search result count
          Text(
            AppLocalizations.of(context)!.mapSearchCount(searchResults.length),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: CommonUtil.colorTheme(context, darkColor: mDarkDisplayTextColor, lightColor: mLightDisplayTextColor),
                ),
          ),
          const SizedBox(
            height: mSmallPadding,
          ),
          // Search result list
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(top: 0, bottom: MediaQuery.of(context).padding.bottom),
              itemCount: searchResults.length, // Replace with your actual data count
              separatorBuilder: (context, index) => Divider(
                color: mGreyColor.withOpacity(0.2),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final projectSearchItem = searchResults[index];

                return ListTile(
                  onTap: () => widget.onSelected?.call(projectSearchItem),
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PinWidget(
                        color: mBrightPrimaryColor,
                        imageUrl: projectSearchItem.brandImage,
                      ), // Replace with your actual image URL
                      const SizedBox(width: mDefaultPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // title
                            Text(
                              projectSearchItem.name,
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(projectSearchItem.address, style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text(
                              '${projectSearchItem.status} | ${projectSearchItem.textPrice}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: mGreyColor),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.currentPosition != null)
                        Column(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: CommonUtil.colorTheme(context, darkColor: const Color(0xFF444444), lightColor: const Color(0xFFF9F9F9)),
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
                            Text(
                                AppLocalizations.of(context)!.mapDistanceKM(
                                  GooglemapUtil.calculateDistanceInKm(
                                    LatLng(widget.currentPosition!.latitude, widget.currentPosition!.longitude),
                                    LatLng(projectSearchItem.lat, projectSearchItem.lng),
                                  ).toStringAsFixed(2),
                                ),
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: mBrightPrimaryColor, fontWeight: FontWeight.bold)),
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
    );
  }
}
