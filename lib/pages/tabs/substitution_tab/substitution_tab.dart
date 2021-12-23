import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../home_page/home_page_controller.dart';
import '../../../controllers/web_data.dart';
import '../../../widgets/table_container.dart';
import './substitution_tab_controller.dart';

class SubstitutionTab extends StatelessWidget {
  const SubstitutionTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SubstitutionTabController());
    return SafeArea(
      child: GetBuilder<SubstitutionTabController>(builder: (controller) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
                controller: controller.pageController,
                itemBuilder: (context, index) {
                  return EasyRefresh.custom(
                    onRefresh: () =>
                        Get.find<HomePageController>().onRefresh(context),
                    header: BallPulseHeader(color: Get.theme.primaryColor),
                    slivers: [
                      GetBuilder<WebData>(builder: (webData) {
                        return TableContainer(
                          item: webData.substitutionTables[index],
                          latestUpdate: webData.latestUpdate,
                        );
                      }),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 65,
                        ),
                      ),
                    ],
                  );
                },
                itemCount: controller.webData.substitutionTables.length),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Get.theme.cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: SmoothPageIndicator(
                controller: controller.pageController,
                count: controller.webData.substitutionTables.length,
                effect: ScrollingDotsEffect(
                  activeDotColor: Get.theme.primaryColor,
                  dotColor: context.theme.primaryColor.withOpacity(0.3),
                ),
                onDotClicked: (index) {
                  controller.pageController.jumpToPage(index);
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
