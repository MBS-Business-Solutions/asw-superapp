import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/projects/widget/progress_indicator_widget.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/utils/date_formatter_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectInfoSection extends StatelessWidget {
  const ProjectInfoSection({
    super.key,
    required this.projectDetail,
    this.onImageTap,
  });
  final ProjectDetail projectDetail;
  final Function(int index, List<String> imageUrls)? onImageTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // รูปภาพโปรเจก
              AspectRatio(
                aspectRatio: 22 / 9,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  width: double.infinity,
                  child: Image.network(
                    projectDetail.profileImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: mDefaultPadding),
              // ชื่อโปรเจก
              Text(
                projectDetail.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              // Description
              Text(
                projectDetail.description ?? '',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: mGreyColor),
                    ),
              ),
              const SizedBox(height: mDefaultPadding),
              // ความคืบหน้า
              if (projectDetail.progress != null) ...[
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.projectDetailProgressTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Text(
                      AppLocalizations.of(context)!.projectDetailProgressUpdated(DateFormatterUtil.formatShortNumberDate(context, projectDetail.progress!.updateDated)),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: mSmallPadding),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      ProgressIndicatorWidget(
                        progress: projectDetail.progress!.overall,
                        label: AppLocalizations.of(context)!.projectDetailProgressTitle,
                      ),
                      const SizedBox(width: mDefaultPadding * 2),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // โครงสร้าง
                            Row(
                              children: [
                                Text(AppLocalizations.of(context)!.projectDetailProgressStructure),
                                const Spacer(),
                                Text(
                                  '${_formatPercentage(projectDetail.progress!.construction)}%',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            // สถาปัตยกรรม
                            Row(
                              children: [
                                Text(AppLocalizations.of(context)!.projectDetailProgressFinishing),
                                const Spacer(),
                                Text(
                                  '${_formatPercentage(projectDetail.progress!.interior)}%',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            // ติดตั้งระบบ
                            Row(
                              children: [
                                Text(AppLocalizations.of(context)!.projectDetailProgressComplete),
                                const Spacer(),
                                Text(
                                  '${_formatPercentage(projectDetail.progress!.facilities)}%',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            // เสาเข็ม
                            Row(
                              children: [
                                Text(AppLocalizations.of(context)!.projectDetailProgressConstruction),
                                const Spacer(),
                                Text(
                                  '${_formatPercentage(projectDetail.progress!.constructionPiles)}%',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ]
            ],
          ),
        ),
        if (projectDetail.progress?.progressImages != null) ...[
          const SizedBox(height: mDefaultPadding),
          SizedBox(
            height: 184,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: mDefaultPadding),
              padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onImageTap?.call(index, projectDetail.progress!.progressImages!),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: projectDetail.progress!.progressImages![index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
              itemCount: projectDetail.progress!.progressImages!.length,
              shrinkWrap: true,
            ),
          ),
        ]
      ],
    );
  }

  String _formatPercentage(double? value) {
    if (value == null) return '0';
    var v = value.toStringAsFixed(1);
    if (v.endsWith('.0')) {
      v = v.substring(0, v.length - 2);
    }
    return v;
  }
}
