import 'pageConfig_provider.dart';
import 'variableDeclaration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/themeProvider.dart';
import 'package:mybtapp_testapp_testapp_test/main.dart';




// Define the key at the top of your class
final GlobalKey helpIconKey = GlobalKey();

class PageTemplate extends StatefulWidget {
  final bool? scrollNeeded;
  final bool? resizeToAvoidBottomInset;
  final bool accountNeeded;
  final String title;
  final Widget content;
  final VoidCallback? onBack;
  final bool bottomNavigationBarNeeded;

  const PageTemplate(
      {super.key,
      required this.title,
      required this.content,
      this.accountNeeded = true,
      this.scrollNeeded = true,
      this.resizeToAvoidBottomInset = false,
      this.onBack,
      required this.bottomNavigationBarNeeded});

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<PageConfigProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.25;
    final contentTopOffset = headerHeight * 0.5;

    final cardBackground =
        config.getColor("cardBackground", fallback: const Color(0xFFF6F9FE));
    final iconColor = config.getColor("iconColor", fallback: Colors.white);

    return Scaffold(
      resizeToAvoidBottomInset: (widget.resizeToAvoidBottomInset),
      // bottomNavigationBar: widget.bottomNavigationBarNeeded
          // ? CustomBottomNavigation(
          //     context: context,
          //     current: widget.title,
          //   )
          // : null,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: headerHeight,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'lib/assets/appBarImage.png',
                      fit: BoxFit.fill,
                    ),
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon:
                                      Icon(Icons.arrow_back, color: iconColor),
                                  onPressed: widget.onBack ??
                                      () => Navigator.pop(context),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      widget.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: themeProvider.fontFamily,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Opacity(
                                      opacity: widget.accountNeeded
                                          ? 1.0
                                          : 0.0, // Fully visible or fully transparent
                                      child: IconButton(
                                        key: helpIconKey,
                                        icon: const Icon(
                                          Icons.help_outlined,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          if (widget.accountNeeded) {
                                            logger.i("Help icon pressed");

                                            final RenderBox iconRenderBox =
                                                helpIconKey.currentContext!
                                                        .findRenderObject()!
                                                    as RenderBox;
                                            final RenderBox overlay =
                                                Overlay.of(context)
                                                        .context
                                                        .findRenderObject()!
                                                    as RenderBox;

                                            final Offset position =
                                                iconRenderBox.localToGlobal(
                                                    Offset.zero,
                                                    ancestor: overlay);
                                            final Size size =
                                                iconRenderBox.size;

                                            final jsonInput = {
                                              // widget.title: getHelpDataForTitle(
                                              //     widget.title),
                                            };

                                            final title = jsonInput.keys.first;
                                            final points =
                                                extractPointsFromJson(
                                                    jsonInput[title]!);

                                            showMenu(
                                              context: context,
                                              position: RelativeRect.fromLTRB(
                                                position.dx,
                                                position.dy -
                                                    (points.length * 31) -
                                                    22, // Appears above the icon
                                                overlay.size.width -
                                                    position.dx -
                                                    size.width,
                                                0,
                                              ),
                                              color: Colors.transparent,
                                              items: [
                                                PopupMenuItem(
                                                  enabled: false,
                                                  padding: EdgeInsets.zero,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                    constraints: BoxConstraints(
                                                      maxHeight:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.5,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          buildHeader(
                                                              "${widget.title} info"),
                                                          ...points
                                                              .map((point) {
                                                            return InkWell(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                logger.i(
                                                                    "Tapped: $point");
                                                              },
                                                              child:
                                                                  buildTextChild(
                                                                      point),
                                                            );
                                                          }).toList(),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: contentTopOffset,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          elevation: 5,
                          shadowColor: Colors.black,
                          color: cardBackground,
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: widget.scrollNeeded == true
                                ? SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: widget.content,
                                  )
                                : widget.content,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildHeader(String title) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey), // Border around the header
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      color: const Color.fromRGBO(116, 176, 102, 1),
    ),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Space between text and icon
      children: [
        const SizedBox(width: 10),
        Text(
          title, // Use the dynamic title
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconTheme(
          data: const IconThemeData(
            color: Colors.white, // Force white color
          ),
          child: GestureDetector(
            onTap: () => Navigator.of(navigatorKey.currentContext!).pop(),
            child: const Icon(
              Icons.help,
              size: 35,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildTextChild(String choice) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    child: Text(
      choice,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
    ),
  );
}

List<String> extractPointsFromJson(Map<String, String> json) {
  return json.values.toList();
}
