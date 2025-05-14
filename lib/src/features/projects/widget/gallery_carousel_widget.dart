
import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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

  // final _controller = CarouselSliderController();
  final _pageController = PageController();

  @override
  void didUpdateWidget(covariant GalleryCarouselWidget oldWidget) {
    if (oldWidget.imageUrls != widget.imageUrls) {
      setState(() {
        _imageUrls.clear();
        _imageUrls.addAll(widget.imageUrls);
      });
    }
    _pageController.jumpToPage(widget.index);
    // _controller.onReady.then((_) {
    //   if (oldWidget.index != widget.index) {
    //     _controller.jumpToPage(widget.index);
    //   }
    // });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      child: Stack(
        children: [
          Positioned.fill(
              child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
            ),
          )),
          PhotoViewGallery.builder(
            pageController: _pageController,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 1.5,
                imageProvider: CachedNetworkImageProvider(_imageUrls[index]),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(tag: _imageUrls[index]),
              );
            },

            itemCount: _imageUrls.length,
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(),
            ),
            backgroundDecoration: const BoxDecoration(
              color: Colors.transparent,
            ),

            // pageController: widget.pageController,
            // onPageChanged: onPageChanged,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton.filled(
              onPressed: () => _pageController.previousPage(curve: Curves.easeInOutCubic, duration: const Duration(milliseconds: 300)),
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
              onPressed: () => _pageController.nextPage(curve: Curves.easeInOutCubic, duration: const Duration(milliseconds: 300)),
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
    );
    // return GestureDetector(
    //   onTap: widget.onClose,
    //   child: Container(
    //     color: Colors.black.withOpacity(0.6),
    //     child: Stack(
    //       children: [
    //         Center(
    //           child: PhotoViewGestureDetectorScope(
    //             axis: Axis.horizontal,
    //             child: CarouselSlider.builder(
    //               carouselController: _controller,
    //               options: CarouselOptions(
    //                 enlargeCenterPage: true,
    //                 enableInfiniteScroll: false,
    //                 autoPlay: false,
    //               ),
    //               itemBuilder: (context, index, realIndex) => PhotoView(imageProvider: CachedNetworkImageProvider(_imageUrls[index])

    //                   // CachedNetworkImage(
    //                   //   imageUrl: _imageUrls[index],
    //                   //   fit: BoxFit.contain,
    //                   //   width: MediaQuery.of(context).size.width * 0.7,
    //                   //   placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
    //                   //   errorWidget: (context, url, error) => const Icon(Icons.error),
    //                   // ),
    //                   ),
    //               itemCount: _imageUrls.length,
    //             ),
    //           ),
    //         ),
    //         Align(
    //           alignment: Alignment.centerLeft,
    //           child: IconButton.filled(
    //             onPressed: () => _controller.previousPage(),
    //             icon: const Icon(
    //               Icons.chevron_left,
    //               color: mGreyColor,
    //               size: 32,
    //             ),
    //             style: IconButton.styleFrom(
    //               backgroundColor: Colors.white,
    //             ),
    //             padding: EdgeInsets.zero,
    //           ),
    //         ),
    //         Align(
    //           alignment: Alignment.centerRight,
    //           child: IconButton.filled(
    //             onPressed: () => _controller.nextPage(),
    //             icon: const Icon(
    //               Icons.chevron_right,
    //               color: mGreyColor,
    //               size: 32,
    //             ),
    //             style: IconButton.styleFrom(
    //               backgroundColor: Colors.white,
    //             ),
    //             padding: EdgeInsets.zero,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
