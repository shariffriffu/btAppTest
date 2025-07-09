import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mybtapp_testapp_testapp_test/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/global.dart';
import 'package:mybtapp_testapp_testapp_test/phase/NewScreens/login.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/getDate&Time';
import 'package:mybtapp_testapp_testapp_test/phase/Services/ipConfig.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/gen_ref_ID.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/getHeaders.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/showLoading.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/encryption_decryption_function.dart';

class SplashScreenP2 extends StatefulWidget {
  @override
  _SplashScreenP2State createState() => _SplashScreenP2State();
}

class _SplashScreenP2State extends State<SplashScreenP2> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
   
  }

  Future<void> _authenticate() async {
    String imeiNo = await getDeviceInfo() ?? generateRandomString(10);

    try {
      deviceIdFirstThree = imeiNo.substring(5, 8);
    } catch (_) {
      deviceIdFirstThree = generateRandomString(3);
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    var headers = await getHeaders();
    headers['H5'] = encodeFunction("10");

    String apiUrl = "${decodeFunction(getFCGI_IP())}/authCustomer";

    var body = {
      "BT": encodeFunction(jsonEncode({
        "APPVERSION": version,
        "REQTIME": getFormattedTimestamp(),
        "REQTYPE": encodeFunction("10"),
        "CUSTOMERTYPE": 5,
        "OPERATION": "AUTHORIZATION",
        "REFID": genrefId(),
      }))
    };

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        authResponse = jsonDecode(decodeFunction(responseData["BT"]));

        switch (authResponse['RESPONSE']['RESPCODE']) {
          case "0000":
            _navigateToLogin();
            break;
          case "1002":
            forceUpdate(context, authResponse['RESPONSE']['RESPDESC']);
            break;
          case "1003":
            optionalUpdate(context, authResponse['RESPONSE']['RESPDESC']);
            break;
          case "1004":
            serverDown(context, authResponse['RESPONSE']['RESPDESC']);
            break;
          default:
            showPopup(context, SERVER_DOWN);
        }
      } else {
        showPopup(context, SERVER_ERROR);
      }
    } catch (e) {
      // sendCrashReport('Auth error: $e');
      // showPopup(context, SERVER_ERROR);
    }
  }

  void _navigateToLogin() {
    navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              "lib/phase/images/splashScreen.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.33,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                "lib/phase/images/logoLight.png",
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
