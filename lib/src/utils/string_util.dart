import 'package:intl/intl.dart';

class StringUtil {
  static String capitalize(String? s) {
    if (s == null) return '';
    return s[0].toUpperCase() + s.substring(1);
  }

  static String phoneFormatter(String phone, {String? hiddenChar}) {
    phone = phone.replaceAll(RegExp(r'-'), '');
    var tmpPhone = '$phone          '.substring(0, 10);
    if (hiddenChar != null) {
      tmpPhone = tmpPhone.replaceRange(0, 6, hiddenChar * 6);
    }
    return '${tmpPhone.substring(0, 2)}-${tmpPhone.substring(2, 6)}-${tmpPhone.substring(6, 10)}';
  }

  static String markHiddenEmail(String email) {
    if (email.isEmpty) return '';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    final hiddenName = '${name.substring(0, 1)}xxxx${name.length >= 2 ? name.substring(name.length - 1) : ''}';
    return '$hiddenName@$domain';
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
