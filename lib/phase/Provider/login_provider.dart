import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mybtapp_testapp_testapp_test/main.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/global.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/showLoading.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/variableDeclaration.dart';
// ignore: depend_on_referenced_packages


class LoginProvider extends ChangeNotifier {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode mobileFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  String forgotPinMobile = "";

  String? mobileError;
  String? passwordError;
  bool rememberMe = false;
  bool obscurePassword = true;

  // State variables
  bool changedPinFocus = false;
  bool authorizedLogin = false;
  bool isBiometric = false;

  // Configurable values
  String? mobileRegex;
  String? mobileErrorMessage;
  int? mobileLength;

  int? passwordMinLength;
  String? passwordRegex;
  Map<String, String>? passwordErrorMessages;

  final LocalAuthentication auth = LocalAuthentication();

  LoginProvider() {
    mobileController.addListener(() => _handleMobileInput());
    passwordController
        .addListener(() => _handlePasswordInput(navigatorKey.currentContext!));
  }

  void loadValidationRules(Map<String, dynamic> validation) {
    final mobileValidation = validation['mobile'] ?? {};
    final passwordValidation = validation['password'] ?? {};

    mobileRegex = mobileValidation['regex'];
    mobileLength = mobileValidation['length'];
    mobileErrorMessage = mobileValidation['errorMessage'];

    passwordMinLength = passwordValidation['minLength'];
    passwordRegex = passwordValidation['regex'];

    final errors = passwordValidation['errorMessages'] ?? {};
    passwordErrorMessages = {
      'empty': errors['empty'] ?? 'Please enter your password.',
      'tooShort': errors['tooShort'] ?? 'Password is too short.',
      'invalidFormat': errors['invalidFormat'] ?? 'Invalid password format.',
    };
  }

  void _handleMobileInput() {
    String input = mobileController.text;

    if (mobileLength != null && input.length == mobileLength) {
      logger.e("inside mobile");

      passwordFocusNode.requestFocus();
    }
    hasNavigatedToOtp = false;

    validateMobile(input);
  }

  void _handlePasswordInput(context) async {
    String input = passwordController.text;

    if (passwordMinLength != null && input.length > passwordMinLength!) {
      passwordController.text = input.substring(0, passwordMinLength);
      passwordController.selection = TextSelection.fromPosition(
          TextPosition(offset: passwordController.text.length));
    }

    // PIN validation and auto-login trigger
    if (input.isNotEmpty) {
      registry.setValue("validLoginDet", true);
    }

    if (input.length == 4) {
      if (!changedPinFocus && !authorizedLogin) {
        passwordFocusNode.unfocus();
        authorizedLogin = true;

        if (!isBiometric) {
          await callLogin(context);
        }
      }
      changedPinFocus = true;
      authorizedLogin = true;
      registry.setValue("appPass", input);

      logger.i("login length matched ${registry.getValue("appPass")}, $input");
    } else if (input.length > 4) {
      changedPinFocus = false;
      passwordController.text = input.substring(0, 4);
      authorizedLogin = false;
      passwordFocusNode.unfocus();
    } else if (input.length < 4) {
      authorizedLogin = false;
    }

    validatePassword(input);
  }

  void validateMobile(String value) {
    if (value.isEmpty) {
      mobileError = mobileErrorMessage ?? "Please enter your mobile number.";
    } else if (!BT_NUMBER_STARTS_WITH
        .any((prefix) => value.startsWith(prefix))) {
      mobileError =
          "Number must start with: ${BT_NUMBER_STARTS_WITH.join(', ')}";
    } else if (mobileRegex != null && !RegExp(mobileRegex!).hasMatch(value)) {
      mobileError = mobileErrorMessage ?? "Please enter a valid number.";
    } else {
      passwordFocusNode.requestFocus();

      mobileError = null;
    }
    notifyListeners();
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError = passwordErrorMessages?['empty'];
    } else if (passwordMinLength != null && value.length < passwordMinLength!) {
      passwordError = passwordErrorMessages?['tooShort'];
    } else if (passwordRegex != null &&
        !RegExp(passwordRegex!).hasMatch(value)) {
      passwordError = passwordErrorMessages?['invalidFormat'];
    } else {
      passwordError = null;
    }
    notifyListeners();
  }

  bool validateForm() {
    validateMobile(mobileController.text);
    validatePassword(passwordController.text);
    return mobileError == null && passwordError == null;
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  void reset(BuildContext context) {
    passwordController.clear();
    mobileError = null;
    passwordError = null;
    rememberMe = false;
    obscurePassword = true;
    changedPinFocus = false;
    authorizedLogin = false;
    isBiometric = false;
    notifyListeners();
  }

  // Future<void> loginWithBiometric(
  //   BuildContext context,
  //   Future<void> Function(BuildContext?, List<String>, dynamic, String) loginFn,
  //   dynamic registry,
  //   dynamic preferences,
  //   FocusNode loginPinFocusNode,
  // ) async {
  //   try {
  //     final bool authenticated = await auth.authenticate(
  //       localizedReason: "Scan your finger to authenticate",
  //       options: const AuthenticationOptions(
  //         stickyAuth: true,
  //         biometricOnly: false,
  //       ),
  //     );

  //     if (authenticated) {
  //       isBiometric = true;
  //       registry.setValue(
  //           "mobileNumber", preferences.getString("mobileNumber"));
  //       registry.setValue("appPass", preferences.getString("pin"));
  //       loginPinFocusNode.unfocus();
  //       await loginFn(
  //           context.mounted ? context : null, [], registry, "biometric");
  //     }
  //   } catch (e) {
  //     // sendCrashReport('biometric Error: $e');
  //   }
  // }

  Future<void> callLogin(BuildContext context) async {
    final String mobile = mobileController.text.trim();
    final String password = passwordController.text.trim();

    // if (mobile.isEmpty || password.isEmpty) {
    //   Fluttertoast.showToast(
    //     msg: "Please enter both mobile number and password.",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //   );
    //   return;
    // }

    registry.setValue("appPass", password);
    registry.setValue("mobileNumber", mobile);

    logger.e("inside call login");

    passwordFocusNode.unfocus();

    // await login(
    //   context,
    //   ['form_context'],
    //   registry,
    //   "form",
    // );
  }

  // Future<void> loginWithNDI({
  //   required BuildContext context,
  //   required TextEditingController loginMobileController,
  //   required dynamic preferences,
  //   required dynamic registry,
  //   required Future<void> Function(BuildContext?, List<String>, dynamic, String)
  //       loginFn,
  //   required void Function(String url) openCustomURL,
  // }) async {
  //   final mobile = loginMobileController.text;
  //   String message = "";
  //   String url = "";

  //   showLoading(navigatorKey.currentContext!);

  //   final ndiLoginResponse = await BT_VcQrSubmission("2030", mobile, "2");

  //   Navigator.pop(navigatorKey.currentContext!);

  //   final resp = ndiLoginResponse['RESPONSE'];
  //   if (resp['RESPCODE'] != "0000") {
  //     logger.i("NDI login failed");
  //     final infoMessage = registry.getValue("NDI_ERROR_MESSAGE");
  //     logger.i("infoMessage $infoMessage");
  //     showInfoPopup(navigatorKey.currentContext!, infoMessage);
  //     return;
  //   }

  //   if (resp['RESPCODE'] == "1012") {
  //     registry.setValue("validLoginDet", true);
  //     Navigator.pushAndRemoveUntil(
  //       navigatorKey.currentContext!,
  //       MaterialPageRoute(builder: (_) => const LoginPage()),
  //       (route) => false,
  //     );
  //     showPopup(navigatorKey.currentContext!, resp['RESPDESC'].toString());
  //     return;
  //   }

  //   // If success response
  //   url = ndiLoginResponse['DEEPLINK'] ?? "";
  //   final thrdId = ndiLoginResponse['THREADID'] ?? "";

  //   logger.i("QR image $url");
  //   logger.i("Thread ID $thrdId");

  //   openCustomURL(url);
  //   showLoading(navigatorKey.currentContext!);

  //   final detailResponse = await BT_VcDetailsSubmissionNDI(
  //     mobile,
  //     "2040",
  //     url,
  //     thrdId,
  //   );

  //   navigatorKey.currentState!.pop();

  //   if (detailResponse['RESPONSE']['RESPCODE'] == "0000") {
  //     final pin = preferences.getString("pin");
  //     if (pin != null) {
  //       registry.setValue("appPass", pin);
  //       await loginFn(navigatorKey.currentContext!, [], registry, "biometric");
  //     } else {
  //       showPopup(navigatorKey.currentContext!, "Please login with pin once");
  //     }
  //   } else {
  //     message = detailResponse['RESPONSE']['RESPDESC'].toString();
  //     showPopup(navigatorKey.currentContext!, message);
  //   }
  // }

  // Future<void> forgotPassword(BuildContext context, dynamic registry) async {
  //   try {
  //     final String mobile = mobileController.text;

  //     if (mobile.isEmpty) {
  //       showPopup(
  //         navigatorKey.currentContext!,
  //         "Please enter your mobile number.",
  //       );
  //       return;
  //     }

  //     forgotPinMobile = mobile;
  //     logger.e("forgotPinMobile 1TBR $forgotPinMobile");

  //     if (mobile.length == 8) {
  //       showLoading(navigatorKey.currentContext!);

  //       final response = await BT_resetPIN("600", mobile, "");

  //       navigatorKey.currentState!.pop(); // hide loader

  //       if (response['RESPONSE']['RESPCODE'].toString() == "0000") {
  //         await navigatorKey.currentState!.push(
  //           MaterialPageRoute(
  //             builder: (BuildContext context) =>
  //                 OtpPage(mobileNumber: mobileController.text),
  //           ),
  //         );
  //       } else {
  //         showPopup(
  //           navigatorKey.currentContext!,
  //           response['RESPONSE']['RESPDESC'],
  //         );
  //       }
  //     } else {
  //       showPopup(
  //         navigatorKey.currentContext!,
  //         "Enter a valid 8-digit mobile number.",
  //       );
  //     }
  //   } catch (e) {
  //     logger.i("Forgot Password Error: $e");
  //     showPopup(
  //       navigatorKey.currentContext!,
  //       "Something went wrong. Please try again.",
  //     );
  //   }
  // }

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    mobileFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
}
