import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/web_data/news_item.dart';

class NewsContainer extends StatelessWidget {
  final NewsItem item;
  const NewsContainer({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formatDate(String text) {
      bool entry = text.contains("Eintrag");
      RegExp regex = RegExp(r"\d\d\.\d\d\.\d\d\d\d");
      final match = regex.firstMatch(text);
      if (match != null) {
        final dateString = text.substring(match.start, match.end);
        final formatter = DateFormat(r"d.M.y");
        final datetime = formatter.parse(dateString);

        String date;
        if (Get.locale.toString() == "en_US") {
          date =
              DateFormat("EEEE, M/d/y", Get.locale.toString()).format(datetime);
        } else {
          date =
              DateFormat("EEEE, d.M.y", Get.locale.toString()).format(datetime);
        }

        text = entry ? "home/entry".tr + date : date;
      }
      return text;
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
        color: Get.theme.colorScheme.tertiary,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formatDate(item.headline),
            style: Theme.of(context).textTheme.headlineSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Divider(
            color: Get.theme.colorScheme.onTertiary,
            indent: 30,
            endIndent: 30,
          ),
          const SizedBox(height: 10),
          if (item.subheadline.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                item.subheadline,
                textAlign: TextAlign.left,
                style: Get.textTheme.bodyLarge,
              ),
            ),
          if (item.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                item.content,
                textAlign: TextAlign.left,
                style: Get.textTheme.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }
}
