import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import './home_page_controller.dart';
import '../tabs/substitution_tab/substitution_tab.dart';
import '../tabs/smv_tab.dart/smv_tab.dart';
import '../tabs/news_tab/news_tab.dart';
import '../../widgets/splashy_bottom_navigation_bar.dart';
import 'package:schueler_app/controllers/local_data.dart';

class HomePage extends StatelessWidget {
  static const route = "/home";
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    final headlines = ["substitutions".tr, "news".tr, "smv".tr];
    const tabs = [SubstitutionTab(), NewsTab(), SmvTab()];

    Get.put(HomePageController());
    return GetBuilder<HomePageController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(headlines[controller.selectedTab]),
          actions: [
            IconButton(
              onPressed: controller.onPressedSettings,
              icon: const Icon(
                Icons.settings_outlined,
              ),
            )
          ],
        ),
        body: tabs[controller.selectedTab],
        floatingActionButton: controller.selectedTab > 0
            ? GetBuilder<LocalData>(builder: (c) {
                return FloatingActionButton.extended(
                  label: Text(
                    !c.settings.sortingAZ ? "asc".tr : "desc".tr,
                  ),
                  icon: Icon(
                    !c.settings.sortingAZ
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
              label: "substitutions".tr,
            ),
            SplashyBottomNavigationBarItem(
              icon: const Icon(Icons.campaign_outlined),
              label: "news".tr,
            ),
            SplashyBottomNavigationBarItem(
              icon: const Icon(Icons.people_outline),
              label: "smv".tr,
            )
          ],
          onTap: controller.switchTabs,
          currentIndex: controller.selectedTab,
          selectedItemColor: Get.theme.primaryColor,
        ),
      );
    });
  }
}
