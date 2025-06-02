import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';

class ProjectGallerySection extends StatelessWidget {
  const ProjectGallerySection({
    super.key,
    required this.galleryItem,
    this.onImageTap,
  });
  final List<String> galleryItem;
  final Function(int index, List<String> imageUrls)? onImageTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
          child: Text(
            AppLocalizations.of(context)!.projectDetailGalleryTitle,
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
              return GestureDetector(
                onTap: () => onImageTap?.call(index, galleryItem),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: galleryItem[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
            itemCount: galleryItem.length,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }
}
