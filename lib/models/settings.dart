enum ColorMode { LIGHT, SYSTEM, DARK }

class Settings {
  String username;
  String password;
  Map<String, dynamic> filters;
  List<String> notifications;
  bool reversedNews;
  bool reversedSmv;
  bool dailyNotifications;
  bool smvNotifications;
  bool broadcastNotifications;
  bool forceGerman;
  bool jumpToNextDay;
  bool androidAlternativeTransition;
  ColorMode selectedTheme;

  Settings({
    required this.username,
    required this.password,
    required this.filters,
    required this.notifications,
    required this.reversedNews,
    required this.reversedSmv,
    required this.dailyNotifications,
    required this.smvNotifications,
    required this.broadcastNotifications,
    required this.forceGerman,
    required this.jumpToNextDay,
    required this.androidAlternativeTransition,
    required this.selectedTheme,
  });
}
