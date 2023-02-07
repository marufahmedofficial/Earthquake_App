import 'package:intl/intl.dart';

String getFormattedDate(num date) {
  return DateFormat.yMMMMd()
      .format(DateTime.fromMillisecondsSinceEpoch(date.toInt()));
}