import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectPlansSection extends StatefulWidget {
  const ProjectPlansSection({
    super.key,
    required this.floorPlan,
  });
  final List<FloorPlan> floorPlan;

  @override
  State<ProjectPlansSection> createState() => _ProjectPlansSectionState();
}

class _ProjectPlansSectionState extends State<ProjectPlansSection> {
  FloorPlan? selectedFloorPlan;

  @override
  void initState() {
    super.initState();
    selectedFloorPlan = widget.floorPlan.isNotEmpty ? widget.floorPlan.first : null;
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
              child: DropdownButton<FloorPlan>(
                padding: EdgeInsets.zero,
                isExpanded: true,
                value: selectedFloorPlan,
                items: widget.floorPlan.map((floorPlan) {
                  return DropdownMenuItem<FloorPlan>(
                    value: floorPlan,
                    child: Text(
                      floorPlan.unitName, // Assuming FloorPlan has a 'name' property
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (selectedFloorPlan) {
                  // Handle selection change
                  setState(() {
                    selectedFloorPlan = selectedFloorPlan;
                  });
                },
                icon: const Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
          const SizedBox(height: mDefaultPadding),
          if (selectedFloorPlan != null)
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: Image.network(
                selectedFloorPlan!.image,
                fit: BoxFit.contain,
              ),
            )
        ],
      ),
    );
  }
}
