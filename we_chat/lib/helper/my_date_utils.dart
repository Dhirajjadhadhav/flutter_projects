import 'package:flutter/material.dart';

class MyDateUtil {
  //for getting formatted time from MillisecondsSinceEpoch string
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  //for last message time (used in chat user card)
  static String getLastMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime send = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == send.day && now.month == send.month && now.year == send.year)
      return TimeOfDay.fromDateTime(send).format(context);

    return '${send.day} ${_getMonth(send)}';
  }

  //get month name from month no. or index

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }

    return 'NA';
  }
}
