import 'package:intl/intl.dart';

class _TimeHelper {
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
