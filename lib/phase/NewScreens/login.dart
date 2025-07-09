import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mybtapp_testapp_testapp_test/main.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/global.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/global.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/showLoading.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/dynamicBuilder.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Provider/login_provider.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/Generic_API_call.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/variableDeclaration.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  // LoginProvider() {
  //   // mobileController.addListener(() => _handleMobileInput());
  //   // passwordController
  //   //     .addListener(() => _handlePasswordInput(navigatorKey.currentContext!));
  // }

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
  }

  bool validateForm() {
    validateMobile(mobileController.text);
    validatePassword(passwordController.text);
    return mobileError == null && passwordError == null;
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
  }

  void toggleRememberMe(bool value) {
    rememberMe = value;
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
  }

  Future<void> loginWithBiometric(
    BuildContext context,
    Future<void> Function(BuildContext?, List<String>, dynamic, String) loginFn,
    dynamic registry,
    dynamic preferences,
    FocusNode loginPinFocusNode,
  ) async {
    try {
      final bool authenticated = await auth.authenticate(
        localizedReason: "Scan your finger to authenticate",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (authenticated) {
        isBiometric = true;
        registry.setValue(
            "mobileNumber", preferences.getString("mobileNumber"));
        registry.setValue("appPass", preferences.getString("pin"));
        loginPinFocusNode.unfocus();
        await loginFn(
            context.mounted ? context : null, [], registry, "biometric");
      }
    } catch (e) {
      showPopup(navigatorKey.currentContext!,
          "Please login with your pin once to enable biometrics");
    }
  }

  Future<void> callLogin(BuildContext context) async {
    final String mobile = mobileController.text.trim();
    final String password = passwordController.text.trim();

   

    registry.setValue("appPass", password);
    registry.setValue("mobileNumber", mobile);

    logger.e("inside call login");

    passwordFocusNode.unfocus();

    await login(
      context,
      ['form_context'],
      registry,
      "form",
    );
  }

  Future<void> forgotPassword(BuildContext context, dynamic registry) async {
      final String mobile = mobileController.text;

      if (mobile.isEmpty) {
        showPopup(
          navigatorKey.currentContext!,
          "Please enter your mobile number.",
        );
        return;
      }

      forgotPinMobile = mobile;
      logger.e("forgotPinMobile 1TBR $forgotPinMobile");

      if (mobile.length == 8) {
        showLoading(navigatorKey.currentContext!);

  }
  }
  @override
  void initState() {
    super.initState();
    // preferences!.setBool("firstLogin", false);
    final mobileNumber = registry.getValue("mobileNumber");

    if (mobileNumber != null &&
        mobileNumber.isNotEmpty &&
        mobileNumber != "null") {
      mobileController.text = mobileNumber;
    } else {
      mobileController.text = "";
    }
    loadPageProperties().then((jsonData) {
      setState(() {
        layoutJson = jsonData['login'];
      });
      mobileController.addListener(() {
        String input = mobileController.text;
        logger.i("loginMobileController $input");

        setState(() {
          if (input.isEmpty) {
            mobileError =
                mobileErrorMessage ?? "Please enter your mobile number.";
          } else if (!BT_NUMBER_STARTS_WITH
              .any((prefix) => input.startsWith(prefix))) {
            mobileError =
                "Number must start with: ${BT_NUMBER_STARTS_WITH.join(', ')}";
          } else if (mobileRegex != null &&
              !RegExp(mobileRegex!).hasMatch(input)) {
            mobileError = mobileErrorMessage ?? "Please enter a valid number.";
          } else {
            logger.e("inside mobile");

            mobileError = null;
            passwordFocusNode.requestFocus();
          }
        });
      });
      passwordController.addListener(() async {
        String input = passwordController.text;

        setState(() {
          // Limit input length
          if (passwordMinLength != null && input.length > passwordMinLength!) {
            passwordController.text = input.substring(0, passwordMinLength);
            passwordController.selection = TextSelection.fromPosition(
                TextPosition(offset: passwordController.text.length));
          }

          // Validation check
          if (input.isNotEmpty) {
            registry.setValue("validLoginDet", true);
          }

          if (input.length == 4) {
            if (!changedPinFocus && !authorizedLogin) {
              passwordFocusNode.unfocus();
              authorizedLogin = true;

              if (!isBiometric) {
                callLogin(context); // no need to await inside setState
              }
            }
            changedPinFocus = true;
            authorizedLogin = true;
            registry.setValue("appPass", input);
            logger.i(
                "login length matched ${registry.getValue("appPass")}, $input");
          } else if (input.length > 4) {
            changedPinFocus = false;
            passwordController.text = input.substring(0, 4);
            authorizedLogin = false;
            passwordFocusNode.unfocus();
          } else if (input.length < 4) {
            authorizedLogin = false;
          }

          // Error assignment
          if (passwordController.text.isEmpty) {
            passwordError = passwordErrorMessages?['empty'];
          } else if (passwordMinLength != null &&
              passwordController.text.length < passwordMinLength!) {
            passwordError = passwordErrorMessages?['tooShort'];
          } else if (passwordRegex != null &&
              !RegExp(passwordRegex!).hasMatch(passwordController.text)) {
            passwordError = passwordErrorMessages?['invalidFormat'];
          } else {
            passwordError = null;
          }
        });
      });
      loadValidationRules(jsonData['login']['validation']);
      reset(context);
      final screenHeightt = MediaQuery.of(context).size.height;
      final profilescreenHeight = screenHeightt + 50;
      registry.setValue("screenHeight", profilescreenHeight);
    });
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

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: layoutJson == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/phase/images/bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                              child: buildFromLayout(
                        actionHandlers: {
                          'register': () async {
                            // await navigatorKey.currentState!.pushReplacement(
                            //   MaterialPageRoute(
                            //       builder: (BuildContext context) =>
                            //           const Register(jsonString: "")),
                            // );
                           
                          },
                          'forgotPassword': () {
                            forgotPassword(context, registry);
                          },
                          'login': () {
                            callLogin(context);
                          },
                          // 'fingerPrint': () async {
                          //   await loginWithBiometric(
                          //     context,
                          //     login,
                          //     registry,
                          //     preferences,
                          //     passwordFocusNode,
                          //   );
                          // },
                          'LoginWithNdi': () {
                           
                          }
                        },
                        layoutJson!['children'],
                        context,
                        controllers: {
                          'mobile': mobileController,
                          'password': passwordController,
                        },
                        errorTexts: {
                          'mobile': mobileError,
                          'password': passwordError,
                        },
                        visibilityStates: {
                          'password': loginProvider.obscurePassword,
                        },
                        toggleVisibilityFns: {
                          'password': () =>
                              loginProvider.togglePasswordVisibility(),
                        },
                        focusNodes: {
                          'mobile': mobileFocusNode,
                          'password': passwordFocusNode,
                        },
                      ))),
                      buildContactInfo(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
  
  
