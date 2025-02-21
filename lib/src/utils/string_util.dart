import 'package:intl/intl.dart';

class StringUtil {
  static String capitalize(String? s) {
    if (s == null) return '';
    return s[0].toUpperCase() + s.substring(1);
  }

  static String phoneFormatter(String phone) {
    phone = phone.replaceAll(RegExp(r'\D'), '');
    final tmpPhone = '$phone          '.substring(0, 10);
    return '${tmpPhone.substring(0, 3)}-${tmpPhone.substring(3, 6)}-${tmpPhone.substring(6, 10)}';
  }

  static String formatNumber(String number) {
    if (number.isEmpty) return '';
    final formatter = NumberFormat('#,###.00');
    return formatter.format(double.parse(number));
  }

  static String removeSymbol(String number) {
    if (number.isEmpty) return '';
    return number.replaceAll(RegExp(r'[^0-9.]'), '');
  }
}
