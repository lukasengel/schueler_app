import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './abbreviations_page_controller.dart';

import '../../../../widgets/settings_ui/settings_container.dart';

class AbbreviationsPage extends StatelessWidget {
  static const route = "/settings/abbreviations";
  const AbbreviationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AbbreviationsPageController());
    return Scaffold(
      appBar: AppBar(
        title: Text("abbreviations".tr),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: controller.onTapScaffold,
        child: SafeArea(
          bottom: false,
          child: GetBuilder<AbbreviationsPageController>(
            builder: (controller) {
              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 5),
                children: [
                  SettingsContainer(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          size: 28,
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller.searchController,
                            onChanged: controller.onSearchInput,
                            decoration: InputDecoration(hintText: "search".tr),
                            autocorrect: false,
                            enableSuggestions: false,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: controller.clearInput,
                          splashRadius: 20,
                          iconSize: 28,
                          color: Get.isPlatformDarkMode ? Colors.grey : null,
                        ),
                      ],
                    ),
                  ),
                  ...controller.list.map((e) {
                    return SettingsContainer(
                        child: Row(
                      children: [
                        Expanded(
                          child: Text(e.abbreviation),
                        ),
                        Expanded(
                          child: Text(e.name),
                          flex: 4,
                        )
                      ],
                    ));
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
