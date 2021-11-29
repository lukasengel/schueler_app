class Settings {
  String username;
  String password;
  bool sortingAZ;
  int themeColor;
  List<String> filters;

  Settings({
    required this.username,
    required this.password,
    required this.themeColor,
    required this.sortingAZ,
    required this.filters,
  });

  Settings.empty()
      : username = "",
        password = "",
        themeColor = 1,
        sortingAZ = true,
        filters = [];
}
