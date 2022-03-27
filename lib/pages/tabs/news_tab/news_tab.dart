import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../../controllers/local_data.dart';
import '../../../controllers/web_data.dart';

import '../../../widgets/news_container.dart';
import '../../../widgets/news_ticker.dart';
import '../../../models/web_data/news_item.dart';
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
        header: BallPulseHeader(color: Get.theme.colorScheme.primary),
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
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    sliver: GetBuilder<LocalData>(builder: (localData) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return buildNewsItem(localData.settings.reversedNews
                                ? controller.news[index]
                                : controller.news.reversed.toList()[index]);
                          },
                          childCount: controller.news.length,
                        ),
                      );
                    }),
                  ),
                ),
              if (controller.ticker.isNotEmpty)
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 75,
                  ),
                ),
              if (controller.news.isEmpty)
                SliverFillRemaining(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ImageIcon(
                        AssetImage("assets/images/lucky_cat.png"),
                        size: 100,
                      ),
                      Text(
                        "home/no_news".tr,
                        style: context.textTheme.bodyMedium,
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
