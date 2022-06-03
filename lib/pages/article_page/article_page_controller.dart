import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ArticlePageController extends GetxController {
  void launchUrl(String url) async {
    await url_launcher.launch(url);
  }
}
