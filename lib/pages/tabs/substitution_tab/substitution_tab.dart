import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../home_page/home_page_controller.dart';
import '../../../controllers/web_data.dart';
import '../../../widgets/table_container/table_container.dart';

class SubstitutionTab extends StatelessWidget {
  const SubstitutionTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final webData = Get.find<WebData>();
    final pageController = PageController();

    return SafeArea(
      child: webData.substitutionTables.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ImageIcon(
                    AssetImage("assets/images/lucky_cat.png"),
                    size: 100,
                  ),
                  Text("home/no_information".tr),
                ],
              ),
            )
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
                  controller: pageController,
                  itemBuilder: (context, index) {
                    return EasyRefresh.custom(
                      onRefresh: () =>
                          Get.find<HomePageController>().onRefresh(context),
                      header: BallPulseHeader(
                        color: context.theme.colorScheme.primary,
                      ),
                      slivers: [
                        GetBuilder<WebData>(builder: (webData) {
                          return TableContainer(
                            index,
                            key: UniqueKey(),
                          );
                        }),
                      ],
                    );
                  },
                  itemCount: webData.substitutionTables.length,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: webData.substitutionTables.length,
                    effect: ColorTransitionEffect(
                      spacing: 12,
                      dotHeight: 5,
                      dotWidth: 20,
                      activeDotColor: context.theme.colorScheme.primary,
                      dotColor: context.theme.indicatorColor,
                    ),
                    onDotClicked: pageController.jumpToPage,
                  ),
                ),
              ],
            ),
    );
  }
}
