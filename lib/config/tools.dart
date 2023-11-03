import 'package:easy_localization/easy_localization.dart';

class Tools {
  static String ymdhmsDateFormat() {
    final DateTime now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  static String formatCommaSeparator(String txt) {
    try {
      final formatter = NumberFormat("#,##0", "en_US");
      return formatter.format(double.parse(removeCommaSeparator(txt)));
    } catch (error) {
      return txt;
    }
  }

  static String removeCommaSeparator(String txt) {
    return txt.replaceAll(',', '');
  }
}
