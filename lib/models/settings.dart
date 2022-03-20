enum ColorMode {LIGHT, SYSTEM, DARK}

class Settings {
  String username, password;
  Map<String, dynamic> filters;
  List<String> notifications;
  bool reversedNews,
      reversedSmv,
      dailyNotifications,
      smvNotifications,
      broadcastNotifications,
      forceGerman;
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
    required this.selectedTheme,
  });
}
