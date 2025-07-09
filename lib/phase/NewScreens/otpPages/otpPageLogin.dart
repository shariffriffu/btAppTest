import '../../global/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mybtapp_testapp_testapp_test/phase/NewScreens/login.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/dynamicBuilder.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/variableDeclaration.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Provider/otpPagesProvider/otpLoginPage_provider.dart';





class OtpLoginPage extends StatefulWidget {
  final String mobileNumber;
  const OtpLoginPage({super.key, required this.mobileNumber});

  @override
  State<OtpLoginPage> createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends State<OtpLoginPage> {
  @override
  void initState() {
    super.initState();
    logger.d("OtpLoginPage");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final otpProvider =
          Provider.of<OtpLoginPageProvider>(context, listen: false);
      otpProvider.otpController.clear();
    });
    loadPageProperties().then((jsonData) {
      setState(() {
        layoutJson = jsonData['OtpPage'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final otpPageProvider =
        Provider.of<OtpLoginPageProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
        );

        return false; // Prevent default back navigation
      },
      child: Scaffold(
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
                                'resend': () {
                                  otpPageProvider.resendOtp(
                                    mobile: widget.mobileNumber,
                                    context: context,
                                    registry: registry,
                                  );
                                },
                                'proceed': () {
                                  otpPageProvider.submitOtp(
                                    context: context,
                                    registry: registry,
                                  );
                                },
                              },
                              layoutJson!['children'],
                              context,
                              controllers: {
                                'forgotPinOtp': otpPageProvider.otpController,
                              },
                              errorTexts: {},
                              visibilityStates: {},
                              toggleVisibilityFns: {},
                              focusNodes: {},
                            ),
                          ),
                        ),
                        buildContactInfo(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
