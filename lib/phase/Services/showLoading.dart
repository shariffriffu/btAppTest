import 'package:mybtapp_testapp_testapp_test/main.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/variableDeclaration.dart';

showLoading(BuildContext context) {
  logger.i("loading...");
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return PopScope(
        canPop: false, // Prevent back button press
        child: Dialog(
          backgroundColor: Colors.transparent, // Make the dialog transparent
          child: Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(0, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFe8e8e8)), // Set color to dark blue
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

void successDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white38,
        child: SimpleDialog(
          alignment: Alignment.center,
          insetPadding: const EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          children: [
            Center(
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Allows content to fit dynamically
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 60,
                        color: Color.fromRGBO(95, 187, 73, 1),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        child: Text(
                          SUCCESSHEADING,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(95, 187, 73, 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                        softWrap: true,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 185,
                        height: 35,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Color.fromRGBO(28, 49, 68, 1),
                              shadowColor: Color.fromRGBO(0, 0, 0, 1)),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

showPopupVC(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white38,
        child: AlertDialog(
          title: Text("Info"),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

showPopup(BuildContext context, String message) {
  BuildContext context = navigatorKey.currentContext!;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white38,
        child: Center(
          child: SimpleDialog(
            insetPadding: const EdgeInsets.all(10),
            backgroundColor: Colors.transparent,
            title: Stack(
              children: [
                Center(
                  child: Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: Color.fromRGBO(232, 232, 232, 1),
                    ),
                    child: Column(
                      children: [
                        Container(
                            child: Center(
                                child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Material(
                              elevation: 10,
                              shadowColor: Color.fromRGBO(0, 0, 0, 0.1),
                              color: Colors.transparent,
                              child: Icon(
                                Icons.cancel_rounded,
                                size: 60,
                                color: Color(0xFFF37B26),
                                shadows: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.15),
                                  )
                                ],
                              ),
                            ),
                            const Text(
                              "Failed!",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFF37B26)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 120,
                              child: Column(
                                children: [
                                  Flexible(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      message,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ))),
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 3.8,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF37B26),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        iconSize: 100,
                        color: const Color(0xFFF37B26),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Color.fromRGBO(232, 232, 232, 1),
                          size: 40,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      );
    },
  );
}

showPopupUnblock(BuildContext context, String message) {
  BuildContext context = navigatorKey.currentContext!;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white38,
        child: Center(
          child: SimpleDialog(
            insetPadding: const EdgeInsets.all(10),
            backgroundColor: Colors.transparent,
            title: Stack(
              children: [
                Center(
                  child: Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: Color.fromRGBO(232, 232, 232, 1),
                    ),
                    child: Column(
                      children: [
                        Container(
                            child: Center(
                                child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Material(
                              elevation: 10,
                              shadowColor: Color.fromRGBO(0, 0, 0, 0.1),
                              color: Colors.transparent,
                              child: Icon(
                                Icons.cancel_rounded,
                                size: 60,
                                color: Color(0xFFF37B26),
                                shadows: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.15),
                                  )
                                ],
                              ),
                            ),
                            const Text(
                              "Failed!",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFF37B26)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 120,
                              child: Column(
                                children: [
                                  Flexible(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      message,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 20,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        backgroundColor:
                                            Color.fromRGBO(28, 49, 68, 1),
                                        shadowColor:
                                            Color.fromRGBO(0, 0, 0, 1)),
                                    child: const Text(
                                      'Unblock',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    onPressed: () async {
                                      logger.w("unblock");
                                      // await navigatorKey.currentState!.push(
                                      //   MaterialPageRoute(
                                      //       builder: (BuildContext context) =>
                                      //          const PinUnblockPage()),
                                      // );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))),
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 3.8,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF37B26),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        iconSize: 100,
                        color: const Color(0xFFF37B26),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Color.fromRGBO(232, 232, 232, 1),
                          size: 40,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      );
    },
  );
}

showInfoPopup(BuildContext context, String message) {
  BuildContext context = navigatorKey.currentContext!;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white38,
        child: Center(
          child: SimpleDialog(
            insetPadding: const EdgeInsets.all(10),
            backgroundColor: Colors.transparent,
            title: Stack(
              children: [
                Center(
                  child: Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width - 10,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: Color.fromRGBO(232, 232, 232, 1),
                    ),
                    child: Column(
                      children: [
                        Container(
                            child: Center(
                                child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Material(
                              elevation: 10,
                              shadowColor: Color.fromRGBO(0, 0, 0, 0.1),
                              color: Colors.transparent,
                              child: Icon(
                                Icons.info_outline_rounded,
                                size: 60,
                                color: Color.fromARGB(255, 165, 158, 153),
                                shadows: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.15),
                                  )
                                ],
                              ),
                            ),
                            const Text(
                              "Info",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1C3144)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 120,
                              child: Column(
                                children: [
                                  Flexible(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      message,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ))),
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 3.8,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF37B26),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        iconSize: 100,
                        color: const Color(0xFFF37B26),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Color.fromRGBO(232, 232, 232, 1),
                          size: 40,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      );
    },
  );
}
