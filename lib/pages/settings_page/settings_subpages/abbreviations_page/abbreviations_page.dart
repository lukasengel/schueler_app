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
        title: Text("settings/abbreviations".tr),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: controller.onTapScaffold,
        child: SafeArea(
          bottom: false,
          child: GetBuilder<AbbreviationsPageController>(
            builder: (controller) {
              return CustomScrollView(
                slivers: [
                  const SliverPadding(
                    padding: EdgeInsets.only(top: 5),
                    sliver: FloatingSearchBar(),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 60),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = controller.list[index];
                          return SettingsContainer(
                            key: Key(item.abbreviation),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3,
                                vertical: 5,
                              ),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    item.abbreviation,
                                    style: context.textTheme.bodyLarge,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: context.textTheme.bodyLarge,
                                  ),
                                  flex: 4,
                                ),
                              ]),
                            ),
                          );
                        },
                        childCount: controller.list.length,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class FloatingSearchBar extends StatelessWidget {
  const FloatingSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AbbreviationsPageController>();
    return SliverPersistentHeader(
      pinned: true,
      delegate: _PersistentHeader(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchInput,
              style: Get.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: "settings/abbreviations/search".tr,
                hintStyle: Get.textTheme.bodyLarge,
                contentPadding: const EdgeInsets.only(top: 6),
                focusColor: Colors.blue,
                prefixIcon: Icon(
                  Icons.search,
                  color: Get.theme.iconTheme.color,
                ),
                suffixIcon: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.clear,
                    color: Get.theme.iconTheme.color,
                  ),
                  onPressed: controller.clearInput,
                  splashRadius: 20,
                ),
              ),
              autocorrect: false,
              enableSuggestions: false,
            ),
          ),
        ),
      ),
    );
  }
}

class _PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget child;

  _PersistentHeader({required this.child});

  @override
  Widget build(context, shrinkOffset, overlapsContent) => child;

  @override
  double get maxExtent => 51.0;

  @override
  double get minExtent => 51.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
