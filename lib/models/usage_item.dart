class UsageItem {
  String usageitemid;
  String totalbalance;
  String usageamount;
  String remainingbalance;
  String insertdate;
  String shareStatus;
  String usagetype;

  UsageItem(
      {required this.usageitemid,
      required this.totalbalance,
      required this.usageamount,
      required this.remainingbalance,
      required this.insertdate,
      required this.shareStatus,
      required this.usagetype});

  Map<String, dynamic> toMap() {
    return {
      'usageitemid': usageitemid,
      'totalbalance': totalbalance,
      'usageamount': usageamount,
      'remainingbalance': remainingbalance,
      'insertdate': insertdate,
      'shareStatus': shareStatus,
      'usagetype': usagetype
    };
  }

  factory UsageItem.fromMap(Map<String, dynamic> map) {
    return UsageItem(
      usageitemid: map['usageitemid'] ?? '',
      totalbalance: map['totalbalance'] ?? '0',
      usageamount: map['usageamount'] ?? '0',
      remainingbalance: map['remainingbalance'] ?? '0',
      insertdate: map['insertdate'] ?? '',
      shareStatus: map['shareStatus'] ?? 'false',
      usagetype: map['usagetype'] ?? 'expense',
    );
  }
}
