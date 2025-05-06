import 'dart:math';

import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class GalleryCarouselWidget extends StatefulWidget {
  const GalleryCarouselWidget({super.key, this.onClose, this.index = 0, required this.imageUrls});
  final Function()? onClose;
  final int index;
  final List<String> imageUrls;
  @override
  State<GalleryCarouselWidget> createState() => _GalleryCarouselWidgetState();
}

class _GalleryCarouselWidgetState extends State<GalleryCarouselWidget> {
  final List<String> _imageUrls = [];

  final _controller = CarouselSliderController();

  @override
  void didUpdateWidget(covariant GalleryCarouselWidget oldWidget) {
    if (oldWidget.imageUrls != widget.imageUrls) {
      setState(() {
        _imageUrls.clear();
        _imageUrls.addAll(widget.imageUrls);
      });
    }
    _controller.onReady.then((_) {
      if (oldWidget.index != widget.index) {
        _controller.jumpToPage(widget.index);
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black.withOpacity(0.6),
        child: Stack(
          children: [
            Center(
              child: CarouselSlider.builder(
                carouselController: _controller,
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                ),
                itemBuilder: (context, index, realIndex) => SizedBox(
                  child: GestureDetector(
                    onTap: () {
                      // แตะที่รูปจะไม่ปิด
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: _imageUrls[index],
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width * 0.7,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                itemCount: _imageUrls.length,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton.filled(
                onPressed: () => _controller.previousPage(),
                icon: const Icon(
                  Icons.chevron_left,
                  color: mGreyColor,
                  size: 32,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton.filled(
                onPressed: () => _controller.nextPage(),
                icon: const Icon(
                  Icons.chevron_right,
                  color: mGreyColor,
                  size: 32,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
