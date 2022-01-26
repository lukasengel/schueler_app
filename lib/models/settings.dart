class Settings {
  String username;
  String password;
  bool reversed;
  int themeColor;
  Map<String, dynamic> filters;
  bool dailyNotifications, smvNotifications;
  List<String> notifications;
  bool forceGerman;

  Settings({
    required this.username,
    required this.password,
    required this.themeColor,
    required this.reversed,
    required this.filters,
    required this.dailyNotifications,
    required this.smvNotifications,
    required this.notifications,
    required this.forceGerman,
  });

  Settings.empty()
      : username = "",
        password = "",
        themeColor = 1,
        reversed = true,
        filters = defaultFilters,
        dailyNotifications = false,
        smvNotifications = false,
        notifications = [],
        forceGerman = false;

  static Map<String, bool> get defaultFilters {
    return {
      "5": true,
      "6": true,
      "7": true,
      "8": true,
      "9": true,
      "10": true,
      "11": true,
      "12": true,
      "i": true,
      "Wku": true,
      "Fku": true,
      "OGTS": true,
      "GGTS": true,
      "misc": true,
    };
  }

  static String get defaultFiltersStr {
    return """{"5": true,"6": true,"7": true,"8": true,"9": true,"10": true,"11": true,"12": true,"i": true,"Wku": true,"Fku": true,"OGTS": true,"GGTS": true,"misc": true}""";
  }
}
