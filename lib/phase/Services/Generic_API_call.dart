import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mybtapp_testapp_testapp_test/main.dart';
import 'package:mybtapp_testapp_testapp_test/API_calls/getSubsDet.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/global.dart';
import 'package:mybtapp_testapp_testapp_test/phase/NewScreens/login.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/showLoading.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/variableDeclaration.dart';


Future<void> login(context, args, registry, String type) async {
  await clearMaps();
  walletDetails = [];
  availableMap = {
    userType == "0" ? 'RECHARGE BALANCE' : "ACCOUNT BALANCE": true,
    'PROMO': false,
    'LEASE LINE DUES': false,
    'BROADBAND DUES': false,
  };
  showLoading(navigatorKey.currentContext!);
  
    bool valid = false;
    if (type == "biometric") {
      valid = true;
    } else if (type == "form" && registry.getValue(args[0]) != null) {
      // navigatorKey.currentContext! = registry.getValue(args[0]);
      valid = registry.getValue("validLoginDet");
      logger.i("generic API calls: $valid");
      // registry.setValue('form_validation', valid);
    }
    logger.i(navigatorKey.currentContext!);
    final appPass = registry.getValue('appPass');
    final mobileNumber = registry.getValue('mobileNumber');
    logger.i("$mobileNumber $appPass");
    loginResponse = {};
    logger.i("got Login Response");
    loggedInSessionId = "";
    loggedInSessionId = loginResponse['SESSIONID'].toString();
    if (loginResponse != {} &&
        loginResponse['RESPONSE']['RESPCODE'] == "6504") {
      registry.setValue(
          "registerNumber", registry.getValue("mobileNumber") ?? "");
      logger.i("inside 6504 cond: ${registry.getValue("registerNumber")}");

      navigatorKey.currentState!.pop();
      // navigatorKey.currentState!.push(MaterialPageRoute(
      //     builder: (context) => const Register(jsonString: "")));
      showPopup(
          navigatorKey.currentContext!, loginResponse['RESPONSE']['RESPDESC']);
    } else if (loginResponse != {} &&
        loginResponse['RESPONSE']['RESPCODE'].toString() == "1001") {
      try {
        String mobile = registry.getValue("mobileNumber");
        if (mobile.isNotEmpty && mobile.length == 8) {
          navigatorKey.currentState!.pop();

          // if (response['RESPONSE']['RESPCODE'].toString() == "0000") {
          //   logger.i("inside first condition $mobile");
          //   // await navigatorKey.currentState!.push(
          //   //   MaterialPageRoute(
          //   //       builder: (context) => OtpLogin(
          //   //             jsonString: "",
          //   //             mobile: mobile,
          //   //           )),
          //   // );

            
          //   logger.i("inside second condition22222");

          //   // Navigator.push(
          //   //   context,
          //   //   MaterialPageRoute(
          //   //     builder: (context) => OtpManualPage(
          //   //       msisdn: mobile,
          //   //       pageName: "OTPLOGIN",
          //   //     ),
          //   //   ),
          //   // );
          // } else if (response['RESPONSE']['RESPCODE'] == "1012") {
          //   registry.setValue("validLoginDet", true);
          //   // Navigator.pushAndRemoveUntil(
          //   //     navigatorKey.currentContext!,
          //   //     MaterialPageRoute(
          //   //         builder: (_) => const landingPage(
          //   //               jsonString: '',
          //   //             )),
          //   //     (route) => false);
          //   Navigator.pushAndRemoveUntil(
          //       navigatorKey.currentContext!,
          //       MaterialPageRoute(builder: (_) => const LoginPage()),
          //       (route) => false);
          //   showPopup(navigatorKey.currentContext!,
          //       response['RESPONSE']['RESPDESC'].toString());
          // }
        }
      } catch (e) {
        // Navigator.pushAndRemoveUntil(
        //     navigatorKey.currentContext!,
        //     MaterialPageRoute(
        //         builder: (_) => const landingPage(
        //               jsonString: '',
        //             )),
        //     (route) => false);
        Navigator.pushAndRemoveUntil(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false);
        logger.e("Timeout Popup");
        showPopup(navigatorKey.currentContext!, TIMEOUT_MESSAGE);
        logger.e(e);
      }
    } else if (loginResponse != {} &&
        loginResponse['RESPONSE']['RESPCODE'].toString() == "0000") {
      logger.i("inside second condition");
      loggedInSessionId = loginResponse['SESSIONID'].toString();
      preferences!.setString("mobileNumber", mobileNumber);
      preferences!.setString("pin", appPass.toString());
      logger.d("Current sessionID :: $loggedInSessionId :: $mobileNumber");

      // await setServiceDetails(loginResponse);

      loggedInMobile = mobileNumber.toString();
      customerDet = {};
      customerDet = await BT_getCustomerDet(
          loginResponse['SERVICEDET'][0]['SERVTYPE'], mobileNumber);
      if (customerDet != {} &&
          customerDet['RESPONSE']['RESPCODE'].toString() == "1012") {
        // showPopup(navigatorKey.currentContext!,
        //     "Something went wrong please try again!");
        logger.e(customerDet);
      } else if (customerDet != {} &&
          customerDet['RESPONSE']['RESPCODE'].toString() == "0000") {
        logger.i("inside third condition");
        // String debugDet = customerDet["ACCOUNTDET"]["DEBUGENABLEDUSER"];
        String debugDet = "false";
        logger.i("TBR debugDet :: $debugDet");
        debugDet = debugDet == "yes" ? "true" : "false";
        logger.i("TBR debugDet :: $debugDet");

        if (debugDet == "true") {
          debugUserEnabled = true;
          logger.i("debug user enabled");
        }

        logger.i("inside fourth condition");
       
          String bNuglBalMasked =
              (bNuglBal == '') ? 'x' : 'x' * bNuglBal.length;

          registry.setValue(
              "BNgulBalHide", "Your B-Ngul Balance: Nu. $bNuglBalMasked");
          registry.setValue("BNgulBal",
              "Your B-Ngul Balance: Nu. ${bNuglBal == '' ? '0' : bNuglBal}");

          logger.i("walletDetails $walletDetails");
          for (var bank in walletBankDetails) {
            if (bank['BANKNAME'] == "RMA") {
              rmaBankDetails = bank;
              walletBankDetails.remove(bank);
              break;
            }
          }
          logger.i(
              "walletBankDetails: $walletBankDetails, rmaBankDetails: $rmaBankDetails");
          // bankAccountMap = {};
          // walletBankDetails.forEach((bank) {
          //   // bankAccountMap[bank['BANKNAME']] = [];
          //   List.from(bank['BANKACCOUNTDETAILS']).forEach((bankAccount) {
          //     if (bank['BANKNAME'] == "RMA") {
          //       bankAccountMap[bank['BANKNAME']] = "${bank['BANKNAME']}-PG";
          //     } else {
          //       bankAccountMap[bank['BANKACCOUNTNO']] = "${bank['BANKNAME']}-PG";
          //     }
          //   });
          // });

         
        
      } else {
        // Navigator.pushAndRemoveUntil(
        //     navigatorKey.currentContext!,
        //     MaterialPageRoute(
        //         builder: (_) => const landingPage(
        //               jsonString: '',
        //             )),
        //     (route) => false);
        Navigator.pushAndRemoveUntil(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false);
        logger.e("Timeout Popup");
        showPopup(navigatorKey.currentContext!, TIMEOUT_MESSAGE);
      }
    } else if (loginResponse['RESPONSE']['RESPCODE'].toString() == "6501") {
      logger.d("loginResponse RESPCODE is not 0000");
      logger.w("${loginResponse['RESPONSE']['RESPCODE']}");
      navigatorKey.currentState!.pop();
      showPopupUnblock(
          navigatorKey.currentContext!, loginResponse['RESPONSE']['RESPDESC']);
    } else {
      logger.d("loginResponse RESPCODE is not 0000");
      logger.w("${loginResponse['RESPONSE']['RESPCODE']}");
      navigatorKey.currentState!.pop();
      showPopup(
          navigatorKey.currentContext!, loginResponse['RESPONSE']['RESPDESC']);
    }
  }

