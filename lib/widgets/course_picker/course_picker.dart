import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import './course_picker_controller.dart';

import '../settings_ui/settings_switch_tile.dart';

// ###################################################################################
// #                             MODAL BOTTOM SHEET                                  #
// ###################################################################################
Future<String?> showCoursePicker(BuildContext context) async {
  String input;

  if (context.isTablet) {
    input = await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: context.theme.canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
          child: const CoursePicker(),
        ),
      ),
    );
  } else {
    input = await showModalBottomSheet(
      backgroundColor: context.theme.canvasColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
      context: context,
      builder: (context) => const CoursePicker(),
    );
  }
  Get.delete<CoursePickerController>();

  return input;
}

class CoursePicker extends StatelessWidget {
  const CoursePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CoursePickerController());
    return GetBuilder<CoursePickerController>(
      builder: (controller) => ListView(
        physics: const ClampingScrollPhysics(),
        children: [
// ###################################################################################
// #                           BOTTOM SHEET CONTROLS                                 #
// ###################################################################################
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: controller.cancel,
                icon: Icon(Icons.close, color: context.theme.primaryColor),
                splashRadius: 20,
              ),
              Expanded(
                child: Text(
                  "settings/notifications/pick_substitutions".tr,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyText2!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              IconButton(
                onPressed: controller.done,
                icon: Icon(Icons.done, color: context.theme.primaryColor),
                splashRadius: 20,
              ),
            ],
          ),
          // const Divider(height: 0),
// ###################################################################################
// #                                       PICKER                                    #
// ###################################################################################
          Column(
            children: [
              SizedBox(
                height: 150,
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 30,
                        scrollController: FixedExtentScrollController(
                          initialItem: controller.currentCourse,
                        ),
                        children: controller.courses.map((e) {
                          return Text(e,
                              style: TextStyle(
                                color: context.textTheme.bodyText2!.color,
                                fontSize: 25,
                              ));
                        }).toList(),
                        onSelectedItemChanged: controller.onCourseChanged,
                      ),
                    ),
                    Expanded(
                      child: controller.includeLetters
                          ? CupertinoPicker(
                              itemExtent: 30,
                              scrollController: FixedExtentScrollController(
                                initialItem: controller.currentLetter,
                              ),
                              children: controller.letters.map((e) {
                                return Text(e,
                                    style: TextStyle(
                                      color: context.textTheme.bodyText2!.color,
                                      fontSize: 25,
                                    ));
                              }).toList(),
                              onSelectedItemChanged: controller.onLetterChanged,
                            )
                          : const Center(child: Icon(Icons.remove)),
                    ),
                  ],
                ),
              ),
              if (controller.isGrade)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SettingsSwitchTile(
                    label: "settings/filters/inst".tr,
                    onChanged: controller.onChangedInstrumental,
                    value: controller.instrumental,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
