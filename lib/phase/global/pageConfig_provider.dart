import 'global.dart';
import 'dart:convert';
import 'variableDeclaration.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mybtapp_testapp_testapp_test/global/fetchPages.dart';



class PageConfigProvider with ChangeNotifier {
  Map<String, dynamic> _config = {};

  Map<String, dynamic> get config => _config;

  Future<void> loadConfig() async {
    // final jsonString =
    //     await rootBundle.loadString('lib/phase/jsons/properties.json');
    final String? response = await FetchPages.getPageByName("properties.jsonn");

    _config = json.decode(response!);
    notifyListeners();
  }

  Color getColor(String key, {Color fallback = Colors.black}) {
    final value = _config[key];

    if (value is String) {
      try {
        return parseColor(value);
      } catch (e) {
        logger.e("Error parsing color string for in 1 '$key': $e");
      }
    } else if (value is int) {
      try {
        return Color(value);
      } catch (e) {
        logger.e("Error parsing color int for '$key': $e");
      }
    }

    return fallback;
  }
}
