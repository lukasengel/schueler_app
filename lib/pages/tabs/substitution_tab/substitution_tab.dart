import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:schueler_app/controllers/web_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../home_page/home_page_controller.dart';
import '../../../widgets/daily_table.dart';
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
                  return EasyRefresh.builder(
                    onRefresh: Get.find<HomePageController>().onRefresh,
                    header: BallPulseHeader(color: Get.theme.primaryColor),
                    builder: (context, physics, header, footer) {
                      return CustomScrollView(
                        slivers: [
                          if (header != null) header,
                          GetBuilder<WebData>(builder: (_) {
                            return DailyTable(
                              controller.webData.dailyTables[index],
                              controller.webData.groups[index],
                            );
                          }),
                        ],
                      );
                    },
                  );
                },
                itemCount: controller.webData.dailyTables.length),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Get.theme.canvasColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SmoothPageIndicator(
                      controller: controller.pageController,
                      count: controller.webData.dailyTables.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: Get.theme.primaryColor,
                        dotColor: context.theme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (controller.webData.ticker.isNotEmpty)
                    Container(
                      child: Marquee(
                          text: controller.webData.ticker +
                              controller.webData.latestUpdate +
                              ' '),
                      height: 30,
                      color: context.theme.canvasColor,
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
