import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';

/// A widget that displays an image with a blurred background to ensure it fills the entire size.
///
/// The widget takes an image URL and displays the image to fit the given height.
/// If the image does not fill the entire given width, a blurred version of the image is displayed in
/// the background to ensure a uniform and aesthetically pleasing appearance.
class SBlurredBackgroundImage extends StatelessWidget {
  /// The url of the image to display.
  final String url;

  /// The height of the image.
  final double height;

  /// The width of the image.
  final double width;

  /// The border radius of the image.
  final BorderRadius borderRadius;

  /// Create a new [SBlurredBackgroundImage].
  const SBlurredBackgroundImage({
    required this.url,
    required this.height,
    required this.width,
    this.borderRadius = BorderRadius.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: borderRadius,
      child: Stack(
        children: [
          // Stretch the image to fill the entire tile.
          FastCachedImage(
            url: url,
            height: height,
            width: width,
            fit: BoxFit.fill,
            gaplessPlayback: true,
          ),
          // Add a blurred overlay to the image.
          GlossyContainer(
            height: height,
            width: width,
            borderRadius: borderRadius,
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.black26 : Colors.white38,
            ),
            child: Container(
              // Give the image a padding and clip its edges, so the inner image does not overlap the border.
              padding: const EdgeInsets.all(1),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                // Add three pixels to all given corners, so the inner image does not overlap the border.
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius.topLeft.x + (borderRadius.topLeft.x > 0 ? 3 : 0)),
                  topRight: Radius.circular(borderRadius.topRight.x + (borderRadius.topRight.x > 0 ? 3 : 0)),
                  bottomLeft: Radius.circular(borderRadius.bottomLeft.x + (borderRadius.bottomLeft.x > 0 ? 3 : 0)),
                  bottomRight: Radius.circular(borderRadius.bottomRight.x + (borderRadius.bottomRight.x > 0 ? 3 : 0)),
                ),
              ),
              // Add a non-blurred image on top of the blurred one and make it fit the height of the tile.
              child: FastCachedImage(
                url: url,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.fitHeight,
                gaplessPlayback: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
