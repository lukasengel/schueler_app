import 'package:get/get.dart';

import './pages/home_page/home_page.dart';
import './pages/login_page/login_page.dart';
import './pages/settings_page/settings_page.dart';
import './pages/settings_page/settings_subpages/filters_page/filters_page.dart';
import './pages/settings_page/settings_subpages/personalizations_page/personalization_page.dart';
import './pages/settings_page/settings_subpages/report_a_bug_page/report_bug_page.dart';
import './pages/settings_page/settings_subpages/abbreviations_page/abbreviations_page.dart';
import './pages/settings_page/settings_subpages/notifications_page/notifications_page.dart';

const home = HomePage.route;
const login = LoginPage.route;
const settings = SettingsPage.route;
const filters = FiltersPage.route;
const personalization = PersonalizationPage.route;
const report_bug = ReportBugPage.route;
const abbreviations = AbbreviationsPage.route;
const notifications = NotificationsPage.route;

final getPages = [
  GetPage(name: home, page: () => const HomePage()),
  GetPage(name: login, page: () => const LoginPage()),
  GetPage(name: settings, page: () => const SettingsPage()),
  GetPage(name: filters, page: () => const FiltersPage()),
  GetPage(name: personalization, page: () => const PersonalizationPage()),
  GetPage(name: report_bug, page: () => const ReportBugPage()),
  GetPage(name: abbreviations, page: () => const AbbreviationsPage()),
  GetPage(name: notifications, page: () => const NotificationsPage()),
];
