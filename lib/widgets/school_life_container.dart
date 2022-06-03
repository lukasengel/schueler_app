import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:cached_network_image/cached_network_image.dart';

import '../models/web_data/school_life_item.dart';

class SchooLifeContainer extends StatelessWidget {
  final SchoolLifeItem item;
  const SchooLifeContainer(this.item, {Key? key}) : super(key: key);

  Widget buildEventContainer(BuildContext context) {
    return SchoolLifeBaseContainer(
      item: item,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Text(
                DateFormat.yMMMMEEEEd(Get.locale.toString())
                    .format(item.eventTime),
                style: Get.textTheme.bodySmall!
                    .copyWith(fontWeight: FontWeight.w300, fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.header, style: context.textTheme.titleMedium),
                Icon(Icons.event, color: context.theme.colorScheme.onSecondary),
              ],
            ),
          ),
          Divider(
            color: context.theme.colorScheme.onTertiary,
            indent: 15,
            endIndent: 15,
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(item.content, style: context.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  Widget buildArticleContainer(BuildContext context) {
    return SchoolLifeBaseContainer(
      item: item,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                constraints: const BoxConstraints(maxHeight: 500),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(11),
                  ),
                  child: CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: item.imageUrl,
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Center(
                        child: SpinKitThreeBounce(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                color:
                    (item.dark ? Colors.black : Colors.white).withOpacity(0.4),
                child: Text(
                  item.header.toUpperCase(),
                  maxLines: 3,
                  style: context.textTheme.titleMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Text(
              item.content,
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnnouncementContainer(BuildContext context) {
    return SchoolLifeBaseContainer(
      item: item,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.header, style: context.textTheme.titleMedium),
                Icon(
                  Icons.campaign_outlined,
                  color: context.theme.colorScheme.onSecondary,
                ),
              ],
            ),
          ),
          Divider(
            color: context.theme.colorScheme.onTertiary,
            indent: 15,
            endIndent: 15,
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              item.content,
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (item.type == ItemType.EVENT) {
      return buildEventContainer(context);
    } else if (item.type == ItemType.ARTICLE) {
      return buildArticleContainer(context);
    } else {
      return buildAnnouncementContainer(context);
    }
  }
}

class SchoolLifeBaseContainer extends StatelessWidget {
  final SchoolLifeItem item;
  final Widget child;

  const SchoolLifeBaseContainer(
      {required this.item, required this.child, Key? key})
      : super(key: key);

  void onPressedItem() async {
    if (item.articleElements.isNotEmpty) {
      Get.toNamed("/articles", arguments: item);
    } else {
      await url_launcher.launch(item.hyperlink);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: item.hyperlink.isNotEmpty || item.articleElements.isNotEmpty
          ? onPressedItem
          : null,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 1,
            ),
          ],
          color: context.theme.colorScheme.tertiary,
        ),
        child: Column(
          children: [
            child,
            if (item.hyperlink.isNotEmpty)
              Container(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                alignment: Alignment.centerRight,
                child: Text(
                  "home/read_more".tr,
                  style: context.textTheme.labelSmall,
                ),
              ),
            Divider(
              color: context.theme.colorScheme.onTertiary,
              indent: 15,
              endIndent: 15,
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ("home/" + item.type.toString()).tr,
                    style: Get.textTheme.bodySmall!
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    DateFormat.yMMMMEEEEd(Get.locale.toString())
                        .format(item.datetime),
                    style: Get.textTheme.bodySmall!
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
