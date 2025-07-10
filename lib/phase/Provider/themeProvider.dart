import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../global/variableDeclaration.dart';
import 'package:mybtapp_testapp_testapp_test/global/fetchPages.dart';

class ThemeProvider extends ChangeNotifier {
  // General theme colors
  Color primaryColor = Colors.blue;
  Color secondaryColor = Colors.blueAccent;
  Color cardBackground = Colors.white;
  Color iconColor = Colors.black;
  Color starActiveColor = Colors.amber;
  Color starInactiveColor = Colors.grey;
  Color errorColor = Colors.red;

  // Font
  String fontFamily = 'Gilroy';

  // Widget types
  String buttonType = 'elevated';
  String textType = 'typeA';

  // Text style defaults
  Color textColor = Colors.black;
  double textSize = 16.0;
  FontWeight textWeight = FontWeight.normal;

  // Widget-specific styling
  late Map<String, dynamic> _globleProperties;
  late Map<String, dynamic> _widgetProperties;

  Map<String, dynamic> buttonProperties = {};
  Map<String, dynamic> IconInRowProperties = {};
  Map<String, dynamic> amountCardProperties = {};
  Map<String, dynamic> learnVideosProperties = {};
  Map<String, dynamic> textProperties = {};

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      String? globalJson = prefs.getString('properties.json');
      String? widgetJson = prefs.getString('widgetConfig.json');

      // Fallback if not found in SharedPreferences
      if (globalJson == null || widgetJson == null) {
        logger.w("Theme JSON not found in SharedPreferences. Fetching from FetchPages...");

        globalJson = await FetchPages.getPageByName("properties.json");
        widgetJson = await FetchPages.getPageByName("widgetConfig.json");

        if (globalJson == null || widgetJson == null) {
          logger.e("Theme config missing even after FetchPages");
          return;
        }

        // Store to SharedPreferences for future use
        await prefs.setString('properties.json', globalJson);
        await prefs.setString('widgetConfig.json', widgetJson);
        logger.i("Theme JSON saved to SharedPreferences");
      }

      _globleProperties = json.decode(globalJson);
      _widgetProperties = json.decode(widgetJson);

      registry.setValue("_globleProperties", _globleProperties);
      registry.setValue("_widgetProperties", _widgetProperties);

      // Colors
      primaryColor = _parseColor(_globleProperties["primaryColor"] ?? "#2196F3");
      secondaryColor = _parseColor(_globleProperties["secondaryColor"] ?? "#448AFF");
      cardBackground = _parseColor(_globleProperties["cardBackground"] ?? "#FFFFFF");
      iconColor = _parseColor(_globleProperties["iconColor"] ?? "#000000");
      starActiveColor = _parseColor(_globleProperties["starActiveColor"] ?? "#FFD700");
      starInactiveColor = _parseColor(_globleProperties["starInactiveColor"] ?? "#BDBDBD");
      errorColor = _parseColor(_globleProperties["errorColor"] ?? "#FF0000");

      // Font
      final fontType = _globleProperties["fontType"] ?? "typeA";
      fontFamily = _globleProperties["fontFamily"] ?? "Gilroy";

      logger.i("fontType: $fontType");
      logger.i("fontFamily: $fontFamily");

      // Widgets
      buttonProperties = _widgetProperties["buttonProperties"] ?? {};
      IconInRowProperties = _widgetProperties["IconInRowProperties"] ?? {};
      amountCardProperties = _widgetProperties["amountCardProperties"] ?? {};
      learnVideosProperties = _widgetProperties["learnVideosProperties"] ?? {};

      // TextField
      textProperties = _widgetProperties["textFieldProperties"] ?? {};
      textColor = _parseColor(textProperties["fontColor"] ?? "#000000");
      textSize = _safeDouble(textProperties["fontSize"], 16);
      textWeight = parseFontWeight(textProperties["fontWeight"] ?? "normal");

      notifyListeners();
    } catch (e, stack) {
      logger.e("Error loading theme: $e\n$stack");
    }
  }

  Color _parseColor(String hexCode) {
    hexCode = hexCode.replaceAll("#", "");
    if (hexCode.length == 6) {
      hexCode = "FF$hexCode";
    }
    return Color(int.parse("0x$hexCode"));
  }

  double _safeDouble(dynamic value, double fallback) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  FontWeight parseFontWeight(String value) {
    switch (value.toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      default:
        return FontWeight.normal;
    }
  }
}
