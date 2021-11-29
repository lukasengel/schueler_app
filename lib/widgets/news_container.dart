import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class NewsContainer extends StatelessWidget {
  final List<String> text;
  const NewsContainer({Key? key, required this.text}) : super(key: key);

  String insertDayOfWeek(String text) {
    RegExp regex = RegExp(r"\d\d\.\d\d\.\d\d\d\d");
    final match = regex.firstMatch(text);
    if (match != null) {
      final dateString = text.substring(match.start, match.end);
      final formatter = DateFormat(r"d.M.y");
      final datetime = formatter.parse(dateString);
      final dow = DateFormat("EEEE");
      text = text.substring(0, match.start) +
          dow.format(datetime).toLowerCase().tr +
          ", " +
          dateString;
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final bool entry = text.length > 2;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
        color: Get.theme.cardColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (entry) const SizedBox(height: 10),
          Text(
            insertDayOfWeek(text[0]),
            style: Theme.of(context).textTheme.headline4,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                color: Get.textTheme.bodyText2!.color,
                indent: 30,
                endIndent: 30,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  entry ? text[1] : text.last,
                  textAlign: TextAlign.left,
                  style: Get.textTheme.bodyText2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
