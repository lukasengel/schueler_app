import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/web_data/article.dart';

class ArticleImage extends StatelessWidget {
  final ArticleElement element;
  const ArticleImage(this.element, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
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
                imageUrl: element.data,
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
              if (element.imageCopyright.isNotEmpty)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    color: (element.dark ? Colors.black : Colors.white)
                        .withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      "articles/photo".tr + element.imageCopyright,
                      style: Get.textTheme.labelSmall!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (element.description.isNotEmpty)
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
            child: Text(element.description, style: Get.textTheme.labelMedium),
          ),
      ],
    );
  }
}
