import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:flutter/material.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final VoidCallback? onTap;

  const VideoThumbnailWidget({
    super.key,
    required this.videoUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.onTap,
  });

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  String? _thumbnailPath;
  bool _isLoading = true;
  final bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    // try {
    //   final thumbnailPath = await VideoThumbnail.thumbnailFile(
    //     video: widget.videoUrl,
    //     thumbnailPath: (await getTemporaryDirectory()).path,
    //     imageFormat: ImageFormat.WEBP,
    //     maxHeight: 200,
    //     quality: 99,
    //   );

    //   if (!mounted) return;

    setState(() {
      final videoId = widget.videoUrl.split('/').last;
      _thumbnailPath = 'https://img.youtube.com/vi/$videoId/0.jpg';
      _isLoading = false;
    });
    // } catch (e) {
    //   if (!mounted) return;
    //   setState(() {
    //     _hasError = true;
    //     _isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_hasError || _thumbnailPath == null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: Icon(Icons.error_outline),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              _thumbnailPath!,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
            ),
            // Image.file(
            //   File(_thumbnailPath!),
            //   width: widget.width,
            //   height: widget.height,
            //   fit: widget.fit,
            // ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
