import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:mybtapp_testapp_testapp_test/main.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:mybtapp_testapp_testapp_test/global/fetchPages.dart';
import 'package:mybtapp_testapp_testapp_test/phase/NewScreens/login.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/showLoading.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/variableDeclaration.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({Key? key, required this.jsonString}) : super(key: key);
  final String jsonString;

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  Map<dynamic, dynamic> mapData = {};
  final registry = JsonWidgetRegistry.instance;

  @override
  void initState() {
    super.initState();
    _readJson();
  }

  Future<void> _readJson() async {
    try {
      final String response = await rootBundle.loadString('lib/assets/gettingStarted.json');
      setState(() {
        mapData = json.decode(response);
      });
    } catch (e) {
      logger.e("Failed to load JSON: $e");
    }
  }

  Future<void> fetchAndLogin() async {
    showLoading(context);
    try {
      await FetchPages.fetchPagesFromAPI("https://tayana.in:3004", "1074");
      navigatorKey.currentState?.pop(); // Remove loading
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      navigatorKey.currentState?.pop(); 
      logger.e("Error fetching LAB API: $e");
      showPopup(context, SERVER_ERROR);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: fetchAndLogin,
            child: const Text("Getting Started"),
          ),
        ),
      );
    } else if (Platform.isIOS || Platform.isAndroid) {
      if (mapData.isEmpty) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
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
                  Positioned(
                    bottom: screenHeight * 0.42,
                    child: ElevatedButton(
                      onPressed: fetchAndLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5FBB49),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 10),
                      ),
                      child: const Text(
                        "Getting Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    }

    return const Scaffold(
      body: Center(child: Text("Unsupported Platform")),
    );
  }
}
