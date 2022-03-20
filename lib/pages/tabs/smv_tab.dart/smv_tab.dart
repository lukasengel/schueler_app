import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../../controllers/local_data.dart';
import '../../../controllers/web_data.dart';
import '../../../pages/home_page/home_page_controller.dart';
import '../../../widgets/school_life_container.dart';

class SmvTab extends StatelessWidget {
  const SmvTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final webData = Get.find<WebData>();

    return SafeArea(
      child: GetBuilder<WebData>(builder: (controller) {
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
                webData.schoolLifeItems.isNotEmpty
                    ? SliverPadding(
                        padding: const EdgeInsets.only(top: 5),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return SchooLifeContainer(
                                Get.find<LocalData>()
                                        .settings
                                        .reversedSmv
                                    ? webData.schoolLifeItems[index]
                                    : webData.schoolLifeItems.reversed
                                        .toList()[index],
                              );
                            },
                            childCount: webData.schoolLifeItems.length,
                          ),
                        ),
                      )
                    : SliverFillRemaining(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ImageIcon(
                              AssetImage("assets/images/lucky_cat.png"),
                              size: 100,
                            ),
                            Text("home/no_news".tr,
                                style: context.textTheme.bodyText1),
                          ],
                        ),
                      ),
                if (webData.schoolLifeItems.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 75,
                    ),
                  )
              ],
            );
          },
        );
      }),
    );
  }
}
