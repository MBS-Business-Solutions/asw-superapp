import 'package:intl/intl.dart';

class DateFormatterUtil {
  static String format(DateTime date, {String? locale}) {
    int year = date.year;
    if (locale == 'th') {
      year += 543;
    }
    return '${DateFormat('dd MMM', locale).format(date)} $year';
  }
}
