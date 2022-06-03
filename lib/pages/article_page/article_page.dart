import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import './article_page_controller.dart';

import '../../models/web_data/school_life_item.dart';
import '../../models/web_data/article.dart';

import '../../../widgets/article/article_header.dart';
import '../../../widgets/article/article_subheader.dart';
import '../../../widgets/article/article_content.dart';
import '../../../widgets/article/article_leading_image.dart';
import '../../../widgets/article/article_image.dart';

class ArticlePage extends StatelessWidget {
  static const route = "/articles";
  const ArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SchoolLifeItem item = Get.arguments;
    final controller = Get.put(ArticlePageController());

    return Scaffold(
      backgroundColor: context.theme.colorScheme.tertiary,
      appBar: AppBar(title: Text(item.header)),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            if (item.imageUrl.isNotEmpty)
              ArticleLeadingImage(
                url: item.imageUrl,
                imageCopyright: item.imageCopyright,
                dark: item.dark,
              ),
            ArticleSubheader(
              DateFormat.yMMMMEEEEd(Get.locale.toString())
                  .format(item.datetime),
            ),
            ...List.generate(item.articleElements.length, (index) {
              final element = item.articleElements[index];
              switch (element.type) {
                case ArticleElementType.HEADER:
                  return ArticleHeader(element.data);
                case ArticleElementType.SUBHEADER:
                  return ArticleSubheader(element.data);
                case ArticleElementType.CONTENT_HEADER:
                  return ArticleContent(element.data, true);
                case ArticleElementType.CONTENT:
                  return ArticleContent(element.data, false);
                case ArticleElementType.IMAGE:
                  return ArticleImage(element);
              }
            }),
            if (item.hyperlink.isNotEmpty)
              Center(
                child: TextButton.icon(
                  onPressed: () => controller.launchUrl(item.hyperlink),
                  icon: const Icon(Icons.open_in_new),
                  label: Text("articles/open_external_content".tr),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
