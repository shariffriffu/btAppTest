import 'package:flutter/material.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/global.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/showLoading.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/variableDeclaration.dart';


class OtpLoginPageProvider extends ChangeNotifier {
  String currentOtp = '';

  /// ✅ Single controller used with `pinput`
  final TextEditingController otpController = TextEditingController();

  OtpLoginPageProvider() {
    otpController.addListener(_updateOtp);
  }

  void _updateOtp() {
    currentOtp = otpController.text;

    notifyListeners(); // if UI needs to respond
  }


  Future<void> resendOtp({
    required String mobile,
    required BuildContext context,
    required dynamic registry,
  }) async {
    try {
      otpController.clear(); // ✅ Clear single controller
      forgotPinMobile = mobile;
      logger.e("forgotPinMobile TBR $forgotPinMobile");

    
    } catch (e) {
      logger.i("resendOtp Exception: $e");
    }
  }

  Future<void> submitOtp({
    required BuildContext context,
    required dynamic registry,
  }) async {
    
      logger.w("inside submitotp");
      final String mobile = registry.getValue('mobileNumber');

      if (mobile.isEmpty) {
        showPopup(context, "Mobile number not found.");
        return;
      }

      if (currentOtp.length != 6 || currentOtp.contains(RegExp(r'\D'))) {
        showPopup(context, "Please enter a valid 6-digit OTP.");
        return;
      }

      showLoading(context);
      logger.e("inside submitotp 1 $currentOtp");

      
    }
  }

