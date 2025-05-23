import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_content_service.dart';
import 'package:AssetWise/src/widgets/webview_with_close.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectAdvertisementSection extends StatefulWidget {
  const ProjectAdvertisementSection({
    super.key,
    required this.advertisements,
    this.onImageTap,
  });
  final List<ProjectBrochure> advertisements;
  final Function(int index, List<String> imageUrls)? onImageTap;

  @override
  State<ProjectAdvertisementSection> createState() => _ProjectAdvertisementSectionState();
}

class _ProjectAdvertisementSectionState extends State<ProjectAdvertisementSection> {
  bool _isDownloading = false;
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
        Container(
          height: 50,
          alignment: Alignment.center,
          child: OutlinedButton.icon(
              onPressed: _isDownloading
                  ? null
                  : () {
                      _downloadBrochure(
                        context,
                        widget.advertisements[0].url,
                      );
                    },
              icon: _isDownloading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.download),
              label: Text(
                AppLocalizations.of(context)!.projectDetailAdvertisementDownload,
              )),
        ),
      ],
    );
  }

  Future<void> _downloadBrochure(BuildContext context, String url) async {
    setState(() {
      _isDownloading = true;
    });
    try {
      Navigator.pushNamed(context, WebViewWithCloseButton.routeName, arguments: {'link': AWContentService().pdfViewerUrl(url)});
    } catch (e) {
      if (kDebugMode) print("Error: $e");
    }
    setState(() {
      _isDownloading = false;
    });
  }
}
