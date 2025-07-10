import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:mybtapp_testapp_testapp_test/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mybtapp_testapp_testapp_test/global/fetchPages.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/global.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/global.dart';
import 'package:mybtapp_testapp_testapp_test/phase/NewScreens/login.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/getDate&Time';
import 'package:mybtapp_testapp_testapp_test/phase/Services/ipConfig.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/gen_ref_ID.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/getHeaders.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/showLoading.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/variableDeclaration.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/encryption_decryption_function.dart';


// // import 'package:mybtapp_test/Services/fetchPages.dart';

class SplashScreenP2 extends StatefulWidget {
  @override
  _SplashScreenP2State createState() => _SplashScreenP2State();
}

class _SplashScreenP2State extends State<SplashScreenP2> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    //  await Future.delayed(const Duration(seconds: 2));
    //LAB
    // await FetchPages.fetchPagesFromAPI("https://tayana.in:3004", "1074");
    // await FetchPages.fetchPagesFromAPI("https://btapp165.tayana.in", "1074");

    // TQA
    // await FetchPages.fetchPagesFromAPI(
    //     "https://106.51.72.98:8051", "1074");

    // TQANEW
    // await FetchPages.fetchPagesFromAPI("http://106.51.72.98:8052", "1078");

    // TB
    // await FetchPages.fetchPagesFromAPI("http://202.144.156.10:4000", "1076");
    await configureAndFetchPages();

    // LIVENEW
    // await FetchPages.fetchPagesFromAPI("http://202.144.156.90:4000", "1078");

    // LIVE
    // await FetchPages.fetchPagesFromAPI(
    //     "https://mybtapp_test.bt.bt:4000", "1074");

    // LIVE HTTPS
    // await FetchPages.fetchPagesFromAPI("https://mybtapp_testapp.bt:4000", "1078");

    // =================================================================================== //

    // LAB
    // await FetchPages.fetchPagesFromAPI(
    //     decodeFunction("aXZ3dHhANjc6OkE6Qj89R0NATExPSUdITUmLfYSDkk9um2V4"),
    //     decodeFunction(
    //         "aXZ3dHhANjc6OkE6Qj89R0NATExPSUdITUmRgY+RiI+PT4aTk4yQj1h3pG6B"));

    //LAB
    // await FetchPages.fetchPagesFromAPI("https://106.51.72.98:3004", "1068");

    //TQA
    // await FetchPages.fetchPagesFromAPI(
    //     decodeFunction("aXZ3dHhANjc6OkE6Qj89R0NATExPTkdNSkmLfYSDkk9um2V4"),
    //     decodeFunction(
    //         "aXZ3dHhANjc6OkE6Qj89R0NATExPTkdNSkmRgY+RiI+PT4aTk4yQj1h3pG6B"));

    //TB
    // await FetchPages.fetchPagesFromAPI(
    //     decodeFunction("aXZ3dD81Njo5PDk9QUI9QUZIQUVFUEtISUpKjH6FhJNQb5xmeQ=="),
    //     decodeFunction(
    //         "aXZ3dD81Njo5PDk9QUI9QUZIQUVFUEtISUpKkoKQkomQkFCHlJSNkZBZeKVvgg=="));

    // LIVE
    // await FetchPages.fetchPagesFromAPI(
    //     decodeFunction("aXZ3dD81NnWCbH9tfX49coVMR0RFRkaIeoGAj0xrmGJ1UQ=="),
    //     decodeFunction(
    //         "aXZ3dD81NnWCbH9tfX49coVMR0RFRkaOfoyOhYyMTIOQkImNjFV0oWt+"));

    // LIVE HTTPS
    // await FetchPages.fetchPagesFromAPI(
    //  decodeFunction(
    //     "aXZ3dHhANjd2g22AO3CDPnOGTUhFRkdHiXuCgZBNbJljdlI="),
    //  decodeFunction(
    //    "aXZ3dHhANjd2g22AO3CDPnOGTUhFRkdHj3+Nj4aNjU2EkZGKjo1WdaJsf1s="));

    registry.setValue("transactionHistoryTitle", "Transaction history");
    // try {
    //   picContact();
    // } catch (e) {
    //   logger.i(e);
    // }



    // String placeMappingData =
    //     await rootBundle.loadString("lib/assets/placeMapping.json");
    final String? response =
        await FetchPages.getPageByName("placeMapping.json");
    Map<String, dynamic> placeMappingData = json.decode(response!);
    jsonData = placeMappingData;
    logger.i("place json data $jsonData");
    logger.i(getDzongkhags(jsonData));

    Future<void> authenticate() async {
      logger.i(
          "=======================================================================================================");
      logger.i(decodeFunction("MjI="));
      String imeiNo = await getDeviceInfo() ?? " ";
      // var value = encodeFunction(imeiNo + '0000' + getFormattedTimestamp());
      logger.i("Device ID$imeiNo encrypted: ${convertToHash(imeiNo)}");
      //logger.i(value);
      try {
        logger.i("device ID first four: ${imeiNo.substring(5, 9)}");
        deviceIdFirstThree = imeiNo.substring(5, 8);
      } catch (e) {
        deviceIdFirstThree = generateRandomString(3);
        print('An error occurred: $e');
      }
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      logger.d(version);
      var parentJSON = {};
      var childJSON = {};
      childJSON["APPVERSION"] = version;
      // childJSON["APPVERSION"] = "1.0.39";
      childJSON["REQTIME"] = getFormattedTimestamp(); //DDMMYYYYHHMISS
      childJSON["REQTYPE"] = encodeFunction("10");
      childJSON["CUSTOMERTYPE"] = 5;
      childJSON["OPERATION"] = "AUTHORIZATION";
      childJSON["REFID"] = genrefId();
      logger.i(genrefId());
      // childJSON["REFID"] = genrefId();
      Map<String, String> headers = await getHeaders();
      headers['H5'] = encodeFunction("10");
      logger.i(headers);
      String apiUrl = "${decodeFunction(getFCGI_IP())}/authCustomer";
      try {
        parentJSON["BT"] = encodeFunction(jsonEncode(childJSON));
        logger.i(parentJSON);
        http.Response response = await http.post(Uri.parse(apiUrl),
            headers: headers, body: jsonEncode(parentJSON));
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = jsonDecode(response.body);
          String decodedResponse =
              decodeFunction(responseData["BT"].toString());
          logger.i(decodedResponse);
          authResponse = jsonDecode(decodedResponse);
        } else {
          logger.i(
              'Request failed with status: ${response.statusCode}${response.body}');
          Navigator.pop(navigatorKey.currentContext!);
          showPopup(navigatorKey.currentContext!, SERVER_ERROR);
        }
      } catch (error) {
        logger.i('Error: $error');
      }
    }

    logger.i(
        "Test decode: ${decodeFunction("aXZ3dD81Njo5PDk9QUI9QUZIQUVFUE9ISIB+g4ZLgYmP")}");
    logger.i(
        "encrypted: ${encodeFunction("http://mybtapp_testapp.bt:4000/pages/mybtapp_test/")}");
    FocusNode otpFocusNode = FocusNode();
    registry.setValue("otpFocusNode", otpFocusNode);
    bool otpFocusChanged = false;
    TextEditingController otpController = TextEditingController();
    otpController.addListener(() {
      if (otpController.text.length == 6) {
        if (!otpFocusChanged) {
          otpFocusNode.unfocus();
        }
        otpFocusChanged = true;
      } else if (otpController.text.length < 6) {
        otpFocusChanged = false;
      } else {
        otpController.text = otpController.text.substring(0, 6);
        otpFocusNode.unfocus();
      }
    });
    registry.setValue("otpController", otpController);
    await authenticate();
    if (authResponse['RESPONSE']['RESPCODE'] == "0000") {
      navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      // navigatorKey.currentState!.pushReplacement(
      //   MaterialPageRoute(
      //       builder: (context) => const landingPage(jsonString: "")),
      // );
    } else if (authResponse['RESPONSE']['RESPCODE'] == "1002") {
      logger.d("Force Update");
      forceUpdate(
          navigatorKey.currentContext!, authResponse['RESPONSE']['RESPDESC']);
    } else if (authResponse['RESPONSE']['RESPCODE'] == "1003") {
      logger.d("Optional Update");
      logger.d(
          "Optional Update splash:: ${authResponse['RESPONSE']['RESPDESC']}");

      optionalUpdate(
          navigatorKey.currentContext!, authResponse['RESPONSE']['RESPDESC']);
    } else if (authResponse['RESPONSE']['RESPCODE'] == "1004") {
      logger.d("Server Down");
      serverDown(
          navigatorKey.currentContext!, authResponse['RESPONSE']['RESPDESC']);
    } else {
      showPopup(navigatorKey.currentContext!, SERVER_DOWN);
    }
  }

  Widget buildSplash() {
    if (kIsWeb) {
      return Scaffold(
        body: Center(
            child: Stack(
          children: [
            //for Web
            Image.asset(
              "lib/assets/gettingStartedBgWeb.png",
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.maybeOf(context)?.size.width ?? 360.0,
            ),
            Center(
              child: Image.asset(
                "lib/assets/BtlogoGSWeb.png",
                height: MediaQuery.of(context).size.height / 3.5,
                width: MediaQuery.maybeOf(context)?.size.width ?? 360.0 / 3.5,
              ),
            ),
          ],
        )),
      );
    } else {
      return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final screenWidth = constraints.maxWidth;

            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "lib/phase/images/splashScreen.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.33,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      "lib/phase/images/logoLight.png",
                      width: screenWidth * 0.92,
                      height: screenHeight * 0.25,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    {
      return buildSplash();
    }
  }
}
