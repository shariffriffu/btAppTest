import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:mybtapp_testapp_testapp_test/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:mybtapp_testapp_testapp_test/global/fetchPages.dart';
import 'package:mybtapp_testapp_testapp_test/phase/NewScreens/login.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/variableDeclaration.dart';

bool hasNavigatedToOtp = false;

double screenHeightForJson =
    MediaQuery.of(navigatorKey.currentContext!).size.height;

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

class UserServices {
  String _serviceNumber;
  String _name;
  String _address;
  String _nickName;
  String _serviceType;
  UserServices({
    required String serviceNumber,
    required String name,
    required String address,
    required String nickName,
    required String serviceType,
  })  : _serviceNumber = serviceNumber,
        _name = name,
        _address = address,
        _nickName = nickName,
        _serviceType = serviceType;

  // Getters
  String get serviceNumber => _serviceNumber;
  String get name => _name;
  String get address => _address;
  String get nickName => _nickName;
  String get serviceType => _serviceType;

  String getData() {
    return "$_serviceNumber | $_name | $_address | $_nickName | $_serviceType";
  }
}

Future<void> updateHomeData(JsonWidgetRegistry registry) async {
  registry.setValue("visibleRecharge", false);
  registry.setValue("visiblePromo", true);
  registry.setValue("visibleLease", true);
  registry.setValue("visibleBroadband", true);
}

Map<String, dynamic> authResponse = {};
Map<String, dynamic> loginResponse = {};
Map<String, dynamic> customerDet = {};
Map<String, dynamic> statusVasServices = {};
Map<String, dynamic> btunesPlanDetails = {};
Map<String, dynamic> btunesRegDetails = {};
Map<String, dynamic> btunesPurchaseDetails = {};
Map<String, dynamic> transactionHistoryData = {};
Map<String, dynamic> mcaActivationInfo = {};
List<Map<String, dynamic>> transactions = [];
List<Map<String, dynamic>> recentTransactions = [];
TextEditingController loginPinController = TextEditingController();
TextEditingController loginMobileController = TextEditingController();
TextEditingController msisdnkycresubmissionController = TextEditingController();
TextEditingController NdiController = TextEditingController();
Map<String, dynamic> bbMacbindingInfo = {};
List<Map<String, dynamic>> displayServiceList = [];
String globalThreshold = "";
bool rechargeFromAnalytics = false;
bool debugUserEnabled = false;
String deviceName = "";

// List<Map<String, dynamic>> transactions = [
//   {
//     "title": "Recharge for prepaid",
//     "msisdn": "12343254365",
//     "date": "11 jun,06:20 Am",
//     "price": "Nu 5",
//     "type": "B-Wallet",
//     "status": ""
//   },
// ];
List<String> dataPackAmountList = [];
List<Map<String, dynamic>> btunesTopTen = [];
List<Map<String, dynamic>> btunesLatestTen = [];
List<Map<String, dynamic>> btunesMyTunes = [];
List<Map<String, dynamic>> dataPackDetails = [];
List<UserServices?> prePaidDetList = [];
List<UserServices?> postPaidDetList = [];
List<UserServices?> broadBandDetList = [];
List<Map<String, dynamic>> walletDetails = [];
List<Map<String, dynamic>> walletBankDetails = [];
// Map<String, String> bankAccountMap = {};
List<dynamic> otherTransactionsEloadHistory = [];
Map<String, dynamic> missedCallAlert = {};
Map<String, dynamic> services = {};
Map<String, dynamic> serviceDet = {};
Map<String, dynamic> eLoadInfo = {};
Map<String, dynamic> rmaBankDetails = {};
Map<String, dynamic> rmaBankMap = {};
String bNuglBal = "";
String catalogID = "";
bool addMoneyFromRecharge = false;
String rechargeAddMoneyAmount = "";
String forgotPinMobile = "";
String transactionID = "";
String loggedInSessionId = " ";
String transactionSessionId = " ";
String loggedInMobile = " ";
UserServices? prepaidDET;
UserServices? postPaidDET;
UserServices? broadBandDET;
List<Map<String, dynamic>> allServices = [];
List<String> registeredServicNames = [];
Map<String, List<UserServices?>> registeredServices = {};
String selectedService = "Prepaid";
String selectedServiceType = "";
UserServices? currentService;
Map<String, dynamic> loggedInServiceDetails = {};
SharedPreferences? preferences;
bool loggedIn = false;
bool loginWithNDI = false;
bool newNotification = false;
String notificationCount = "";
Map<String, dynamic> notiFicationJson = {};
Map<String, dynamic> EKYCDEALERDET = {};
bool biometricValue = false;
bool biometricToggled = false;
String deviceIdFirstThree = "";
String testconfig = "";
double profileHeight = 0;
bool isDealer = false;
bool isCustomer = false;
Map<String, bool> profileStatus = {};
Map<String, dynamic> jsonData = {};
Map<String, dynamic> paymentResponse = {};
bool transactionFetched = false;
bool isBiometric = false;
bool isTransaction = false;
Map<String, bool> availableMap = {};
List<Map<String, dynamic>> complaints = [];
String userType = "0";
String validityLabel = "Validity";
List<Map<String, dynamic>> rmaPaymentMethods = [];
bool isPayg = false;
Map<String, dynamic> bbpersonalDetailsMap = {};
bool MACbindingStatus = false;
String totalPoints = "";
String intTotalPoints = "";
List<dynamic> catalogsdelete = [];
List<Map<String, dynamic>> catalogs = [];
Map<String, dynamic> recentRechargesData = {};
Map<String, dynamic> recentRechargesTalktime = {};
bool rechargeRequestData = false;
bool rechargeRequestTalktime = false;
String serviceTypeData = "";
String serviceTypeTalktime = "";
String rechargeDataAmount = "";
String rechargeTalktimeAmount = "";

Future<void> setRegistryValue(JsonWidgetRegistry registry) async {
  String? registryConfig =
      await FetchPages.getPageByName("registryValues.json");
  //await FetchPages.getPageByName("lib/assets/registryValues.json");
  logger.i("Fetched registryConfig :: $registryConfig");
  Map<String, dynamic> registryValues = {};
  if (registryConfig != null) {
    registryValues = jsonDecode(registryConfig);
  }

  registryValues.forEach((key, value) {
    // logger.i("key: $key value: $value");
    registry.setValue(key, value);
  });
}

Future<void> navigateHome() async {
  // Navigator.pushAndRemoveUntil(
  //     navigatorKey.currentContext!,
  //     MaterialPageRoute(
  //         builder: (_) => const homePageNew(
  //               jsonString: '',
  //             )),
  //     (route) => false);
  // Navigator.pushAndRemoveUntil(navigatorKey.currentContext!,
  //     MaterialPageRoute(builder: (_) => const DashBoard()), (route) => false);
}

List<String> getDzongkhags(Map<String, dynamic> jsonData) {
  return (jsonData['DISTDET'][0]["districts"] as List)
      .map((district) => district['name'] as String)
      .toList();
}

List<String> getGewogs(Map<String, dynamic> jsonData, String dzongkhag) {
  final dzongkhagData =
      (jsonData['DISTDET'][0]["districts"] as List).firstWhere(
    (district) => district['name'] == dzongkhag,
    orElse: () => null,
  );
  if (dzongkhagData == null) return ['Select Gewog'];
  return (dzongkhagData['taluks'] as List)
      .map((taluk) => taluk['name'] as String)
      .toList();
}

List<String> getVillages(
    Map<String, dynamic> jsonData, String dzongkhag, String gewog) {
  final dzongkhagData =
      (jsonData['DISTDET'][0]["districts"] as List).firstWhere(
    (district) => district['name'] == dzongkhag,
    orElse: () => null,
  );
  if (dzongkhagData == null) return ['Select Village'];

  final gewogData = (dzongkhagData['taluks'] as List).firstWhere(
    (taluk) => taluk['name'] == gewog,
    orElse: () => null,
  );
  if (gewogData == null) return ['Select Village'];

  return (gewogData['villages'] as List).cast<String>().toList();
}

final List<Map<String, dynamic>> accounts = allServices;

void initiatePage(JsonWidgetRegistry registry) {
  registry.setValue("isPayg", isPayg);
  logger.i("customerDet from initiatePage() TBRRR: $customerDet");
  logger.d("Registered Service details :: $registeredServices");
  logger
      .d("Current service name :: selectedServiceType :: $selectedServiceType");
  logger.d("Current service name :: selectedService :: $selectedService");
  logger.i("customerDet dealer detr: ${customerDet['EKYCDEALERDET']}");
  EKYCDEALERDET = customerDet['EKYCDEALERDET'];
  loggedInServiceDetails = customerDet['ACCOUNTDET'];
  registry.setValue("isPrepaid", false);
  if (loggedInServiceDetails['SERVTYPE'] == "0") {
    registry.setValue("rechargeCardHeading", "RECHARGE BALANCE");
    userType = "0";
    registry.setValue("isPrepaid", true);
    selectedServiceType = 'Prepaid';
  } else if (loggedInServiceDetails['SERVTYPE'] == "1") {
    registry.setValue("rechargeCardHeading", "ACCOUNT BALANCE");
    userType = "1";
    selectedServiceType = 'Postpaid';
  }
  if (loggedInServiceDetails['SERVTYPE'] == "6") {
    selectedServiceType = 'Broadband';
  }
  availableMap = {
    userType == "0" ? 'RECHARGE BALANCE' : "ACCOUNT BALANCE": true,
    'PROMO': false,
    'LEASE LINE DUES': false,
    'BROADBAND DUES': false,
  };
  logger.d(
      "selected service :: $selectedService :: ${registeredServices[selectedService]!}");
  logger.d("all services :: $allServices");
  
  try {
    for (var service in registeredServices[selectedServiceType]!) {
      logger.d(service!.getData());
      logger.d(
          "${service.serviceNumber} :: ${customerDet['ACCOUNTDET']['SERVNUM']}");
      if (service.serviceNumber == customerDet['ACCOUNTDET']['SERVNUM']) {
        logger.d(
            "${service.serviceNumber} :: ${customerDet['ACCOUNTDET']['SERVNUM']}");
        currentService = null;
        currentService = service;
        logger.d("current service is :: ${currentService?._address}");

      }
    }
    // if (customerDet['ACCOUNTDET']['SERVTYPE'] == "0" || customerDet['ACCOUNTDET']['SERVTYPE'] == "1") {
    //   loggedInMobile = currentService!.serviceNumber;
    // }
  } catch (e) {
    logger.i("catch block initiatePage $e");
  }

  logger.i("customerDet in homePage: $customerDet");
  // logger.i("customerDet in homePage :: kyc :: ${customerDet['EKYCDEALERDET']}");

  registry.setValue("dataDetList", []);

  // Extract the first data entry
  try {
    final dataDetList = List.from(customerDet['DATADET']);
    logger.i("dataDet for format change: $dataDetList");

    List<Map<String, dynamic>> result = [];

    dataDetList.forEach((dataDet) {
      logger.i(dataDet);
    });

    for (var dataDet in dataDetList) {
      final chargerule = dataDet['CHARGERULE'][0];

      logger.d("currentRule :: $chargerule");

      try {
        if (chargerule['ACCOUNTBAL']['DISPLAY'].toString() == "PAYG") {
          isPayg = true;
          result.add({
            "dataDet": dataDet,
            "name": dataDet["PACKNAME"],
            "percent": 100,
            "displayText": "PAYG",
            "validity":
                "Validity: ${dataDet["VALIDITY"].toString().split(' ')[0]}",
            "color": "#5fbb49",
            "usage":
                "Usage: ${chargerule['USEDBAL']['DISPLAY']}/${chargerule['ACCOUNTBAL']['DISPLAY']}",
            "isPayg": true
          });
        } else if (chargerule['ACCOUNTBAL']['DISPLAY'].toString() ==
            "Unlimited") {
          isPayg = true;
          result.add({
            "dataDet": dataDet,
            "name": dataDet["PACKNAME"],
            "percent": 0,
            "displayText": "Unlimited",
            "validity":
                "Validity: ${dataDet["VALIDITY"].toString().split(' ')[0]}",
            "color": "#5fbb49",
            "usage": "Remaining: ${chargerule['ACCUMLATEDACCT']['DISPLAY']}",
            "isPayg": true
          });
        } else {
          isPayg = false;
          // logger.d(
          //     "$availablePercentageDisplay ${availablePercentageDisplay.toStringAsFixed(2)}");
          // logger.d(
          //     "Percentage display :: $availablePercentageDisplay ${100 - availablePercentageDisplay}");
          result.add({
            "dataDet": dataDet,
            "name": dataDet["PACKNAME"],
            "percent": double.parse(
                ((double.parse(chargerule['USEDBAL']['RAW']) /
                            double.parse(chargerule['ACCUMLATEDACCT']['RAW'])) *
                        100)
                    .toStringAsFixed(2)),
            "displayText":
                "${double.parse(((double.parse(chargerule['USEDBAL']['RAW']) / double.parse(chargerule['ACCUMLATEDACCT']['RAW'])) * 100).toStringAsFixed(2))}%",
            "validity":
                "Validity: ${dataDet["VALIDITY"].toString().split(' ')[0]}",
            "color": "#5fbb49",
            // "usage": "Remaining: ${double.parse(remainingData.toStringAsFixed(2))} $remainingUnit/${double.parse(totalData.toStringAsFixed(2))} $totalUnit",
            "usage":
                "Remaining: ${chargerule['ACCOUNTBAL']['DISPLAY']}/${chargerule['ACCUMLATEDACCT']['DISPLAY']}",
            "isPayg": false
          });
        }
        // registry.setValue("isPayg", isPayg);
      } catch (e) {
        logger.i("catch block $e");
        // logger.i(
        //     "totalDataDisplay: $totalDataDisplay, totalDataUnit: $totalUnit, usedDataDisplay: $usedDataDisplay, remainingDataDisplay: $remainingDataDisplay");
        result.add({
          "dataDet": dataDet,
          "name": dataDet["PACKNAME"],
          "percent": 0,
          "displayText": "0%",
          "validity":
              "Validity: ${dataDet["VALIDITY"].toString().split(' ')[0]}",
          "color": "#5fbb49",
          "usage": "Remaining: N/A",
          "isPayg": false
        });
      }
    }
    registry.setValue("dataDetList", result);
    logger.i("data Display list: $result");
  } catch (e) {
    logger.i("catch block for exception: $e");
    final dataList = [
      {
        "name": "N/A",
        "percent": 0,
        "displayText": "N/A",
        "validity": "Validity: N/A",
        "color": "#A9A9A9",
        "usage": "Remaining: N/A",
        "isPayg": false
      }
    ];
    registry.setValue("dataDetList", dataList);
    registry.setValue("rechargeDataPercent", 0);
    registry.setValue("rechargeData", "N/A");
    logger.e("Error2 in dataDetList: $dataList");
  }

  logger
      .d("HomePage.json :: dataDetList :: ${registry.getValue("dataDetList")}");

  try {
    if (registry.getValue("dataDetList") == null ||
        List.from(registry.getValue("dataDetList")).isEmpty) {
      final dataList = [
        {
          "name": "N/A",
          "percent": 0,
          "displayText": "N/A",
          "validity": "Validity: N/A",
          "color": "#A9A9A9",
          "usage": "Remaining: N/A",
          "isPayg": false
        }
      ];
      registry.setValue("dataDetList", dataList);
      logger.e("Error1 in dataDetList: $dataList");
    }
  } catch (e) {
    final dataList = [
      {
        "name": "N/A",
        "percent": 0,
        "displayText": "N/A",
        "validity": "Validity: N/A",
        "color": "#A9A9A9",
        "usage": "Remaining: N/A",
        "isPayg": false
      }
    ];
    registry.setValue("dataDetList", dataList);
    logger.e("Error in dataDetList: $dataList");
  }

  registry.setValue("rechargeTalkTimePercent", 0);
  registry.setValue("broadBandPercent", 0);
  registry.setValue("leaseLinePercent", 0);

  try {
    registry.setValue("talktimeValidity",
        "${userType == "0" ? "Validity:" : "Due Date:"} ${loggedInServiceDetails['EXPDATE']}");
  } catch (e) {
    registry.setValue("talktimeValidity",
        "${userType == "0" ? "Validity:" : "Due Date:"} N/A");
  }

  try {
    registry.setValue("broadBandValidity",
        "Validity: ${loggedInServiceDetails['BBVALIDITY']}");
    logger.i("Before BROADBAND DUES");
    logger.i(loggedInServiceDetails['BBVALIDITY']);
    if (loggedInServiceDetails['BBVALIDITY'] != "N/A" &&
        loggedInServiceDetails['BBVALIDITY'] != "") {
      availableMap['BROADBAND DUES'] = true;
    } else {
      availableMap['BROADBAND DUES'] = false;
    }
  } catch (e) {
    availableMap['BROADBAND DUES'] = false;
    registry.setValue("broadBandValidity", "Validity: N/A");
  }

  try {
    registry.setValue("broadBandBalance",
        "${loggedInServiceDetails['BBREMBAL'] == "" ? "N/A" : loggedInServiceDetails['BBREMBAL']}");
    logger.i("Before BROADBAND DUES ");
    logger.i(loggedInServiceDetails['BBREMBAL']);
    if (loggedInServiceDetails['BBREMBAL'] != "N/A" &&
        loggedInServiceDetails['BBREMBAL'] != "") {
      availableMap['BROADBAND DUES'] = true;
    } else {
      availableMap['BROADBAND DUES'] = false;
      logger.i(loggedInServiceDetails['BBREMBAL']);
    }
  } catch (e) {
    availableMap['BROADBAND DUES'] = false;
    registry.setValue("broadBandBalance", "N/A");
  }

  try {
    registry.setValue(
        "promoValidity", "Validity: ${loggedInServiceDetails['PROMOEXPIRY']}");
    if (loggedInServiceDetails['PROMOEXPIRY'] != "N/A") {
      availableMap['PROMO'] = true;
    } else {
      availableMap['PROMO'] = false;
    }
  } catch (e) {
    availableMap['PROMO'] = false;
    registry.setValue("promoValidity", "Validity: N/A");
  }

  try {
    registry.setValue("rechargeDataValidity",
        "Validity: ${customerDet['DATADET'][0]['VALIDITY'].toString().split(" ")[0]}");
  } catch (e) {
    logger.i("$e");
    registry.setValue("rechargeDataValidity", "Validity: N/A");
  }

  registry.setValue("promoData", "N/A");
  registry.setValue("promoDataPercent", 0);

  registry.setValue("promoTalkTimeBal", "N/A");
  registry.setValue("promoTalkTImePercent", 0);

  registry.setValue("leaseLineDues", "N/A");
  registry.setValue("leaseLineValidity", "validity: N/A");

  logger.d(
      "currentService :: $currentService :: ${currentService!.serviceNumber}");

  String balance = customerDet['ACCOUNTDET']['BALANCE'].toString();
  String promoBalance = customerDet['ACCOUNTDET']['PROMOBAL'].toString();
  TextEditingController profileNameController = TextEditingController();
  TextEditingController profilePhoneController = TextEditingController();
  TextEditingController profileEmailController = TextEditingController();
  registry.setValue("profileNameController", profileNameController);
  registry.setValue("profilePhoneController", profilePhoneController);
  registry.setValue("profileEmailController", profileEmailController);
  registry.setValue("userGreet", "Hi,");
  registry.setValue("name", "");
  registry.setValue("profileServiceInfo", " ");
  registry.setValue("srcMSISDN", " ");
  try {
    profileNameController.text = currentService!.name;
    profilePhoneController.text = currentService!.serviceNumber;
    registry.setValue("userGreet", "Hi, ${currentService!.name}");
    registry.setValue("name", currentService!.name);
    registry.setValue("Useraddress", currentService!.address);
    registry.setValue(
        "profileServiceInfo",
        "${selectedServiceType == "Prepaid" ? "Mobile " : selectedServiceType == "Postpaid" ? "Mobile " : ""}$selectedServiceType : ${currentService!.serviceNumber}");
    registry.setValue(
        "srcMSISDN",
        "${selectedServiceType == "Prepaid" ? "Mobile " : selectedServiceType == "Postpaid" ? "Mobile " : ""}$selectedServiceType : ${currentService!.serviceNumber}");
  } catch (e) {
    logger.i("Current service exception $e");
  }
  registry.setValue('promoBal', promoBalance);
  registry.setValue("talkTimeBal", balance);
  logger.i("profileServiceInfo: ${registry.getValue("profileServiceInfo")}");
  logger.d("loggedInMobile :: $loggedInMobile");
}

Future<void> BngulLowBalance(String available) async {
  logger.i(
      "amount and Bngul balance: ${available} ${bNuglBal} ${registry.getValue("availableBNgul")}");
  if (double.parse(available) > double.parse(bNuglBal)) {
    double calcRemMoney = double.parse(available) - double.parse(bNuglBal);
    String reqBal = calcRemMoney.ceil().toString();
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Card(
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Ensures the dialog fits its content
                children: [
                  Text(
                    'Your available B-Ngul balance Nu.$bNuglBal is less than the pack amount Nu.${available}, Add Nu.$reqBal to wallet?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Color.fromARGB(255, 250, 41, 41),
                          shadowColor: Color.fromRGBO(0, 0, 0, 1),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Color(0xFF5FBB49),
                          shadowColor: Color.fromRGBO(0, 0, 0, 1),
                        ),
                        child: Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () async {
                          navigatorKey.currentState!.pop();
                          addMoneyFromRecharge = true;
                          rechargeAddMoneyAmount = reqBal;
                          // await navigatorKey.currentState!.push(
                          //     MaterialPageRoute(
                          //         builder: (context) => AddMoney()));
                          Future.delayed(const Duration(seconds: 3), () {
                            addMoneyFromRecharge = false;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<bool> validateRegex(String serviceName, String fieldName,
    TextEditingController controller) async {
  String? data = await FetchPages.getPageByName("regexConfig.json");
  logger.i("===============data $data=================");
  if (data != null) {
    Map<String, dynamic> regexData = jsonDecode(data);
    logger.i("regexData :: $regexData");
    RegExp pattern = RegExp(regexData[serviceName][fieldName]);
    logger.i(
        "pattern :: $pattern :: raw :: ${regexData[serviceName][fieldName]}");
    if (pattern.hasMatch(controller.text)) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<void> clearMaps() async {
  loginResponse = {};
  customerDet = {};
  statusVasServices = {};
  btunesPlanDetails = {};
  btunesRegDetails = {};
  btunesPurchaseDetails = {};
  transactionHistoryData = {};
  mcaActivationInfo = {};
  transactions = [];
  recentTransactions = [];
  bbMacbindingInfo = {};
  btunesTopTen = [];
  btunesLatestTen = [];
  btunesMyTunes = [];
  dataPackDetails = [];
  prePaidDetList = [];
  postPaidDetList = [];
  broadBandDetList = [];
  walletDetails = [];
  walletBankDetails = [];
  otherTransactionsEloadHistory = [];
  missedCallAlert = {};
  services = {};
  serviceDet = {};
  eLoadInfo = {};
  bNuglBal = "";
  addMoneyFromRecharge = false;
  rechargeAddMoneyAmount = "";
  forgotPinMobile = "";
  transactionID = "";
  loggedInSessionId = " ";
  transactionSessionId = " ";
  loggedInMobile = " ";
  allServices = [];
  registeredServicNames = [];
  registeredServices = {};
  selectedServiceType = "";
  loggedInServiceDetails = {};
  profileStatus = {};
  paymentResponse = {};
}

// String textformfield_color =
//     registry.getValue("TEXTFORM_COLOR").toString().replaceAll("#", "");
// String airtimepurchase_submit_button_color = registry
//     .getValue("AIRTIME_PURCHASE_SUBMIT_BUTTON_BGCOLOR")
//     .toString()
//     .replaceAll("#", "");

Future<String?> loadAndMergeJson(String pageName) async {
  try {
    String? mergeString = await FetchPages.getPageByName("mainTemplate62.json");
    // String mergeString = await DefaultAssetBundle.of(context)
    // .loadString('lib/assets/mainTemplate.json');
    String? json2String = await FetchPages.getPageByName(pageName);
    // String json2String = await DefaultAssetBundle.of(context)
    //     .loadString('lib/assets/ekycTemplate.json');
    if (json2String != null && mergeString != null) {
      logger.i("inside merge json page ");
      // json2 = json.decode(json2String);
      logger.d("json2------- ");
      logger.d("mergeString------- = ");
      double responsiveHeight =
          screenHeightForJson * 0.8; // Adjust height to 90% of the screen

      logger.i("responsiveHeight: $responsiveHeight");
      registry.setValue('responsiveHeight', responsiveHeight);
      // final data =
      //     mergeString.replaceFirst('"{{profileContent}}"', json.encode(json2));
      // logger.d("merge string = $mergeString");

      // return data;
    }
  } catch (e) {
    // sendCrashReport('Error loading or merging JSON: $e');
    logger.i("Error loading or merging JSON: $e");
    return null;
  }
  return null;
}

optionalUpdate(BuildContext context, String message) {
  logger.i("loading...");
  showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return SimpleDialog(
          insetPadding: EdgeInsets.all(5),
          backgroundColor: Colors.transparent,
          title: Card(
              color: Color.fromRGBO(232, 232, 232, 1),
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        registry.getValue("UPDATE_POPUP_HEADING"),
                        style: TextStyle(
                            color: Color(0xFF1C3144),
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: 300,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                        child: Text(
                          // userBankDetails['RESPONSE']['RESPDESC']
                          //     .toString(),
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.transparent,
                          elevation: 10,
                          child: Container(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Color(0xFF5FBB49),
                                  shadowColor: Color.fromRGBO(0, 0, 0, 1)),
                              child: Text(
                                'Update',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                // logger.i(response);
                                // _launchUrl(authResponse['PLAYSTORE']);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Material(
                          color: Colors.transparent,
                          elevation: 10,
                          child: Container(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Color(0xFF5FBB49),
                                  shadowColor: Color.fromRGBO(0, 0, 0, 1)),
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                // navigatorKey.currentState!.pushReplacement(
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           const landingPage(jsonString: "")),
                                // );
                                navigatorKey.currentState!.pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )),
        );
      });
}

forceUpdate(BuildContext context, String message) {
  logger.i("loading...");
  showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return SimpleDialog(
          insetPadding: EdgeInsets.all(5),
          backgroundColor: Colors.transparent,
          title: Card(
              color: Color.fromRGBO(232, 232, 232, 1),
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        MFS_REGISTER_HEADING,
                        style: TextStyle(
                            color: Color(0xFF1C3144),
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: 300,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                        child: Text(
                          // userBankDetails['RESPONSE']['RESPDESC']
                          //     .toString(),
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.transparent,
                          elevation: 10,
                          child: Container(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Color(0xFF5FBB49),
                                  shadowColor: Color.fromRGBO(0, 0, 0, 1)),
                              child: Text(
                                'Update',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                // logger.i(response);
                                // _launchUrl(authResponse['PLAYSTORE']);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )),
        );
      });
}

serverDown(BuildContext context, String message) {
  logger.i("loading...");
  showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return SimpleDialog(
          insetPadding: EdgeInsets.all(5),
          backgroundColor: Colors.transparent,
          title: Card(
              color: Color.fromRGBO(232, 232, 232, 1),
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        MFS_REGISTER_HEADING,
                        style: TextStyle(
                            color: Color(0xFF1C3144),
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: 300,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                        child: Text(
                          // userBankDetails['RESPONSE']['RESPDESC']
                          //     .toString(),
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.transparent,
                          elevation: 10,
                          child: Container(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Color(0xFF5FBB49),
                                  shadowColor: Color.fromRGBO(0, 0, 0, 1)),
                              child: Text(
                                'ok',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                // logger.i(response);
                                navigatorKey.currentState!.pop();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )),
        );
      });
}

String generateRandomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}
