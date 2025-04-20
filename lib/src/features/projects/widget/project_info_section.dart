import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/projects/widget/progress_indicator_widget.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectInfoSection extends StatelessWidget {
  const ProjectInfoSection({
    super.key,
    required this.projectInfo,
  });
  final ProjectInfo projectInfo;

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
                    projectInfo.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: mDefaultPadding),
              // ชื่อโปรเจก
              Text(
                projectInfo.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              // Description
              Text(
                projectInfo.description,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: mGreyColor),
                    ),
              ),
              const SizedBox(height: mDefaultPadding),
              // ความคืบหน้า
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.projectDetailProgressTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Spacer(),
                  Text(
                    AppLocalizations.of(context)!.projectDetailProgressUpdated(projectInfo.lastUpdate),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: mSmallPadding),
              IntrinsicHeight(
                child: Row(
                  children: [
                    ProgressIndicatorWidget(
                      progress: projectInfo.progress.percentage / 100,
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
                              Spacer(),
                              Text(
                                '${projectInfo.progress.structure}%',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          // สถาปัตยกรรม
                          Row(
                            children: [
                              Text(AppLocalizations.of(context)!.projectDetailProgressFinishing),
                              Spacer(),
                              Text(
                                '${projectInfo.progress.architecture}%',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          // ติดตั้งระบบ
                          Row(
                            children: [
                              Text(AppLocalizations.of(context)!.projectDetailProgressComplete),
                              Spacer(),
                              Text(
                                '${projectInfo.progress.installation}%',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          // เสาเข็ม
                          Row(
                            children: [
                              Text(AppLocalizations.of(context)!.projectDetailProgressConstruction),
                              Spacer(),
                              Text(
                                '${projectInfo.progress.foundation}%',
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
            ],
          ),
        ),
        const SizedBox(height: mDefaultPadding),
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
                    child: Image.network(projectInfo.images[index], fit: BoxFit.cover),
                  ),
                ),
              );
            },
            itemCount: projectInfo.images.length,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }
}
