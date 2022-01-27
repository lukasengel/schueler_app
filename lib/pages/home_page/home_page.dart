import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../controllers/local_data.dart';
import './home_page_controller.dart';

import '../tabs/substitution_tab/substitution_tab.dart';
import '../tabs/smv_tab.dart/smv_tab.dart';
import '../tabs/news_tab/news_tab.dart';

import '../../widgets/splashy_bottom_navigation_bar.dart';
import '../../widgets/dynamic_app_bar.dart';

class HomePage extends StatelessWidget {
  static const route = "/home";
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final headlines = [
      "general/substitutions".tr,
      "general/news".tr,
      "general/school_life".tr,
    ];
    const tabs = [SubstitutionTab(), NewsTab(), SmvTab()];
    Get.put(HomePageController());

    return GetBuilder<HomePageController>(builder: (controller) {
      initializeDateFormatting(Get.locale.toString(), null);
      return Scaffold(
        appBar: dynamicAppBar(
          context: context,
          title: headlines[controller.selectedTab],
          action: DynamicAppBarAction(
            icon: Icons.settings_outlined,
            onPressed: controller.onPressedSettings,
          ),
          canGoBack: false,
        ),
        body: tabs[controller.selectedTab],
        floatingActionButton: controller.selectedTab > 0
            ? GetBuilder<LocalData>(builder: (localData) {
                return FloatingActionButton.extended(
                  label: Text(
                    !localData.settings.reversed
                        ? "home/asc".tr
                        : "home/desc".tr,
                  ),
                  icon: Icon(
                    !localData.settings.reversed
                        ? Icons.vertical_align_bottom
                        : Icons.vertical_align_top,
                  ),
                  onPressed: controller.invertSorting,
                );
              })
            : null,
        bottomNavigationBar: SplashyBottomNavigationBar(
          items: [
            SplashyBottomNavigationBarItem(
              icon: const Icon(Icons.event_note_outlined),
              activeIcon: const Icon(Icons.event_note),
              label: "general/substitutions".tr,
            ),
            SplashyBottomNavigationBarItem(
              icon: const Icon(Icons.campaign_outlined),
              activeIcon: const Icon(Icons.campaign),
              label: "general/news".tr,
            ),
            SplashyBottomNavigationBarItem(
              icon: const Icon(Icons.people_outline),
              activeIcon: const Icon(Icons.people),
              label: "general/school_life".tr,
            ),
          ],
          onTap: controller.switchTabs,
          hapticFeedback: false,
          currentIndex: controller.selectedTab,
          selectedItemColor: Get.theme.primaryColor,
        ),
      );
    });
  }
}
