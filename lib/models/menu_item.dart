class MenuItem {
  String menuid;
  String menuname;
  String menuprice;
  String menudesc;
  String menuitemdate;
  String shareStatus;

  MenuItem({
    required this.menuid,
    required this.menuname,
    required this.menuprice,
    required this.menudesc,
    required this.menuitemdate,
    required this.shareStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'menuid': menuid,
      'menuname': menuname,
      'menuprice': menuprice,
      'menudesc': menudesc,
      'date': menuitemdate,
      'shareStatus': shareStatus,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      menuid: map['menuid'],
      menuname: map['menuname'],
      menuprice: map['menuprice'],
      menudesc: map['menudesc'],
      menuitemdate: map['menuitemdate'],
      shareStatus: map['shareStatus'],
    );
  }
}
