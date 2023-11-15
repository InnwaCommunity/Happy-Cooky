class TotalBalanceModel {
  String totalbalanceid;
  String totalbalance;
  String totaldes;
  String insertdate;
  String starttimerangedate;
  String endtimerangedate;
  String sharestatus;

  TotalBalanceModel(
      {required this.totalbalanceid,
      required this.totalbalance,
      required this.totaldes,
      required this.insertdate,
      required this.starttimerangedate,
      required this.endtimerangedate,
      required this.sharestatus});

  Map<String, dynamic> toMap() {
    return {
      'totalbalanceid': totalbalanceid,
      'totalbalance': totalbalance,
      'totaldes': totaldes,
      'insertdate': insertdate,
      'starttimerangedate': starttimerangedate,
      'endtimerangedate': endtimerangedate,
      'sharestatus': sharestatus,
    };
  }

  factory TotalBalanceModel.fromMap(Map<String, dynamic> map) {
    return TotalBalanceModel(
      totalbalanceid: map['totalbalanceid'],
      totalbalance: map['totalbalance'],
      totaldes: map['totaldes'],
      insertdate: map['insertdate'],
      starttimerangedate: map['starttimerangedate'],
      endtimerangedate: map['endtimerangedate'],
      sharestatus: map['sharestatus'],
    );
  }
}
