class StringUtil {
  static String capitalize(String s) {
    return s[0].toUpperCase() + s.substring(1);
  }

  static String phoneFormatter(String phone) {
    phone = phone.replaceAll(RegExp(r'\D'), '');
    final tmpPhone = '$phone          '.substring(0, 10);
    return '${tmpPhone.substring(0, 3)}-${tmpPhone.substring(3, 6)}-${tmpPhone.substring(6, 10)}';
  }
}
