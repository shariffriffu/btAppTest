import 'dart:convert';
import '../global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../global/variableDeclaration.dart';
import 'package:mybtapp_testapp_testapp_test/global/fetchPages.dart';




class ThemeProvider extends ChangeNotifier {
  Color primaryColor = Colors.blue;
  Color secondaryColor = Colors.blueAccent;
  Color cardBackground = Colors.white;
  Color iconColor = Colors.black;
  Color starActiveColor = Colors.amber;
  Color starInactiveColor = Colors.grey;
  Color errorColor = Colors.red;

  String fontFamily = 'Gilroy';
  String buttonType = 'elevated'; // default fallback
  String textType = 'typeA'; // default fallback

  Color textColor = Colors.black;
  double textSize = 16.0;
  FontWeight textWeight = FontWeight.normal;

  late Map<String, dynamic> _globleProperties;
  late Map<String, dynamic> _widgetProperties;
  Map<String, dynamic> buttonProperties = {};
  Map<String, dynamic> IconInRowProperties = {};
  Map<String, dynamic> amountCardProperties = {};
  Map<String, dynamic> learnVideosProperties = {};
  Map<String, dynamic> textProperties = {};
  late TextStyle buttonLabelStyle;

  ThemeProvider() {
    loadTheme();
  }

  get toggleProperties => null;

  Future<void> loadTheme() async {
    // String response =
    //     await rootBundle.loadString('lib/phase/jsons/properties.json');

    String? response = await FetchPages.getPageByName("properties.json");

    _globleProperties = json.decode(response!);

    registry.setValue("_globleProperties", _globleProperties);
    _globleProperties = registry.getValue('_globleProperties');
   
    // String configString =
    //     await rootBundle.loadString('lib/phase/jsons/widgetConfig.json');

    String? configString = await FetchPages.getPageByName("widgetConfig.json");
    _widgetProperties = json.decode(configString!);
    registry.setValue("_widgetProperties", _widgetProperties);
    _widgetProperties = registry.getValue('_widgetProperties');
   

    //colors
    primaryColor = _parseColor(_globleProperties["primaryColor"]);
    secondaryColor = _parseColor(_globleProperties["secondaryColor"]);
    cardBackground = _parseColor(_globleProperties["cardBackground"]);
    iconColor = _parseColor(_globleProperties["iconColor"]);
    starActiveColor = _parseColor(_globleProperties["starActiveColor"]);
    starInactiveColor = _parseColor(_globleProperties["starInactiveColor"]);
    errorColor = _parseColor(_globleProperties["errorColor"]);

    // font family
    String fontType = "typeA";
    fontFamily = 'Gilroy';
    logger.i("fontType: $fontType");
    logger.i("fontFamily: $fontFamily");

    // button type
    String buttonTypeKey = _globleProperties["buttonType"] ?? "typeA";
    buttonType = _widgetProperties["buttonTypes"]?[buttonTypeKey] ?? 'elevated';
    buttonProperties = _widgetProperties["buttonProperties"] ?? {};
    IconInRowProperties = _widgetProperties["IconInRowProperties"] ?? {};

    amountCardProperties = _widgetProperties["amountCardProperties"] ?? {};
    learnVideosProperties = _widgetProperties["learnVideosProperties"] ?? {};

    // Text properties
    final textProps = _widgetProperties["textFieldProperties"] ?? {};
    textProperties = _widgetProperties["textFieldProperties"] ?? {};

    textColor = _parseColor(textProps["fontColor"] ?? "#000000");
    textSize = (textProps["fontSize"] ?? 16).toDouble();
    textWeight = parseFontWeight(textProps["fontWeight"] ?? "normal");

    notifyListeners();
  }

  Color _parseColor(String hexCode) {
    hexCode = hexCode.replaceAll("#", "");
    if (hexCode.length == 6) {
      hexCode = "FF$hexCode";
    }
    return Color(int.parse("0x$hexCode"));
  }
}
