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
                    ],
                  );
                },
                itemCount: controller.webData.substitutionTables.length),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              child: SmoothPageIndicator(
                controller: controller.pageController,
                count: controller.webData.substitutionTables.length,
                effect: ColorTransitionEffect(
                  spacing: 12,
                  dotHeight: 12,
                  dotWidth: 12,
                  activeDotColor: Colors.grey.shade600.withOpacity(0.8),
                  dotColor: Colors.grey.shade400.withOpacity(0.8),
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
