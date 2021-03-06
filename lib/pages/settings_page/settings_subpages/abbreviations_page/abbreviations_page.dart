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
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: Row(
              children: [
                const Icon(Icons.search, size: 28),
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: controller.onSearchInput,
                    style: Get.textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: "settings/abbreviations/search".tr,
                      hintStyle: Get.textTheme.bodyLarge,
                    ),
                    autocorrect: false,
                    enableSuggestions: false,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.clear),
                  onPressed: controller.clearInput,
                  splashRadius: 20,
                  iconSize: 28,
                ),
              ],
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
