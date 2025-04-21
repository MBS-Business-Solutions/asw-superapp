import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectAdvertisementSection extends StatelessWidget {
  const ProjectAdvertisementSection({super.key, required this.advertisements});
  final List<ProjectBrochure> advertisements;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
          child: Text(
            AppLocalizations.of(context)!.projectDetailAdvertisementTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: mSmallPadding),
        SizedBox(
          height: 184,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => const SizedBox(width: mDefaultPadding),
            padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
            itemBuilder: (context, index) {
              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    child: Image.network(advertisements[index].image, fit: BoxFit.cover),
                  ),
                ),
              );
            },
            itemCount: advertisements.length,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }
}
