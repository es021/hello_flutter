import 'package:intl/intl.dart';

class _TimeHelper {
  int currentTimeInSeconds() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  int currentMonth() {
    var now = new DateTime.now();
    var formatter = new DateFormat('MM');
    String m = formatter.format(now);
    return int.parse(m);
  }

  String getMonthText(int month) {
    return {
      1: "January",
      2: "February",
      3: "March",
      4: "April",
      5: "May",
      6: "June",
      7: "July",
      8: "August",
      9: "September",
      10: "October",
      11: "November",
      12: "December",
    }[month];
  }

  int currentYear() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy');
    String y = formatter.format(now);
    return int.parse(y);
  }

  String getString(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('yyyy-MM-dd   HH:mm:ss a');
    // print(timestamp);
    // print(format.format(new DateTime.fromMicrosecondsSinceEpoch((timestamp * 1000).round())));
    // print(format.format(new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)));
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';
    // print(diff);

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'day ago';
      } else {
        time = diff.inDays.toString() + 'days ago';
      }
    }

    return time;
  }
}

final TimeHelper = _TimeHelper();
