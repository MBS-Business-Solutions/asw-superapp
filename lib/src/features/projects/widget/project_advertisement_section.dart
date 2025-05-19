import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/project_provider.dart';
import 'package:AssetWise/src/widgets/webview_with_close.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
      // Navigator.pushNamed(context, WebViewWithCloseButton.routeName, arguments: {'link': url});
      launchUrlString(url);
      // // ดาวน์โหลดไฟล์ PDF
      // final filePath = await context.read<ProjectProvider>().download(url);
      // final box = context.findRenderObject() as RenderBox?;
      // if (filePath != null) {
      //   // เปิดไฟล์ PDF และให้ผู้ใช้เลือกแอป

      //   await Share.shareXFiles(
      //     [XFile(filePath)],
      //     sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      //   );
      //   //await OpenFile.open(filePath);
      // } else {
      //   // แจ้งเตือนเมื่อไม่สามารถดาวน์โหลดไฟล์ได้
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(
      //       AppLocalizations.of(context)!.errorUnableToDownloadContract,
      //     ),
      //   ));
      // }
    } catch (e) {
      if (kDebugMode) print("Error: $e");
    }
    setState(() {
      _isDownloading = false;
    });
  }
}
