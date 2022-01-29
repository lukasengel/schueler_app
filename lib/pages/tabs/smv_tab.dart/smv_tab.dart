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
        return EasyRefresh(
          onRefresh: () => Get.find<HomePageController>().onRefresh(context),
          header: BallPulseHeader(color: Get.theme.primaryColor),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 75),
            itemBuilder: (context, index) {
              return SchooLifeContainer(
                Get.find<LocalData>().settings.reversed
                    ? webData.schoolLifeItems[index]
                    : webData.schoolLifeItems.reversed.toList()[index],
              );
            },
            itemCount: webData.schoolLifeItems.length,
          ),
        );
      }),
    );
  }
}
