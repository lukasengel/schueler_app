import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../../controllers/local_data.dart';
import '../../../controllers/web_data.dart';

import '../../../widgets/news_container.dart';
import '../../../widgets/news_ticker.dart';
import '../../../models/news_item.dart';
import '../../home_page/home_page_controller.dart';

class NewsTab extends StatelessWidget {
  const NewsTab({Key? key}) : super(key: key);

  Widget buildNewsItem(NewsItem item) {
    return Center(
      child: NewsContainer(
        item: item,
        key: UniqueKey(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebData>(builder: (controller) {
      return EasyRefresh.builder(
        onRefresh: () => Get.find<HomePageController>().onRefresh(context),
        header: BallPulseHeader(color: Get.theme.primaryColor),
        builder: (context, index, header, footer) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              if (header != null) header,
              if (controller.ticker.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.only(top: 5),
                  sliver: NewsTicker(controller.ticker),
                ),
              if (controller.news.isNotEmpty)
                SliverSafeArea(
                  sliver: SliverPadding(
                    padding: const EdgeInsets.only(bottom: 5),
                    sliver: GetBuilder<LocalData>(builder: (localData) {
                      return SliverList(
                        delegate: SliverChildListDelegate([
                          ...(localData.settings.reversed
                                  ? controller.news.map(buildNewsItem)
                                  : controller.news.reversed.map(buildNewsItem))
                              .toList(),
                          const SizedBox(
                            height: 65,
                          ),
                        ]),
                      );
                    }),
                  ),
                ),
              if (controller.news.isEmpty)
                SliverFillRemaining(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.update, size: 100),
                      Text("no_news".tr, style: context.textTheme.bodyText1),
                      const SizedBox(height: 10),
                      Text(
                        controller.latestUpdate,
                        style: Get.textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
            ],
          );
        },
      );
    });
  }
}
