class Settings {
  String username;
  String password;
  bool reversed;
  int themeColor;
  List<String> filters;

  Settings({
    required this.username,
    required this.password,
    required this.themeColor,
    required this.reversed,
    required this.filters,
  });

  Settings.empty()
      : username = "",
        password = "",
        themeColor = 1,
        reversed = true,
        filters = [];
}
