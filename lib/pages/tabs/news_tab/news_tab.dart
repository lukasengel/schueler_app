import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

import '../../../controllers/local_data.dart';
import '../../../controllers/web_data.dart';
import '../../../widgets/news_container.dart';
import '../../home_page/home_page_controller.dart';

class NewsTab extends StatelessWidget {
  const NewsTab({Key? key}) : super(key: key);

  Widget buildNewsItem(List<String> news) {
    return NewsContainer(
      text: news,
      key: UniqueKey(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<WebData>(builder: (controller) {
        return EasyRefresh.builder(
            onRefresh: Get.find<HomePageController>().onRefresh,
            header: BallPulseHeader(color: Get.theme.primaryColor),
            builder: (context, physics, header, footer) {
              return CustomScrollView(
                slivers: [
                  if (header != null) header,
                  SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        (Get.find<LocalData>().settings.sortingAZ
                                ? controller.news.map(buildNewsItem)
                                : controller.newsInverted.map(buildNewsItem))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              );
            });
      }),
    );
  }
}
