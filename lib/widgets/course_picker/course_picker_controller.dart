import 'package:get/get.dart';

class CoursePickerController extends GetxController {
  final courses = [
    '5',
    '6',
    '7',
    '8',
    '9',
    "10",
    "11",
    "12",
    "Wku",
    "Fku",
    "OGTS",
    "GGTS"
  ];
  final letters = ['A', 'B', 'C', 'D', 'E'];

  bool includeLetters = true;
  bool isGrade = true;
  bool instrumental = false;

  int currentCourse = 0;
  int currentLetter = 0;

  void cancel() async {
    Get.back();
  }

  void done() async {
    final result = (instrumental ? "i" : "") +
        courses[currentCourse] +
        (instrumental || !includeLetters ? "" : letters[currentLetter]);
    Get.back(result: result);
  }

  void onCourseChanged(int index) {
    currentCourse = index;
    includeLetters = index <= 5;
    isGrade = index <= 7;
    update();
  }

  void onLetterChanged(int index) => currentLetter = index;

  Future<bool> onChangedInstrumental() async {
    instrumental = !instrumental;
    return instrumental;
  }
}
