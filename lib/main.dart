import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mybtapp_testapp_testapp_test/gettingStarted.dart';
import 'package:mybtapp_testapp_testapp_test/phase/NewScreens/login.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Provider/themeProvider.dart';
import 'package:mybtapp_testapp_testapp_test/phase/NewScreens/splashScreen.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Provider/globalProvider.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Provider/login_provider.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Provider/otpPagesProvider/otpLoginPage_provider.dart';


final navigatorKey = GlobalKey<NavigatorState>();
String SUCCESSHEADING = "Success!";
String SERVER_ERROR = "";
String SERVER_DOWN =
    "Service is currently not available!\nPlease try again later!";
bool firstLogin = true;

String TIMEOUT_MESSAGE = "Could not process your request";
String TIMEOUT_SECONDS = "30";
List<dynamic> BT_NUMBER_STARTS_WITH = [];
String PROFILEPAGE = "";

String MFS_REGISTER_HEADING = "Register!";

String FUNDTRANSFER = "";

void main() {
  HttpOverrides.global = CustomHttpOverrides();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => OtpLoginPageProvider()),
        ChangeNotifierProvider(create: (context) => GlobalProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MediaQuery(
        data: MediaQueryData.fromView(WidgetsBinding.instance.window).copyWith(
          textScaler: const TextScaler.linear(1.0),
        ),
        child: MaterialApp(
            initialRoute: firstLogin ? '/gettingStarted' : '/splash',
            routes: {
              '/splash': (context) => SplashScreenP2(),
              // '/home': (context) => const landingPage(jsonString: ""),
              '/home': (context) => const LoginPage(),
              // '/homePage': (context) => const homePageNew(jsonString: ''),
              // '/homePage': (context) => const DashBoard(),
              '/gettingStarted': (context) =>
                  const GettingStarted(jsonString: ""),
            },
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            title: 'My BT',
            theme: ThemeData(
              fontFamily: 'Gilroy',
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color.fromARGB(255, 209, 114, 37)),
              useMaterial3: true,
            )));
  }
}
class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Allow self-signed certificate
        return true;
      };
  }
}
