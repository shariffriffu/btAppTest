import 'package:mybtapp_testapp_testapp_test/phase/Services/global.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/variableDeclaration.dart';




int i = 1;

String genrefId() {
  DateTime now = DateTime.now();

  int month = now.month;
  int day = now.day;
  int hour = now.hour;
  int minute = now.minute;
  int second = now.second;

  // Increment `i` and reset if necessary
  if (i < 9) {
    i++;
  } else {
    i = 1;
  }

  // Generate the combined string
  String refDeviceID = deviceIdFirstThree == ""
      ? i.toString()
      : "${deviceIdFirstThree + i.toString().substring(0, 1)}";
  String combined = refDeviceID +
      month.toString().padLeft(2, '0') +
      day.toString().padLeft(2, '0') +
      hour.toString().padLeft(2, '0') +
      minute.toString().padLeft(2, '0') +
      second.toString().padLeft(2, '0');

  // Remove dots
  String result = combined.replaceAll(".", i.toString());

  // Replace alphabetic characters with `i`
  result = result.replaceAll(RegExp(r'[a-zA-Z]'), i.toString());

  logger.i("result ref ID: $result");
  return result;
}
