import 'dart:math';
import 'dart:convert';
import 'dart:io' as io;
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/variableDeclaration.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/encryption_decryption_function.dart';



// Import for mobile


// Web storage wrapper
class WebStorage {
  static String? getValue(String key) {
    if (kIsWeb) {
      try {
        // Access storage through JS
        return null; // Implement JS interop if needed
      } catch (e) {
        // sendCrashReport('Error accessing storage: $e');
        logger.e('Error accessing storage: $e');
        return null;
      }
    }
    return null;
  }

  static void setValue(String key, String value) {
    if (kIsWeb) {
      try {
        // Set storage through JS
      } catch (e) {
        // sendCrashReport('Error setting storage: $e');
        logger.e('Error setting storage: $e');
      }
    }
  }
}

Future<String?> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (kIsWeb) {
    try {
      WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
      String deviceId = webInfo.hardwareConcurrency.toString();
      //String deviceId = generateWebDeviceId(webInfo);
      //String deviceId = "551fddc85cefaa82";
      logger.i('Running on Web: ${webInfo.browserName}');
      logger.i('Web Device iD: ${deviceId}');
      return deviceId;
    } catch (e) {
      logger.e('Error getting web device info: $e');
      return generateWebDeviceId(null);
    }
  } else {
    try {
      if (io.Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        logger.i('Running on ${androidInfo.model}');
        return androidInfo.id;
      } else if (io.Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        logger.i('Running on ${iosInfo.utsname.machine}');
        return iosInfo.identifierForVendor;
      }
    } catch (e) {
      logger.e('Error getting device info: $e');
    }
  }
  return null;
}

String generateWebDeviceId(WebBrowserInfo? webInfo) {
  final Random _random = Random();

  int _getRandomNumber(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  String _getRandomLetters(int length) {
    return List.generate(
            length, (index) => String.fromCharCode(_getRandomNumber(65, 90)))
        .join();
  }

  final prefix = 'ID';
  final letters = _getRandomLetters(2);
  final firstNumber = _getRandomNumber(1, 9);
  final secondPart = _getRandomLetters(3);
  final thirdPart = _getRandomNumber(10, 99);
  final majorVersion = _getRandomNumber(100, 999);
  final minorVersion = _getRandomNumber(10, 99);
  final patchVersion = _getRandomNumber(1, 9);
  final buildNumber = _getRandomNumber(1, 9);

  return '$prefix$letters$firstNumber$secondPart$thirdPart.$majorVersion-$minorVersion-$patchVersion-$buildNumber';
}

String convertToHash(String input) {
  var bytes = utf8.encode(input);
  var digest = sha256.convert(bytes);
  return digest.toString().substring(0, 16);
}

Future<Map<String, String>> getHeaders() async {
  String imeiNo = await getDeviceInfo() ?? " ";

  String getPlatformString() {
    if (kIsWeb) {
      return "Android";
    }
    try {
      if (io.Platform.isAndroid) return "Android";
      if (io.Platform.isIOS) return "iOS";
    } catch (e) {
      logger.e('Error getting platform: $e');
    }
    return "";
  }

  Map<String, String> headers = {
    'H1': encodeFunction(getPlatformString()),
    'H2': encodeFunction("btapp"),
    'H3': encodeFunction("btapp"),
    'H4': encodeFunction(convertToHash(imeiNo)),
  };

  return headers;
}
