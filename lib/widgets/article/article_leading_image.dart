import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArticleLeadingImage extends StatelessWidget {
  final String url;
  final String author;
  final bool dark;
  const ArticleLeadingImage({
    required this.url,
    required this.author,
    required this.dark,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CachedNetworkImage(
            height: context.height / 2.5,
            imageUrl: url,
            fit: BoxFit.fitHeight,
            placeholder: (context, url) => SizedBox(
              width: double.infinity,
              height: context.height / 2.5,
              child: Center(
                child: SpinKitThreeBounce(
                  color: context.theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          if (author.isNotEmpty)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                color: (dark ? Colors.black : Colors.white).withOpacity(0.4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Text(
                  "articles/photo".tr + author,
                  style:
                      Get.textTheme.labelSmall!.copyWith(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
