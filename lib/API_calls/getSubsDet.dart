import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mybtapp_testapp_testapp_test/main.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/global.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/getDate&Time';
import 'package:mybtapp_testapp_testapp_test/phase/Services/gen_ref_ID.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/getHeaders.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/showLoading.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/variableDeclaration.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/encryption_decryption_function.dart';

Future<Map<String, dynamic>> BT_getCustomerDet(
    String serviceType, String serviceNumber) async {
  Map<String, String> headers = await getHeaders();
  headers['H5'] = encodeFunction("170");
  var parentJSON = {};
  var childJSON = {
    "SOURCEPARTY": loggedInMobile,
    "SERVNUM": serviceNumber,
    "SERVICETYPE": serviceType,
    "5G_FLAG": "0",
    "SESSIONID": loggedInSessionId,
    "REQTYPE": "170",
    "OPERATION": "GETCUSTOMDET",
    "REQTIME": getFormattedTimestamp(),
    "REFID": genrefId(),
    "CHECKSUM":
        "UWdGmShv/zLsFCY1aO9acIYJWkNL6I/H2S+xvY/OpxraD2rT0X+n4K4K7xIH+qAA"
  };

  logger.d("GetCustomerDET ::TBR $childJSON");

  String apiUrl = "${authResponse['APIURL']}BT_getCustomerDet";
  try {
    parentJSON["BT"] = encodeFunction(jsonEncode(childJSON));
    logger.i("getSubsDet $parentJSON $headers");
    http.Response response = await http
        .post(Uri.parse(apiUrl), headers: headers, body: jsonEncode(parentJSON))
        .timeout(Duration(seconds: int.parse(TIMEOUT_SECONDS)), onTimeout: () {
      // Handle the timeout case
      logger.e("Request timed out");
      return http.Response('Error: Request timed out',
          408); // Return a response with status 408 (Request Timeout)
    });
    logger.i(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String decodedResponse = decodeFunction(responseData["BT"].toString());
      logger.i(decodedResponse);
      return jsonDecode(decodedResponse);
    } else if (response.statusCode == 408) {
      logger.e("timeout");
      return {};
    } else {
      logger.i(
          'Request failed with status: ${response.statusCode}${response.body}');
      Navigator.pop(navigatorKey.currentContext!);
      showPopup(navigatorKey.currentContext!, SERVER_ERROR);
    }
  } catch (error) {
    logger.i('Error: $error');
  }

  return {};
}
