import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:mybtapp_testapp_testapp_test/main.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:mybtapp_testapp_testapp_test/global/fetchPages.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/global.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Services/showLoading.dart';
import 'package:mybtapp_testapp_testapp_test/phase/Provider/themeProvider.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/variableDeclaration.dart';

final List<String> banners = [];
final screenHeight = MediaQuery.of(navigatorKey.currentContext!).size.height;
final screenHeightForOtp =
    MediaQuery.of(navigatorKey.currentContext!).size.height;
Map<String, String> getHelpDataForTitle(String title) {
  switch (title) {
    case 'Profile':
      return {"pt1": PROFILEPAGE};
    case 'CHANGEPINPAGE':
      return {"pt1": ""};
    case 'FUNDTRANSFER':
      return {"pt1": FUNDTRANSFER};
    default:
      return {"pt1": "No help available for this page"};
  }
}

Future<Map<String, dynamic>> loadPageProperties() async {
  final String response =
      await rootBundle.loadString("lib/phase/jsons/pageProperties.json");
  // final String? response =
  //     await FetchPages.getPageByName("pageProperties.json");

  if (response == null) {
    throw Exception("Failed to load pageProperties.json");
  }

  final Map<String, dynamic> decoded = json.decode(response);
  registry.setValue("pageProperties", decoded);

  return decoded;
}

Widget buildContactInfo() {
  return Column(
    children: [
      Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: GestureDetector(
            onTap: launchPhone,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1C3144),
                  ),
                  child: const Icon(
                    Icons.phone,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Contact 1600",
                      style: TextStyle(
                        fontFamily: "Gilroy-Regular",
                        color: Color(0xFF1C3144),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "For any queries",
                      style: TextStyle(
                        fontFamily: "Gilroy-Regular",
                        color: Color(0xFF1C3144),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Future<void> configureAndFetchPages() async {
  //LAB
  const String baseUrl = "https://btapp165.tayana.in";
  const String pageId = "1074";

  //TQA
  // const String baseUrl = "https://106.51.72.98:8051";
  // const String pageId = "1074";

  // //TB
  // const String baseUrl = "http://202.144.156.10:4000";
  // const String pageId = "1076";

  //LIVENEW
  // const String baseUrl = "http://202.144.156.90:4000";
  // const String pageId = "1078";

  //LIVE
  // const String baseUrl = "https://mybt.bt.bt:4000";
  // const String pageId = "1074";

  //LIVEHTTPS
  // const String baseUrl = "https://mybt.bt.bt:4000";
  // const String pageId = "1078";

  try {
    await FetchPages.fetchPagesFromAPI(baseUrl, pageId);
  } catch (e) {
    // Optional: Add logging or error handling
    print("Error fetching pages: $e");
  }
}

FontWeight parseFontWeight(String weight) {
  switch (weight.toLowerCase()) {
    case "bold":
      return FontWeight.bold;
    case "w500":
      return FontWeight.w500;
    case "w600":
      return FontWeight.w600;
    case "w700":
      return FontWeight.w700;
    case "light":
      return FontWeight.w300;
    case "thin":
      return FontWeight.w100;
    default:
      return FontWeight.normal;
  }
}

Color parseColor(String hexCode) {
  hexCode = hexCode.trim().replaceAll('#', '').toUpperCase();
  if (hexCode.startsWith('0X')) {
    return Color(int.parse(hexCode));
  }
  if (hexCode.length == 6) {
    hexCode = 'FF$hexCode';
  }
  if (hexCode.length != 8) {
    throw FormatException('Invalid color format: $hexCode');
  }
  return Color(int.parse('0x$hexCode'));
}

class CustomisedWidgets {
  static Widget buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              leading: Icon(icon, color: themeProvider.primaryColor, size: 30),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: themeProvider.fontFamily,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios,
                  color: themeProvider.primaryColor),
              onTap: onPressed,
            ),
          ),
        );
      },
    );
  }

  static Widget buildList({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.15, // Adjust width
            child: Icon(icon, color: const Color(0xFF124682), size: 30),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontFamily: themeProvider.fontFamily,
            ),
          ),
          trailing:
              const Icon(Icons.arrow_forward_ios, color: Color(0xFF124682)),
          onTap: onPressed, // Calls function when tapped
        ),
      ),
    );
  }
}

class PopupMenuHelper {
  static Widget buildPopupMenu(
      BuildContext context, Color color, ThemeProvider themeProvider) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.info_outlined,
        size: 35,
        color: color,
      ),
      onSelected: (String value) {},
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      itemBuilder: (BuildContext context) {
        return [
          buildPopupMenuItem(
              context, Icons.question_mark_outlined, "FAQ", themeProvider),
          buildDividerItem(),
          buildPopupMenuItem(context, Icons.phone, "Contact Us", themeProvider),
          buildDividerItem(),
          buildPopupMenuItem(
              context, Icons.info_outline, "Help and Info", themeProvider),
          buildDividerItem(),
          buildPopupMenuItem(
              context, Icons.help_outline, "About Us", themeProvider),
        ];
      },
    );
  }

  static PopupMenuItem<String> buildPopupMenuItem(
    BuildContext context,
    IconData icon,
    String text,
    ThemeProvider themeProvider,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double desiredWidth = screenWidth * 0.50;

    return PopupMenuItem<String>(
      value: text,
      padding: EdgeInsets.zero, // ✅ No extra space around item
      height: screenHeight * 0.065, // ✅ Slightly taller if needed for padding
      child: Container(
        width: desiredWidth,
        color: Colors.white,
        alignment: Alignment.centerLeft, // ✅ Ensures content aligns left
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.03,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              icon,
              color: const Color(0xFF1C3144),
              size: screenWidth * 0.06,
            ),
            SizedBox(width: screenWidth * 0.055),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w500,
                  fontFamily: themeProvider.fontFamily,
                  color: const Color(0xFF1C3144),
                ),
                overflow: TextOverflow.ellipsis, // Prevents overflow
              ),
            ),
          ],
        ),
      ),
    );
  }

  static PopupMenuItem<String> buildDividerItem() {
    return const PopupMenuItem<String>(
      enabled: false,
      height: 1,
      padding: EdgeInsets.zero,
      child: Divider(
        color: Color(0xFFE0E0E0),
        thickness: 1,
        height: 1,
        indent: 0,
        endIndent: 0,
      ),
    );
  }

  // static void handleMenuSelection(BuildContext context, String value) async {
  //   switch (value) {
  //     case "FAQ":
  //       showLoading(context);
  //       final response = await faq();
  //       logger.i("Response: $response");
  //       navigatorKey.currentState!.pop();
  //       await navigatorKey.currentState!.push(
  //         MaterialPageRoute(builder: (_) => const FAQPage()),
  //       );
  //       break;

  //     case "Contact Us":
  //       showLoading(navigatorKey.currentContext!);
  //       final response = await contactUs();
  //       navigatorKey.currentState!.pop();

  //       registry.setValue(
  //           "contactEmail", response['contact_us']['email'] ?? " ");
  //       registry.setValue(
  //           "contactMobile", response['contact_us']['phone_number'] ?? " ");
  //       registry.setValue(
  //           "facebook", response['contact_us']['facebook_link'] ?? " ");
  //       registry.setValue(
  //           "instagram", response['contact_us']['instagram_link'] ?? " ");
  //       registry.setValue(
  //           "tiktok", response['contact_us']['tiktok_link'] ?? " ");

  //       await navigatorKey.currentState!.push(
  //         MaterialPageRoute(
  //             builder: (_) => const contactUsHomePage(jsonString: "")),
  //       );
  //       break;

  //     case "Help and Info":
  //       final Uri url = Uri.parse("https://www.bt.bt/");
  //       if (await canLaunchUrl(url)) {
  //         await launchUrl(url);
  //       } else {
  //         throw 'Could not launch $url';
  //       }
  //       break;

  //     case "About Us":
  //       await navigatorKey.currentState!.push(
  //         MaterialPageRoute(builder: (_) => const AboutUs(jsonString: "")),
  //       );
  //       break;
  //   }
  // }
}

class CustomBottomNavigation extends StatelessWidget {
  final String current;
  final BuildContext context;

  const CustomBottomNavigation({
    Key? key,
    this.current = '',
    required this.context,
  }) : super(key: key);

  // Constants
  static const Color activeColor = Color(0xFFF37B26);
  static const Color activeTextColor = Color(0xFFF37B26);
  static const Color inActiveTextColor = Color(0xFFE8E8E8);
  static const Color inactiveColor = Color(0xFFE8E8E8);
  static const Color backgroundColor = Color(0xFF1C3144);
  static const Color barColor = Color(0xFFE8E8E8);

  // Navigation handlers
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Dynamically calculated sizes
    final double iconSize = (screenWidth * 0.04).clamp(24.0, 36.0);
    final double fontSize = (screenWidth * 0.028).clamp(10.0, 16.0);

    return Container(
      height: screenHeight * 0.06,
      color: barColor,
      child: Container(
        color: backgroundColor,
        child: Row(
          children: [
            _buildExpandedItem('Home', Icons.dashboard_outlined,
                current == 'Home', iconSize, fontSize),
            _buildExpandedItem('Contact Us', Icons.mail_outline,
                current == 'Contact Us', iconSize, fontSize),
            _buildExpandedNotificationItem(
                current == 'Notifications', iconSize, fontSize),
            _buildExpandedItem('Profile', Icons.account_circle_outlined,
                current == 'Profile', iconSize, fontSize),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedItem(String label, IconData icon, bool isActive,
      double iconSize, double fontSize) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isActive ? activeColor : inactiveColor, size: iconSize),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeTextColor : inActiveTextColor,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedNotificationItem(
      bool isActive, double iconSize, double fontSize) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none_outlined,
                    color: isActive ? activeColor : inactiveColor,
                    size: iconSize),
                Text(
                  "Notifications",
                  style: TextStyle(
                    color: isActive ? activeTextColor : inActiveTextColor,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
            if (newNotification)
              Positioned(
                right: 25,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: activeColor,
                    border: Border.all(color: Colors.black),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      notificationCount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  final int maxLength;
  final String? errorText;
  final VoidCallback? onVisibilityToggle;
  final bool obscureText;
  final bool hasSuffixButton;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final String propertyType;
  final Map<String, dynamic> properties;
  final bool readOnly;
  final FocusNode? focusNode;
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.label,
      this.isPassword = false,
      required this.keyboardType,
      required this.maxLength,
      this.errorText,
      this.onVisibilityToggle,
      this.obscureText = false,
      this.hasSuffixButton = false,
      this.suffixIcon,
      this.onSuffixPressed,
      required this.propertyType,
      required this.properties,
      required this.readOnly,
      required this.focusNode});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontColor = parseColor(properties['fontColor'] ?? "#000000");
    final fontSize = (properties['fontSize'] ?? 14).toDouble();
    final fontWeight = parseFontWeight(properties['fontWeight'] ?? "bold");
    final backgroundColor =
        parseColor(properties['backgroundColor'] ?? "#FFFFFF");
    final padding = (properties['padding'] ?? 20).toDouble();
    final borderRadius = (properties['borderRadius'] ?? 8).toDouble();
    final inputFormatters = <TextInputFormatter>[
      LengthLimitingTextInputFormatter(maxLength),
      if (keyboardType == TextInputType.phone ||
          keyboardType == TextInputType.number)
        FilteringTextInputFormatter.digitsOnly
      else if (keyboardType == TextInputType.emailAddress)
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9@._-]'))
      else
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: themeProvider.fontFamily,
              color: fontColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: TextField(
            focusNode: focusNode,
            readOnly: readOnly,
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              letterSpacing: 8.0,
              fontFamily: themeProvider.fontFamily,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                letterSpacing: 2.0,
                color: Colors.grey,
                fontFamily: themeProvider.fontFamily,
              ),
              counterText: "",
              filled: true,
              fillColor: backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: onVisibilityToggle,
                    )
                  : hasSuffixButton
                      ? IconButton(
                          icon: Icon(suffixIcon, color: Colors.black),
                          onPressed: onSuffixPressed,
                        )
                      : null,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4, left: padding),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontFamily: themeProvider.fontFamily,
              ),
            ),
          ),
      ],
    );
  }
}

PageRouteBuilder createSlideTransitionRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

PageRouteBuilder createFadeTransitionRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      ));

      return FadeTransition(opacity: fadeAnimation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 500),
  );
}

PageRouteBuilder createScaleTransitionRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var scaleAnimation = Tween(begin: 0.5, end: 1.0).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ));

      return ScaleTransition(scale: scaleAnimation, child: child);
    },
  );
}

navigateToService(String label, BuildContext context) async {
  logger.i("label : $label");
  // Navigate based on route name
  switch (label) {
    default:
  }
}

IconData parseIcon(dynamic iconValue) {
  if (iconValue is int) {
    return IconData(iconValue, fontFamily: 'MaterialIcons');
  }
  if (iconValue is String) {
    int codePoint = int.parse(iconValue);
    return IconData(codePoint, fontFamily: 'MaterialIcons');
  }
  return Icons.info;
}

Widget buildTabBar(List<dynamic> childrens, BuildContext context,
    [confirmationLabel]) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final fontFamily = themeProvider.fontFamily;

  return Container(
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide.none,
      ),
    ),
    child: TabBar(
      labelColor: const Color(0xFF124682),
      unselectedLabelColor: Colors.grey,
      labelStyle: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.normal,
        fontSize: 15,
      ),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 3.0,
          color: Color(0xFFF8BD00), // your custom yellow
        ),
        insets: EdgeInsets.symmetric(horizontal: 19.0),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: Colors.transparent,
      tabs: childrens.map((tabConfig) {
        final title = tabConfig['title'] ?? 'Tab';
        return Tab(text: title);
      }).toList(),
    ),
  );
}

Widget buildTabContent(
    Map<String, dynamic> tabConfig, dynamic provider, BuildContext context,
    [String? confirmationLabel]) {
  switch (tabConfig['type']) {
    case 'Table':
      final dataKey = tabConfig['dataKey'];
      logger.i("dataKey: $dataKey");
      final transactions = getTransactionsByKey(provider, dataKey);
      return _buildBalanceTable(transactions);

    case 'row':
      final dataKey = tabConfig['dataKey'];
      final plans = getTransactionsByKey(provider, dataKey);
      return buildPlanList(plans, confirmationLabel);

    case 'ott':
      final dataKey = tabConfig['dataKey'];
      final plans = getTransactionsByKey(provider, dataKey);
      return buildOttList(plans);

    case 'tracker':
      final dataKey = tabConfig['dataKey'];
      final plans = getTransactionsByKey(provider, dataKey);
      return buildTrackerList(plans, context);

    case 'Tab':
      final tabChildren = tabConfig['childrens'] as List<dynamic>;

      return DefaultTabController(
        length: tabChildren.length,
        child: Column(
          children: [
            buildTabBar(tabChildren, context),
            SizedBox(
              height: getHeightForPage(context, tabConfig['pageName']),
              child: TabBarView(
                children: tabChildren.map((childTabConfig) {
                  return buildTabContent(
                      childTabConfig, provider, context, confirmationLabel);
                }).toList(),
              ),
            ),
          ],
        ),
      );

    default:
      return Container();
  }
}

List<Map<String, dynamic>> getTransactionsByKey(dynamic provider, String key) {
  try {
    final data = provider.contentData();
    logger.i("data: $data key: $key");

    final rawList = data[key];

    if (rawList is List<String>) {
      // Convert List<String> to List<Map<String, dynamic>>
      final converted = rawList.map((e) => {'value': e, 'label': e}).toList();
      logger.i("Converted List<String> to List<Map>: $converted");
      return converted;
    }

    if (rawList is List) {
      // If already List<Map>, ensure safe casting
      return rawList.map((e) {
        if (e is Map<String, dynamic>) return e;
        return Map<String, dynamic>.from(e as Map);
      }).toList();
    }

    logger.w("Unsupported data type for key '$key': ${rawList.runtimeType}");
    return [];
  } catch (e, stack) {
    logger.e("Error in getTransactionsByKey: $e\n$stack");
    return [];
  }
}

Widget _buildBalanceTable(List<Map<String, dynamic>> transactions) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double fontSize = constraints.maxWidth < 350 ? 12 : 14;
      double rowHeight = constraints.maxHeight / (transactions.length + 9.5);

      if (transactions.isEmpty) {
        return const Text("No data available.");
      }

      final columns =
          transactions.first.keys.where((key) => key != 'label').toList();

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.grey[300]!),
                verticalInside: BorderSide(color: Colors.grey[300]!),
              ),
              columnWidths: {
                0: const FlexColumnWidth(2),
                for (int i = 1; i <= columns.length; i++)
                  i: const FlexColumnWidth(1.5),
              },
              children: [
                TableRow(
                  children: [
                    _buildHeaderCell('Label', fontSize, rowHeight, context),
                    for (var col in columns)
                      _buildHeaderCell('${capitalize(col)} (SR)', fontSize,
                          rowHeight, context),
                  ],
                ),
                for (var tx in transactions)
                  TableRow(
                    children: [
                      _buildDataCell(tx['label'].toString(), fontSize,
                          rowHeight, const Color(0xFF124682), context),
                      for (var col in columns)
                        _buildDataCell(
                          (tx[col] is double)
                              ? (tx[col] as double).toStringAsFixed(2)
                              : tx[col].toString(),
                          fontSize,
                          rowHeight,
                          Colors.black,
                          context,
                        ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildHeaderCell(
    String text, double fontSize, double rowHeight, BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);

  return Container(
    height: rowHeight,
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Text(text,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF124682),
            fontSize: fontSize,
            fontFamily: themeProvider.fontFamily),
        textAlign: TextAlign.center),
  );
}

Widget _buildDataCell(String text, double fontSize, double rowHeight,
    Color color, BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);

  return Container(
    height: rowHeight,
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        fontFamily: themeProvider.fontFamily,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

Widget buildPlanList(List<Map<String, dynamic>> plans, [confirmationLabel]) {
  if (plans.isEmpty) {
    return const Center(child: Text("No plans available."));
  }
  return ListView.builder(
    itemCount: plans.length,
    itemBuilder: (context, index) {
      final planData = plans[index];
      return _buildRow(
        plan: planData['plan'] ?? '',
        details: planData['details'] ?? '',
        price: planData['price'] ?? '',
        validity: planData['validity'] ?? '',
        index: index,
        confirmationLabel: confirmationLabel,
      );
    },
  );
}

Widget _buildRow({
  required String plan,
  required String details,
  required String price,
  required String validity,
  required int index,
  required confirmationLabel,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double fontSize = constraints.maxWidth < 350 ? 12 : 14;
      final themeProvider = Provider.of<ThemeProvider>(context);

      const Color color1 = Color(0xFFF8BD00);
      const Color color2 = Color(0xFF0980DC);

      final Color labelColor = index % 2 == 0 ? color1 : color2;
      final Color lightBackground = labelColor.withOpacity(0.1);

      return GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 30,
                  decoration: BoxDecoration(
                    color: labelColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    plan,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: themeProvider.fontFamily,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    decoration: BoxDecoration(
                      color: lightBackground,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  details,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF124682),
                                    fontFamily: themeProvider.fontFamily,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // if (validity.isNotEmpty)
                                Text(
                                  'Validity: ${validity.isNotEmpty ? validity : 'N/A'}',
                                  style: TextStyle(
                                    fontSize: fontSize - 1,
                                    color: const Color(0xFF124682),
                                    fontFamily: themeProvider.fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Price
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Center(
                              child: Text(
                                price,
                                style: TextStyle(
                                  fontSize: fontSize + 2,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF124682),
                                  fontFamily: themeProvider.fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildCatalogSection(List<dynamic> rawData) {
  try {
    final List<Map<String, dynamic>> castedData =
        List<Map<String, dynamic>>.from(rawData);
    return buildOttList(castedData);
  } catch (e) {
    return const Center(child: Text('Invalid catalog data.'));
  }
}

Widget buildOttList(List<Map<String, dynamic>> plans) {
  if (plans.isEmpty) {
    return const Center(child: Text("No plans available."));
  }

  return GridView.builder(
    padding: EdgeInsets.zero,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 6,
      mainAxisSpacing: 9,
      childAspectRatio: 0.46,
    ),
    itemCount: plans.length,
    itemBuilder: (context, index) {
      final planData = plans[index];
      return _buildOttRow(
        context: context,
        title: planData['title'] ?? '',
        price: planData['price'] ?? '',
        description: planData['description'] ?? '',
        logoPath: planData['logoPath'] ?? '',
        bgImagePath: planData['bgImagePath'] ?? '',
        index: index,
      );
    },
  );
}

Widget _buildOttRow({
  required String title,
  required String price,
  required String description,
  required String logoPath,
  required String bgImagePath,
  required int index,
  required BuildContext context,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final scale = MediaQuery.of(context).textScaleFactor;

  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Container(
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: bgImagePath.startsWith('http')
                        ? Image.network(
                            bgImagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: screenWidth * 0.28,
                          )
                        : Image.asset(
                            bgImagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: screenWidth * 0.28,
                          ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              price,
                              style: TextStyle(
                                fontSize: 16 * scale,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16 * scale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            description,
                            style: TextStyle(
                              fontSize: 14 * scale,
                              color: const Color(0xFF124682),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: screenWidth * 0.23,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  backgroundImage: logoPath.startsWith('http')
                      ? NetworkImage(logoPath)
                      : AssetImage(logoPath) as ImageProvider,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

double getHeightForPage(BuildContext context, String pageName) {
  switch (pageName) {
    case 'balance':
      return MediaQuery.of(context).size.height * 0.70;
    case 'tracker':
      return MediaQuery.of(context).size.height * 0.73;
    case 'trackerTab2':
      return MediaQuery.of(context).size.height * 0.641;
    case 'prepaidPacks':
      return MediaQuery.of(context).size.height * 0.577;
    default:
      return MediaQuery.of(context).size.height * 0.50;
  }
}

Widget buildTrackerList(
  List<Map<String, dynamic>> transactions,
  BuildContext context,
) {
  final themeProvider = Provider.of<ThemeProvider>(context);

  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  String selectedTransactionType = 'All';
  List<String> transactionTypes = ['All'] +
      transactions
          .map((tx) => tx['transaction_type'].toString())
          .toSet()
          .toList();

  List<Map<String, dynamic>> filteredTransactions = List.from(transactions);

  return StatefulBuilder(
    builder: (context, setState) {
      void filterResults(String query) {
        setState(() {
          searchQuery = query.toLowerCase();
          filteredTransactions = transactions
              .where((tx) =>
                  tx['msisdn'].toString().toLowerCase().contains(searchQuery) &&
                  (selectedTransactionType == 'All' ||
                      tx['transaction_type'] == selectedTransactionType))
              .toList();
        });
      }

      return Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 238, 235, 235),
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  child: TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: TextStyle(
                      letterSpacing: 6.0,
                      fontFamily: themeProvider.fontFamily,
                    ),
                    controller: searchController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Search Mobile Number',
                      hintStyle: TextStyle(
                        letterSpacing: 2.0,
                        color: Colors.grey,
                        fontFamily: themeProvider.fontFamily,
                      ),
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xB9A2A2A7)),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon:
                                  const Icon(Icons.cancel, color: Colors.grey),
                              onPressed: () {
                                searchController.clear();
                                filterResults('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: (value) => filterResults(value),
                  ),
                ),
                if (searchQuery.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      'Searching: $searchQuery',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                        fontFamily: themeProvider.fontFamily,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Filter Row
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: transactionTypes.map((type) {
                bool isSelected = selectedTransactionType == type;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTransactionType = type;
                      filterResults(searchQuery);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          type,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF124682)
                                : Colors.grey[600],
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 15,
                            fontFamily: themeProvider.fontFamily,
                          ),
                        ),
                        const SizedBox(
                            height: 4), // Gap between text and underline
                        Container(
                          height: isSelected ? 2 : 0,
                          width:
                              40, // Adjust as needed or calculate dynamically
                          color: isSelected
                              ? const Color(0xFFF8BD00)
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // Transaction List
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                    child: Text(
                      'No details found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: themeProvider.fontFamily,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final tx = filteredTransactions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 2),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey.shade200,
                                  child: Icon(Icons.person,
                                      color: Colors.grey.shade700),
                                ),
                                const SizedBox(width: 22),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '#ID : ${tx["id"]}',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.028,
                                          fontFamily: themeProvider.fontFamily,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'MSISDN : ${tx["msisdn"]}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.028,
                                          fontFamily: themeProvider.fontFamily,
                                        ),
                                      ),
                                      Text(
                                        'Date/Time : ${tx["time"]}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.028,
                                          fontFamily: themeProvider.fontFamily,
                                        ),
                                      ),
                                      Text(
                                        'Transaction Type : ${tx["transaction_type"]}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.028,
                                          fontFamily: themeProvider.fontFamily,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: tx['status'] == 'Successful'
                                            ? Colors.green
                                            : tx['status'] == 'Pending'
                                                ? Colors.yellow[700]
                                                : Colors.red,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        tx['status'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: themeProvider.fontFamily,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      tx['amount'],
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontFamily: themeProvider.fontFamily,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    },
  );
}

Color? parseHexColor(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) return null;

  final buffer = StringBuffer();
  if (hexColor.length == 7) {
    // Add full opacity (FF) if not specified
    buffer.write('ff');
    buffer.write(hexColor.replaceFirst('#', ''));
  } else if (hexColor.length == 9) {
    // Already includes alpha
    buffer.write(hexColor.replaceFirst('#', ''));
  }

  return Color(int.parse(buffer.toString(), radix: 16));
}

class AnimatedStepProgressBar extends StatefulWidget {
  final List<String> steps;
  final int currentStep; // zero-based index

  const AnimatedStepProgressBar({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  @override
  State<AnimatedStepProgressBar> createState() =>
      _AnimatedStepProgressBarState();
}

class _AnimatedStepProgressBarState extends State<AnimatedStepProgressBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final steps = widget.steps;
    final currentStep = widget.currentStep.clamp(0, steps.length - 1);
    final circleSize = 40.0;
    final lineHeight = 4.0;
    final lineColorActive = Colors.blue;
    final lineColorInactive = Colors.grey.shade300;

    return SizedBox(
      height: 90, // more height to fit labels nicely
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Horizontal connecting line behind circles
          Positioned(
            top: circleSize / 2 - lineHeight / 2,
            left: circleSize / 2,
            right: circleSize / 2,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: List.generate(steps.length - 1, (index) {
                    final isActive = index < currentStep;
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: lineHeight,
                        decoration: BoxDecoration(
                          color: isActive ? lineColorActive : lineColorInactive,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),

          // Circles row
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(steps.length, (index) {
                final isActive = index == currentStep;
                final isCompleted = index < currentStep;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: isActive || isCompleted
                        ? lineColorActive
                        : Colors.white,
                    border: Border.all(
                      color: isActive || isCompleted
                          ? lineColorActive
                          : Colors.grey.shade400,
                      width: 4,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: lineColorActive.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 400),
                      style: TextStyle(
                        color: isActive || isCompleted
                            ? Colors.white
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      child: Text('${index + 1}'),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Labels row
          Positioned(
            top: circleSize + 5, // space below circles
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(steps.length, (index) {
                final isActive = index == currentStep;
                final isCompleted = index < currentStep;

                return SizedBox(
                  width: circleSize + 22, // wider so text fits better
                  child: Text(
                    steps[index],
                    textAlign: TextAlign.center,
                    maxLines: 2, // max two lines for long text
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isActive || isCompleted
                          ? lineColorActive
                          : Colors.grey,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> launchPhone() async {
  final Uri phoneUri = Uri(
    scheme: 'tel',
    path: "1600",
  );
}

double estimateWidgetHeight(Map<String, dynamic> item) {
  switch (item['type']) {
    case 'Label':
      return ((item['fontSize'] ?? 16) as num).toDouble() + 20;
    case 'Button':
      return 60;
    case 'TextField':
      return 70;
    case 'Dropdown':
      return 60;
    case 'contactButton':
      return 80;
    default:
      return 30; // fallback for unknown items
  }
}

Widget buildTitleDivider(
    String title, ThemeProvider themeProvider, double screenWidth) {
  return SizedBox(
    width: screenWidth * 0.9,
    child: Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFF1C3144))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            title,
            style: TextStyle(
              color: const Color(0xFF1C3144),
              fontWeight: FontWeight.bold,
              fontFamily: themeProvider.fontFamily,
              fontSize: 17,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFF1C3144))),
      ],
    ),
  );
}

class CircularBorder extends StatelessWidget {
  final double percentage;
  final Color color1;
  final Color color2;
  final double border;
  final Widget child;

  const CircularBorder({
    super.key,
    required this.percentage,
    required this.color1,
    required this.color2,
    required this.border,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: border,
            backgroundColor: color1,
            valueColor: AlwaysStoppedAnimation<Color>(color2),
          ),
        ),
        child,
      ],
    );
  }
}

int hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  return int.parse(hex, radix: 16);
}
