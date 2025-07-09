import 'dart:convert';
import 'package:mybtapp_testapp_testapp_test/global/fetchPages.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/global.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/variableDeclaration.dart';



bool loaded = false;
Map<String, dynamic> ipData = {};

Future<void> loadIpConfigData() async {
  loaded = true;
  try {
    //final String response = await rootBundle.loadString('lib/assets/config.json');
    final String? response = await FetchPages.getPageByName("config.json");
    ipData = jsonDecode(response!);
  } catch (e) {
    ipData = {};
  }
  logger.i("loadData: $ipData");
}

String getFCGI_IP() {
  if (!loaded) {
    loadIpConfigData();
  }
  logger.i("inside getFCGI: $ipData ${ipData[ipData['SELECTED']]['FCGI']}");
  return ipData[ipData['SELECTED']]['FCGI'];
}

String getWOE_IP() {
  if (!loaded) {
    loadIpConfigData();
  }
  logger.i("WOE IP: ${authResponse['APIURLWOE'] ?? "Could not fetch"}");
  return authResponse['APIURLWOE'] ?? "";
}

Future<String> getPageConfig() async {
  if (!loaded) {
    await loadIpConfigData();
  }
  logger.i("ipData from getPageConfig: $ipData");
  return ipData[ipData['SELECTED']]['PAGE_CONFIG'];
}
