import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:photo_view/photo_view.dart';

class ProjectPlansSection extends StatefulWidget {
  const ProjectPlansSection({
    super.key,
    required this.floorPlan,
  });
  final List<ProjectPlan> floorPlan;

  @override
  State<ProjectPlansSection> createState() => _ProjectPlansSectionState();
}

class _ProjectPlansSectionState extends State<ProjectPlansSection> {
  ProjectPlan? _selectedFloorPlan;

  @override
  void initState() {
    super.initState();
    _selectedFloorPlan = widget.floorPlan.isNotEmpty ? widget.floorPlan.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.projectDetailPlanTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: mSmallPadding),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: mDefaultPadding),
            decoration: BoxDecoration(
              color: CommonUtil.colorTheme(context, darkColor: mDarkBackgroundColor, lightColor: Colors.white),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: CommonUtil.colorTheme(context, darkColor: mGreyColor, lightColor: mLightBorderTextFieldColor),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ProjectPlan>(
                padding: EdgeInsets.zero,
                isExpanded: true,
                value: _selectedFloorPlan,
                items: widget.floorPlan.map((floorPlan) {
                  return DropdownMenuItem<ProjectPlan>(
                    value: floorPlan,
                    child: Text(
                      floorPlan.name, // Assuming FloorPlan has a 'name' property
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (selectedFloorPlan) {
                  // Handle selection change
                  setState(() {
                    _selectedFloorPlan = selectedFloorPlan;
                  });
                },
                icon: const Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
          const SizedBox(height: mDefaultPadding),
          if (_selectedFloorPlan != null)
            GestureDetector(
              onTap: () {
                _onImageTap(_selectedFloorPlan!.image);
              },
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                child: CachedNetworkImage(
                  imageUrl: _selectedFloorPlan!.image,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            )
        ],
      ),
    );
  }

  void _onImageTap(String imageUrl) {
    showDialog(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: PhotoView(
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 1.5,
              imageProvider: CachedNetworkImageProvider(imageUrl),
              backgroundDecoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          );
        });
  }
}
