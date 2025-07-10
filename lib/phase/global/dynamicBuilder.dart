import 'dart:math';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'variableDeclaration.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../Provider/themeProvider.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:mybtapp_testapp_testapp_test/phase/global/global.dart';

Widget buildFromLayout<T>(
  List layoutJson,
  BuildContext context, {
  required Map<String, dynamic> controllers,
  Map<String, VoidCallback>? actionHandlers,
  required Map<String, dynamic> errorTexts,
  Map<String, dynamic>? visibilityStates,
  T? provider,
  Map<String, VoidCallback>? toggleVisibilityFns,
  String? pageName,
  bool? readOnly,
  required Map<String, FocusNode> focusNodes,
}) {
  final themeProvider = Provider.of<ThemeProvider>(context);

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: layoutJson.map<Widget>((item) {
      switch (item['type']) {
        case 'SizedBox':
          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.maybeOf(context)?.size.width ?? 360.0;

          final heightPercent = item['heightPercent']?.toDouble();
          final widthPercent = item['widthPercent']?.toDouble();

          final height = heightPercent != null
              ? screenHeight * (heightPercent / 1000)
              : item['height']?.toDouble() ?? 0;
          final width = widthPercent != null
              ? screenWidth * (widthPercent / 100)
              : item['width']?.toDouble();

          return SizedBox(
            height: height,
            width: width,
          );

        case 'PopUpMenu':
          final color = parseColor(item['color']);
          return Row(
            mainAxisAlignment: item['alignment'] == 'end'
                ? MainAxisAlignment.end
                : item['alignment'] == 'center'
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
            children: [
              PopupMenuHelper.buildPopupMenu(context, color, themeProvider)
            ],
          );

        case 'Image':
          if (item['asset'] != null) {
            return Image.asset(
              item['asset'],
              height: item['height']?.toDouble(),
              width: item['width']?.toDouble(),
              fit: BoxFit.contain,
            );
          } else if (item['network'] != null) {
            return Image.network(
              item['network'],
              height: item['height']?.toDouble(),
              width: item['width']?.toDouble(),
              fit: BoxFit.contain,
            );
          } else {
            return const SizedBox(); // fallback if neither is provided
          }

        case 'GestureDetectorImage':
          // Check biometric visibility condition
          if (item['biometric'] == true &&
              registry.getValue('biometric') != true) {
            return const SizedBox(); // Hide the image if biometric not enabled
          }

          if (item['asset'] != null) {
            return GestureDetector(
              onTap: () {
                final actionKey = item['onTapAction'];
                logger.i("actionKey: $actionKey");
                if (actionHandlers != null && actionKey != null) {
                  actionHandlers[actionKey]?.call();
                }
              },
              child: Image.asset(
                item['asset'],
                height: item['height']?.toDouble(),
                width: item['width']?.toDouble(),
                fit: BoxFit.contain,
              ),
            );
          } else if (item['network'] != null) {
            return GestureDetector(
              onTap: () {
                final actionKey = item['onTapAction'];
                logger.i("actionKey: $actionKey");
                if (actionHandlers != null && actionKey != null) {
                  actionHandlers[actionKey]?.call();
                }
              },
              child: Image.network(
                item['network'],
                height: item['height']?.toDouble(),
                width: item['width']?.toDouble(),
                fit: BoxFit.contain,
              ),
            );
          } else {
            return const SizedBox(); // fallback if neither is provided
          }

        case 'TextField':
          final fieldId = item['id'];
          final textFieldProperty = item['textFieldPropertyType'];
          final properties = Map<String, dynamic>.from(
            themeProvider.textProperties[textFieldProperty] ?? {},
          );

          return CustomTextField(
            focusNode: focusNodes[fieldId],
            readOnly: readOnly ?? false,
            properties: properties,
            controller: controllers[fieldId] ??= TextEditingController(),
            propertyType: item['textFieldPropertyType'],
            hintText: item['hintText'] ?? '',
            label: item['label'] ?? fieldId,
            keyboardType: item['keyboardType'] == 'phone'
                ? TextInputType.phone
                : item['keyboardType'] == 'email'
                    ? TextInputType.emailAddress
                    : TextInputType.text,
            maxLength: item['maxLength'] ?? 50,
            isPassword: item['isPassword'] == true,
            obscureText: visibilityStates?[fieldId] ?? false,
            onVisibilityToggle: toggleVisibilityFns?[fieldId],
            hasSuffixButton: item['hasSuffixButton'] == true,
            suffixIcon: parseIcon(item['suffixIcon']),
            onSuffixPressed: () {
              logger.w('Suffix pressed for $fieldId');
            },
            errorText: errorTexts[fieldId],
          );

        case 'Button':
          final buttonType = item['buttonStyleType'];
          final iconNeeded = item['IconNeeded'] ?? false;
          final label = item['label'] ?? 'Button';
          final actionKey = item['onPressed'];
          VoidCallback? onPressed;
          if (actionHandlers != null && actionKey != null) {
            onPressed = actionHandlers[actionKey];
            if (onPressed == null) {
              logger.e("No handler found for actionKey: $actionKey");
            }
          }

          final properties = themeProvider.buttonProperties[buttonType] ?? {};
          logger.i("properties: ${themeProvider.buttonProperties[buttonType] }");
          Fluttertoast.showToast(
            msg: "properties: ${themeProvider.buttonProperties[buttonType]}",
            toastLength: Toast.LENGTH_SHORT,
          );
          final textStyle = TextStyle(
            color: parseColor(properties["fontColor"] ?? "#FFFFFF"),
            fontSize: (properties["fontSize"] ?? 14).toDouble(),
            fontWeight: parseFontWeight(properties["fontWeight"] ?? "normal"),
            fontFamily: themeProvider.fontFamily,
            letterSpacing: (properties['letterSpacing'] ?? 1.0).toDouble(),
          );
          final screenWidth = MediaQuery.maybeOf(context)?.size.width ?? 360.0;

          final horizontalPadding =
              (properties['padding']?['horizontal'] ?? 40).toDouble();
          final verticalPadding =
              (properties['padding']?['vertical'] ?? 15).toDouble();
          final padding = EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          );

          final buttonWidth = screenWidth - (horizontalPadding * 2);

          final buttonChild = FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (iconNeeded)
                  Icon(
                    parseIcon(item['icon']),
                  ),
                SizedBox(width: (item['spaceBetween'] ?? 30).toDouble()),
                Text(
                  label,
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );

          final shape = switch (properties['shape']) {
            'stadium' => const StadiumBorder(),
            'rounded' =>
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            _ => const StadiumBorder(),
          };

          switch (properties['type']) {
            case 'outlined':
              return Padding(
                padding: padding,
                child: SizedBox(
                  width: buttonWidth,
                  child: OutlinedButton(
                    onPressed: onPressed,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: shape,
                      side: BorderSide(
                        color:
                            parseColor(properties['borderColor'] ?? "#124682"),
                      ),
                    ),
                    child: buttonChild,
                  ),
                ),
              );

            case 'slide':
              return Padding(
                padding: padding,
                child: SlideAction(
                  key: globalSlideActionKey,
                  text: label,
                  textStyle: textStyle,
                  outerColor:
                      parseColor(properties['backgroundColor'] ?? "#C8C8D2"),
                  innerColor:
                      parseColor(properties['sliderColor'] ?? "#124682"),
                  elevation: 4,
                  sliderButtonIcon: const Icon(Icons.arrow_forward_outlined,
                      color: Colors.white),
                  onSubmit: () async {
                    logger.i("Slide action submitted");
                    onPressed!();
                    globalSlideActionKey.currentState?.reset();
                  },
                ),
              );

            case 'text':
              return Padding(
                padding: padding,
                child: SizedBox(
                  width: buttonWidth,
                  child: TextButton(
                    onPressed: onPressed,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: parseColor(
                          properties['foregroundColor'] ?? "#124682"),
                      shape: shape,
                    ),
                    child: buttonChild,
                  ),
                ),
              );

            case 'elevated':
            default:
              return Padding(
                padding: padding,
                child: SizedBox(
                  width: buttonWidth,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: shape,
                      backgroundColor: parseColor(
                          properties['backgroundColor'] ?? "#124682"),
                      foregroundColor: parseColor(
                          properties['foregroundColor'] ?? "#FFFFFF"),
                    ),
                    child: buttonChild,
                  ),
                ),
              );
          }

        case 'GestureDetectorText':
          final textFieldProperty = item['textFieldPropertyType'];
          final properties = Map<String, dynamic>.from(
            themeProvider.textProperties[textFieldProperty] ?? {},
          );
          final textStyle = TextStyle(
            color: parseColor(properties["fontColor"] ?? "#000000"),
            fontSize: (properties["fontSize"] ?? 14).toDouble(),
            fontWeight: parseFontWeight(properties["fontWeight"] ?? "normal"),
            fontFamily: themeProvider.fontFamily,
            letterSpacing: (properties['letterSpacing'] ?? 1.0).toDouble(),
          );
          return Padding(
            padding: const EdgeInsets.only(right: 22.0),
            child: Row(
              mainAxisAlignment: item['alignment'] == 'end'
                  ? MainAxisAlignment.end
                  : item['alignment'] == 'center'
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    final actionKey = item['onTapAction'];
                    logger.i("actionKey: $actionKey");
                    if (actionHandlers != null && actionKey != null) {
                      actionHandlers[actionKey]?.call();
                    }
                  },
                  child: Text(item['text'] ?? '', style: textStyle),
                ),
              ],
            ),
          );

        case 'RowButton':
          final childrenData = item['buttons'] as List? ?? [];

          final buttons = childrenData.map<Widget>((buttonConfig) {
            final buttonType = buttonConfig['buttonStyleType'];
            final label = buttonConfig['label'] ?? 'Button';
            final actionKey = buttonConfig['onTapAction'];

            VoidCallback? onPressed;
            if (actionHandlers != null && actionKey != null) {
              onPressed = actionHandlers[actionKey];
            }

            final properties = themeProvider.buttonProperties[buttonType] ?? {};

            final textStyle = TextStyle(
              color: parseColor(properties["fontColor"] ?? "#000000"),
              fontSize: (properties["fontSize"] ?? 14).toDouble(),
              fontWeight: parseFontWeight(properties["fontWeight"] ?? "normal"),
              fontFamily: themeProvider.fontFamily,
              letterSpacing: (properties['letterSpacing'] ?? 1.0).toDouble(),
            );

            final padding = properties.containsKey('padding')
                ? EdgeInsets.symmetric(
                    horizontal:
                        (properties['padding']['horizontal'] ?? 40).toDouble(),
                    vertical:
                        (properties['padding']['vertical'] ?? 15).toDouble(),
                  )
                : const EdgeInsets.symmetric(horizontal: 40, vertical: 15);

            final shape = switch (properties['shape']) {
              'stadium' => const StadiumBorder(),
              'rounded' =>
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              _ => const StadiumBorder(),
            };

            switch (properties['type']) {
              case 'outlined':
                return OutlinedButton(
                  onPressed: onPressed,
                  style: OutlinedButton.styleFrom(
                    padding: padding,
                    shape: shape,
                    side: BorderSide(
                      color: parseColor(properties['borderColor'] ?? "#124682"),
                    ),
                  ),
                  child: Text(label, style: textStyle),
                );
              case 'text':
                return TextButton(
                  onPressed: onPressed,
                  style: TextButton.styleFrom(
                    padding: padding,
                    foregroundColor:
                        parseColor(properties['foregroundColor'] ?? "#124682"),
                  ),
                  child: Text(label, style: textStyle),
                );
              case 'elevated':
              default:
                return ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    padding: padding,
                    shape: shape,
                    backgroundColor:
                        parseColor(properties['backgroundColor'] ?? "#124682"),
                    foregroundColor:
                        parseColor(properties['foregroundColor'] ?? "#FFFFFF"),
                  ),
                  child: Text(label, style: textStyle),
                );
            }
          }).toList();

          final alignment = item['mainAxisAlignment'] ?? 'spaceBetween';

          final mainAxisAlignment = switch (alignment) {
            'center' => MainAxisAlignment.center,
            'start' => MainAxisAlignment.start,
            'end' => MainAxisAlignment.end,
            'spaceAround' => MainAxisAlignment.spaceAround,
            'spaceEvenly' => MainAxisAlignment.spaceEvenly,
            _ => MainAxisAlignment.spaceBetween,
          };

          return Row(
            mainAxisAlignment: mainAxisAlignment,
            children: buttons,
          );

        case 'IconButton':
          bool isNetworkImage(String? url) {
            if (url == null) return false;
            return url.startsWith('http://') || url.startsWith('https://');
          }

          return Row(
            mainAxisAlignment: item['alignment'] == 'end'
                ? MainAxisAlignment.end
                : item['alignment'] == 'center'
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
            children: [
              IconButton(
                icon: isNetworkImage(item['icon'])
                    ? Image.network(item['icon'], height: 60)
                    : Image.asset(item['icon'] ?? 'assets/biometric.png',
                        height: 60),
                onPressed: () => logger.i('Face Scanner Authentication'),
              ),
            ],
          );

        case 'RichText':
          return Text.rich(
            TextSpan(
              text: item['textPrefix'] ?? 'You Don’t have an account? ',
              style: TextStyle(
                color: parseColor(item['fontColor']),
                fontSize: (item['fontSize'] ?? 14).toDouble(),
                fontWeight: parseFontWeight(item['fontWeight']),
                fontFamily: themeProvider.fontFamily,
              ),
              children: [
                TextSpan(
                    text: item['textAction'] ?? 'Register',
                    style: TextStyle(
                      color: parseColor(item['OnPressfontColor']),
                      fontSize: (item['OnPressfontSize'] ?? 16).toDouble(),
                      fontWeight: parseFontWeight(item['OnPressfontWeight']),
                      fontFamily: themeProvider.fontFamily,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        final actionKey = item['onTapAction'];
                        logger.i("actionKey: $actionKey");
                        if (actionHandlers != null && actionKey != null) {
                          actionHandlers[actionKey]?.call();
                        }
                      }),
              ],
            ),
          );

        case 'Label':
          return Padding(
            padding: EdgeInsets.only(
              left: (item['padding']['left'] ?? 0).toDouble(),
              right: (item['padding']['right'] ?? 0).toDouble(),
              top: (item['padding']['top'] ?? 0).toDouble(),
              bottom: (item['padding']['bottom'] ?? 0).toDouble(),
            ),
            child: Row(
              mainAxisAlignment: item['alignment'] == 'end'
                  ? MainAxisAlignment.end
                  : item['alignment'] == 'center'
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    item['text'] ?? '',
                    softWrap: true,
                    style: TextStyle(
                      color: parseColor(item['fontColor'] ?? '000000'),
                      fontWeight:
                          parseFontWeight(item['fontWeight'] ?? 'normal'),
                      fontFamily: themeProvider.fontFamily,
                      fontSize: (item['fontSize'] ?? 16).toDouble(),
                    ),
                  ),
                ),
              ],
            ),
          );

        case 'CheckBox':
          {
            final fieldId = item['id'];
            final label = item['label'] ?? '';
            final padding = (item['padding'] ?? 0).toDouble();
            final labelColorHex = item['labelColor'] ?? '#000000';
            final fontWeight = parseFontWeight(item['fontWeight']);
            final labelColor = parseHexColor(labelColorHex);

            final notifier =
                controllers[fieldId] ??= ValueNotifier<bool>(false);

            return Padding(
              padding: EdgeInsets.only(left: padding),
              child: Row(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: notifier,
                    builder: (context, value, _) {
                      return Checkbox(
                        value: value,
                        activeColor: const Color(0xFFF37B26),
                        checkColor: Colors.white,
                        onChanged: (bool? newValue) {
                          logger.i("Checkbox [$fieldId] pressed: $newValue");
                          notifier.value = newValue ?? false;
                        },
                      );
                    },
                  ),
                  Expanded(
                    // ✅ Expanded outside GestureDetector
                    child: GestureDetector(
                      onTap: () {
                        final actionKey = item['onTapAction'];
                        logger.i("actionKey: $actionKey");
                        if (actionHandlers != null && actionKey != null) {
                          actionHandlers[actionKey]?.call();
                        }
                      },
                      child: Text(
                        label,
                        style: TextStyle(
                          color: labelColor,
                          fontFamily: themeProvider.fontFamily,
                          fontWeight: fontWeight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

        case 'IconInRow':
          final screenWidth = MediaQuery.maybeOf(context)?.size.width ?? 360.0;
          final itemSize = screenWidth / 3.5;

          final iconInRowItems = (item['items'] ?? []) as List;

          bool isItemVisible(Map e) {
            final isConditional = e['conditional'] == true;
            final id = e['id'];

            if (!isConditional) return true;

            if (id == "kycstatus") {
              logger.i("kycstatus : ${registry.getValue("kycstatus")}");
              return registry.getValue("isPrepaid") == true;
            } else if (id == "linkEloadstatus") {
              logger.i(
                  "linkEloadstatus : ${registry.getValue("linkEloadstatus")}");

              return registry.getValue("linkEloadstatus") == false;
            }

            return false;
          }

          final typeAItems = iconInRowItems.where((e) {
            return (e['IconInRowStyleType'] ?? 'typeA') == 'typeA' &&
                isItemVisible(e);
          }).toList();

          final typeBItems = iconInRowItems.where((e) {
            return (e['IconInRowStyleType'] ?? 'typeA') == 'typeB' &&
                isItemVisible(e);
          }).toList();

          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Card(
                color: const Color(0xFFDAEFD5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (typeAItems.isNotEmpty)
                      ...typeAItems.map((it) {
                        final icon = parseIcon(it['icon']);
                        final properties =
                            themeProvider.IconInRowProperties['typeA'] ?? {};
                        final label = it['name'];
                        final textStyle = TextStyle(
                          color:
                              parseColor(properties["fontColor"] ?? "#000000"),
                          fontSize: (properties["fontSize"] ?? 14).toDouble(),
                          fontWeight: parseFontWeight(
                              properties["fontWeight"] ?? "normal"),
                          fontFamily: themeProvider.fontFamily,
                          letterSpacing:
                              (properties['letterSpacing'] ?? 1.0).toDouble(),
                        );
                        final double widthOfSizedBox =
                            (item['sizeSpace'] ?? 30).toDouble();

                        return InkWell(
                          onTap: () => navigateToService(it['name'], context),
                          child: Card(
                            color: const Color(0xFFDAEFD5),
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        icon,
                                        color:
                                            parseColor(properties['iconColor']),
                                        size: properties['iconSize']
                                                ?.toDouble() ??
                                            24.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: widthOfSizedBox,
                                    ),
                                    Text(label, style: textStyle),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    if (typeBItems.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: typeBItems.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 4,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            final it = typeBItems[index];
                            final icon = parseIcon(it['icon']);
                            final label = it['name'];
                            final isHighlighted = it['highlight'] == true;

                            return InkWell(
                              onTap: () =>
                                  navigateToService(it['name'], context),
                              child: Container(
                                width: itemSize,
                                height: itemSize,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isHighlighted
                                        ? Colors.amber
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      icon,
                                      size: itemSize * 0.3,
                                      color: const Color(0xFF124682),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      label,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: itemSize * 0.12,
                                        fontFamily: themeProvider.fontFamily,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          });

        case 'RichLabel':
          final padding = item['padding'] ?? {'left': 0, 'right': 0};
          final alignmentString = item['alignment'] ?? 'center';
          Alignment alignment;

          switch (alignmentString) {
            case 'centerLeft':
              alignment = Alignment.centerLeft;
              break;
            case 'centerRight':
              alignment = Alignment.centerRight;
              break;
            case 'topLeft':
              alignment = Alignment.topLeft;
              break;
            case 'topRight':
              alignment = Alignment.topRight;
              break;
            default:
              alignment = Alignment.center;
          }

          final texts = item['texts'] as List<dynamic>? ?? [];

          return Padding(
            padding: EdgeInsets.only(
              left: (padding['left'] ?? 0).toDouble(),
              right: (padding['right'] ?? 0).toDouble(),
            ),
            child: Align(
              alignment: alignment,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: texts.map((textItem) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      textItem['text'] ?? '',
                      style: TextStyle(
                        fontSize: (textItem['fontSize'] ?? 16).toDouble(),
                        color: Color(int.parse(
                            (textItem['fontColor'] ?? '#000000')
                                .replaceFirst('#', '0xFF'))),
                        fontFamily: textItem['fontFamily'] ?? 'Gilroy-Regular',
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );

        case 'OTPField':
          final length = item['length'] ?? 6;
          final fieldWidth = (item['fieldWidth'] ?? 35).toDouble();
          final fieldMargin = (item['fieldMargin'] ?? 5).toDouble();
          final fieldPadding = item['fieldPadding'] ?? {'left': 0, 'right': 0};
          final inputFontSize = (item['inputFontSize'] ?? 24).toDouble();
          final inputBackground = item['inputBackground'] ?? "#FFFFFF";
          final borderRadius = (item['borderRadius'] ?? 8.0).toDouble();
          (item['borderWidth'] ?? 2.0).toDouble();

          List<TextEditingController> controllers =
              List.generate(length, (index) => TextEditingController());
          List<FocusNode> focusNodes =
              List.generate(length, (index) => FocusNode());

          return Padding(
            padding: EdgeInsets.only(
              left: (fieldPadding['left'] ?? 0).toDouble(),
              right: (fieldPadding['right'] ?? 0).toDouble(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(length, (index) {
                return Container(
                  width: fieldWidth,
                  margin: EdgeInsets.symmetric(horizontal: fieldMargin),
                  child: TextField(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: inputFontSize),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Color(
                        int.parse(inputBackground.replaceFirst("#", "0xFF")),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < length - 1) {
                        FocusScope.of(focusNodes[index].context!)
                            .requestFocus(focusNodes[index + 1]);
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(focusNodes[index].context!)
                            .requestFocus(focusNodes[index - 1]);
                      }
                    },
                  ),
                );
              }),
            ),
          );

        case 'ButtonGroup':
          final padding = item['padding'] ?? {'horizontal': 0, 'vertical': 0};
          final buttons = item['buttons'] as List<dynamic>? ?? [];

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (padding['horizontal'] ?? 0).toDouble(),
              vertical: (padding['vertical'] ?? 0).toDouble(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: buttons.map((buttonData) {
                final buttonId = buttonData['id'];
                return ElevatedButton(
                  onPressed: actionHandlers?[buttonId],
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(
                      int.parse((buttonData['backgroundColor'] ?? "#0175C2")
                          .replaceFirst("#", "0xFF")),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    buttonData['text'] ?? '',
                    style: TextStyle(
                      fontSize: (buttonData['fontSize'] ?? 16).toDouble(),
                      color: Color(
                        int.parse((buttonData['textColor'] ?? "#FFFFFF")
                            .replaceFirst("#", "0xFF")),
                      ),
                      fontWeight:
                          (buttonData['fontWeight'] ?? 'normal') == 'bold'
                              ? FontWeight.bold
                              : FontWeight.normal,
                      fontFamily: "Gilroy-Medium",
                    ),
                  ),
                );
              }).toList(),
            ),
          );

        case 'Tab':
          final tabChildren = item!['childrens'] as List<dynamic>;
          final confirmationLabel = item['confirmationLabel'];
          logger.e("confirmationLabel: $confirmationLabel");

          var height = getHeightForPage(context, pageName ?? '');

          return Column(
            children: [
              buildTabBar(tabChildren, context),
              SizedBox(
                height: height,
                child: TabBarView(
                  children: tabChildren.map((tabConfig) {
                    return buildTabContent(
                        tabConfig, provider, context, confirmationLabel);
                  }).toList(),
                ),
              ),
            ],
          );

        case 'Trio':
          final hasToggle = item['toggle'] != null;
          final hasIcon = item['icon'] != null;
          final label = item['label']?['text'] ?? '';
          final toggleValue = provider != null
              ? (provider as dynamic).getToggle(item['id']) ?? false
              : item['toggle']?['value'] ?? false;

          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (hasIcon)
                  Icon(
                    Icons.fingerprint_outlined,
                    color: Colors.grey[700],
                  ),
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                if (hasToggle)
                  Switch(
                    value: toggleValue,
                    onChanged: (val) {
                      logger.i("toggle: $provider");
                      if (provider != null) {
                        (provider as dynamic).setToggle(item['id'], val);
                      }

                      final enableKey = 'enable${item['id']}';
                      final disableKey = 'disable${item['id']}';

                      if (actionHandlers != null) {
                        if (val && actionHandlers.containsKey(enableKey)) {
                          actionHandlers[enableKey]!();
                        } else if (!val &&
                            actionHandlers.containsKey(disableKey)) {
                          actionHandlers[disableKey]!();
                        }
                      }
                    },
                  ),
              ],
            ),
          );

        case 'LabeledInput':
          final fieldId = item['id'];
          logger.i("fieldId: $fieldId");
          final label = item['label'] ?? '';
          final keyboardType = item['keyboardType'] == 'number'
              ? TextInputType.number
              : TextInputType.text;
          final maxLength = item['maxLength'] ?? 5;
          final textFieldProperty = item['textFieldPropertyType'];
          final properties =
              themeProvider.textProperties[textFieldProperty] ?? {};
          final textStyle = TextStyle(
            color: parseColor(properties["fontColor"] ?? "#000000"),
            fontSize: (properties["fontSize"] ?? 14).toDouble(),
            fontWeight: parseFontWeight(properties["fontWeight"] ?? "normal"),
            fontFamily: themeProvider.fontFamily,
            letterSpacing: (properties['letterSpacing'] ?? 1.0).toDouble(),
          );
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 14),
              Text(
                label,
                style: textStyle,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 70,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    readOnly: true,
                    controller: controllers[fieldId] ??=
                        TextEditingController(),
                    keyboardType: keyboardType,
                    maxLength: maxLength,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      counterText: '',
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ],
          );
        case 'ProgressBar':
          final List<String> steps = List<String>.from(item['steps'] ?? []);
          final int currentStep = item['currentStep'] ?? 1;
          return AnimatedStepProgressBar(
            steps: steps,
            currentStep: currentStep,
          );

        case 'Divider':
          return Padding(
            padding: EdgeInsets.only(
              left: (item['padding']['left'] ?? 0).toDouble(),
              right: (item['padding']['right'] ?? 0).toDouble(),
              top: (item['padding']['top'] ?? 0).toDouble(),
              bottom: (item['padding']['bottom'] ?? 0).toDouble(),
            ),
            child: Divider(
              thickness: (item['thickness'] as num?)?.toDouble() ?? 1.0,
              color: parseHexColor(item['color']),
              height: (item['height'] as num?)?.toDouble() ?? 16.0,
              indent: (item['indent'] as num?)?.toDouble() ?? 0.0,
              endIndent: (item['endIndent'] as num?)?.toDouble() ?? 0.0,
            ),
          );

        case 'Dropdown':
          {
            final providerKey = item['providerKey']?.toString();
            logger.w("providerKey: $providerKey");

            final boosterTypeListRaw =
                getTransactionsByKey(provider, providerKey!);
            // Defensive check in case getTransactionsByKey returns null
            final boosterTypeList =
                // ignore: unnecessary_type_check
                (boosterTypeListRaw is List) ? boosterTypeListRaw : [];

            logger.w("boosterTypeList: $boosterTypeList");

            List<String> items =
                boosterTypeList.map((e) => e['label'].toString()).toList();

            final currentValue = item['value']?.toString();
            String? selectedValue =
                (currentValue != null && items.contains(currentValue))
                    ? currentValue
                    : null;

            final textFieldProperty = item['textFieldPropertyType'];
            final properties =
                themeProvider.textProperties[textFieldProperty] ?? {};

            final label = item['label']?.toString() ?? '';
            final padding = (properties['padding'] ?? 16).toDouble();
            final fontSize = (properties['fontSize'] ?? 14).toDouble();
            final fontWeight =
                parseFontWeight(properties['fontWeight'] ?? 'normal');
            final fontColor = parseColor(properties['fontColor'] ?? "#000000");
            final backgroundColor =
                parseColor(properties['backgroundColor'] ?? "#F5F5F5");
            final borderRadius = (properties['borderRadius'] ?? 12).toDouble();
            final errorText = item['errorText'];

            // Declare these OUTSIDE the builder so state persists across rebuilds
            List<String> secondItems = [];
            String? secondSelectedValue;

            return StatefulBuilder(
              builder: (context, setState) {
                // Handle second dropdown items safely
                if (selectedValue != null) {
                  final secondListRaw =
                      getTransactionsByKey(provider, selectedValue!);
                  final secondList =
                      // ignore: unnecessary_type_check
                      (secondListRaw is List) ? secondListRaw : [];

                  secondItems =
                      secondList.map((e) => e['label'].toString()).toList();

                  if (secondItems.isEmpty) {
                    secondSelectedValue = null;
                  } else {
                    final secondCurrentValue = (provider as dynamic)
                        .getField
                        ?.call('secondDropdownKey')
                        ?.toString();
                    secondSelectedValue = (secondCurrentValue != null &&
                            secondItems.contains(secondCurrentValue))
                        ? secondCurrentValue
                        : secondItems.first;
                  }
                } else {
                  secondItems = [];
                  secondSelectedValue = null;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (label.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                    // First Dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Card(
                        elevation: 0,
                        color: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              value: selectedValue,
                              hint: Text(
                                "Select an option",
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.grey,
                                  fontFamily: themeProvider.fontFamily,
                                ),
                              ),
                              iconStyleData: IconStyleData(
                                iconEnabledColor: fontColor,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: items.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontFamily: themeProvider.fontFamily,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    selectedValue = value;
                                    // Update provider
                                    final fieldKey =
                                        item['fieldKey'] ?? item['id'];
                                    try {
                                      (provider as dynamic)
                                          .setField(fieldKey, value);
                                    } catch (e) {
                                      logger.e("Failed to update provider: $e");
                                    }
                                    // Reset second dropdown selection
                                    secondSelectedValue = null;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Second Dropdown (only show if has items)
                    if (secondItems.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Card(
                          elevation: 0,
                          color: backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                value: secondSelectedValue,
                                hint: Text(
                                  "Select dependent option",
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color: Colors.grey,
                                    fontFamily: themeProvider.fontFamily,
                                  ),
                                ),
                                iconStyleData: IconStyleData(
                                  iconEnabledColor: fontColor,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: secondItems.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontFamily: themeProvider.fontFamily,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      secondSelectedValue = value;
                                      try {
                                        (provider as dynamic).setField(
                                            'secondDropdownKey', value);
                                      } catch (e) {
                                        logger
                                            .e("Failed to update provider: $e");
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (errorText != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4, left: padding),
                        child: Text(
                          errorText,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontFamily: themeProvider.fontFamily,
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          }

        case 'Captcha':
          {
            final length = item['length'] ?? 6;
            final fontSize = (item['fontSize'] as num?)?.toDouble() ?? 24.0;
            final textColor = parseHexColor(item['textColor']) ?? Colors.black;
            final bgColor =
                parseHexColor(item['bgColor']) ?? Colors.grey.shade200;

            return StatefulBuilder(
              builder: (context, setState) {
                String captcha = List.generate(
                    length, (_) => (Random().nextInt(10)).toString()).join();

                void regenerate() {
                  setState(() {
                    captcha = List.generate(
                            length, (_) => (Random().nextInt(10)).toString())
                        .join();
                  });
                }

                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: bgColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        captcha,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: textColor,
                          letterSpacing: 4.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: regenerate,
                      )
                    ],
                  ),
                );
              },
            );
          }

        case 'Description':
          {
            final text = item['text'] ?? '';
            final fontSize = (item['fontSize'] as num?)?.toDouble() ?? 14.0;
            final textColor = parseHexColor(item['textColor']) ?? Colors.black;
            final padding = (item['padding'] as num?)?.toDouble() ?? 8.0;
            final fontWeight =
                parseFontWeight(item['fontWeight']?.toString() ?? 'normal');
            final textAlignStr = item['textAlign']?.toString() ?? 'left';

            TextAlign textAlign;
            switch (textAlignStr) {
              case 'center':
                textAlign = TextAlign.center;
                break;
              case 'right':
                textAlign = TextAlign.right;
                break;
              default:
                textAlign = TextAlign.left;
            }

            return Padding(
              padding: EdgeInsets.all(padding),
              child: Text(
                text,
                textAlign: textAlign,
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                  fontWeight: fontWeight,
                ),
              ),
            );
          }

        case 'lineSaparate':
          {
            final textFieldProperty = item['textFieldPropertyType'];
            final properties = Map<String, dynamic>.from(
              themeProvider.textProperties[textFieldProperty] ?? {},
            );
            final textStyle = TextStyle(
              color: parseColor(properties["fontColor"] ?? "#000000"),
              fontSize: (properties["fontSize"] ?? 14).toDouble(),
              fontWeight: parseFontWeight(properties["fontWeight"] ?? "normal"),
              fontFamily: themeProvider.fontFamily,
              letterSpacing: (properties['letterSpacing'] ?? 1.0).toDouble(),
            );
            return Container(
              width: 300,
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Expanded(
                      child: Divider(
                          color: Color(int.parse(item['dividerColor']
                              .replaceFirst("#", "0xFF"))))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(item['text'], style: textStyle),
                  ),
                  Expanded(
                      child: Divider(
                          color: Color(int.parse(item['dividerColor']
                              .replaceFirst("#", "0xFF"))))),
                ],
              ),
            );
          }
        case 'ButtonInRow':
          {
            final textFieldProperty = item['textFieldPropertyType'];
            final properties = Map<String, dynamic>.from(
              themeProvider.textProperties[textFieldProperty] ?? {},
            );
            final textStyle = TextStyle(
              color: parseColor(properties["fontColor"] ?? "#000000"),
              fontSize: (properties["fontSize"] ?? 14).toDouble(),
              fontWeight: parseFontWeight(properties["fontWeight"] ?? "normal"),
              fontFamily: themeProvider.fontFamily,
              letterSpacing: (properties['letterSpacing'] ?? 1.0).toDouble(),
            );
            return Center(
              child: SizedBox(
                width: MediaQuery.maybeOf(context)?.size.width ?? 360.0 * 0.8,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    final actionKey = item['onTapAction'];
                    logger.i("actionKey: $actionKey");
                    if (actionHandlers != null && actionKey != null) {
                      actionHandlers[actionKey]?.call();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 20,
                    backgroundColor: Color(int.parse(
                        item["NdiButtonColor"].replaceFirst("#", "0xFF"))),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: item['alignment'] == 'end'
                          ? MainAxisAlignment.end
                          : item['alignment'] == 'center'
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          item['image'],
                          height: item['height'].toDouble(),
                          width: item['width'].toDouble(),
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            item['text'],
                            style: textStyle,
                            softWrap: true,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

        case 'otpField':
          {
            final fieldId = item['id'];

            final controller = controllers[fieldId] as TextEditingController? ??
                TextEditingController();
            controllers[fieldId] ??= controller;

            final defaultPinTheme = PinTheme(
              width: screenHeightForOtp * 0.05,
              height: screenHeightForOtp * 0.06,
              textStyle: const TextStyle(fontSize: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFDAEFD5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1C3144)),
              ),
            );

            final focusedPinTheme = defaultPinTheme.copyWith(
              decoration: BoxDecoration(
                color: const Color(0xFFDAEFD5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1C3144), width: 3),
              ),
            );

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Center(
                child: Pinput(
                  length: 6,
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  onCompleted: (pin) {
                    debugPrint('OTP entered: $pin');
                    // Optionally trigger an action or validation here
                  },
                ),
              ),
            );
          }
        case 'contactButton':
          {
            return Column(
              children: [
                SizedBox(
                  height: item['belowHeight'].toDouble(),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 2,
                    ),
                    child: GestureDetector(
                      onTap: () => launchPhone(),
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
        case 'Search':
          final fieldId = item['id'];
          final textFieldProperty = item['textFieldPropertyType'];
          final properties = Map<String, dynamic>.from(
            themeProvider.textProperties[textFieldProperty] ?? {},
          );

          return Builder(
            builder: (context) {
              final themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);
              final controller =
                  controllers[fieldId] ??= TextEditingController();
              final focusNode = focusNodes[fieldId];

              final fontColor =
                  parseColor(properties['fontColor'] ?? "#000000");
              final fontSize = (properties['fontSize'] ?? 14).toDouble();
              final fontWeight =
                  parseFontWeight(properties['fontWeight'] ?? "bold");
              final backgroundColor =
                  parseColor(properties['backgroundColor'] ?? "#FFFFFF");
              final padding = (properties['padding'] ?? 20).toDouble();
              final borderRadius = (properties['borderRadius'] ?? 8).toDouble();

              final keyboardType = item['keyboardType'] == 'phone'
                  ? TextInputType.phone
                  : item['keyboardType'] == 'email'
                      ? TextInputType.emailAddress
                      : TextInputType.text;

              final maxLength = item['maxLength'] ?? 50;

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
                      item['label'] ?? fieldId,
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
                      controller: controller,
                      keyboardType: keyboardType,
                      maxLength: maxLength,
                      inputFormatters: inputFormatters,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        letterSpacing: 1.2,
                        fontFamily: themeProvider.fontFamily,
                      ),
                      decoration: InputDecoration(
                        hintText: item['hintText'] ?? '',
                        hintStyle: TextStyle(
                          letterSpacing: 1.2,
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
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            logger.i('Search icon pressed for $fieldId');
                            // Add any search trigger logic here if needed
                          },
                        ),
                      ),
                    ),
                  ),
                  if (errorTexts[fieldId] != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4, left: padding),
                      child: Text(
                        errorTexts[fieldId]!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontFamily: themeProvider.fontFamily,
                        ),
                      ),
                    ),
                ],
              );
            },
          );

        case 'ProfileImage':
          {
            final profileImageString = registry.getValue('profileImage');
            Uint8List? profileImageBytes;
            if (profileImageString != null && profileImageString is String) {
              try {
                profileImageBytes = base64Decode(profileImageString);
              } catch (e) {
                profileImageBytes = null;
              }
            }
            double screenWidth =
                MediaQuery.maybeOf(context)?.size.width ?? 360.0;

            final loyality = item['loyality'] ?? {};
            final loyaltyPoints = loyality['LoyaltyPoints'] ?? {};
            final loyalityIcon = loyaltyPoints['icon'] ?? {};

            final profileName = item['profileName'] ?? {};
            final profileAddress = item['profileAddress'] ?? {};
            final addressIcon = profileAddress['icon'] ?? {};

            final divider = item['divider'] ?? {};
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                GestureDetector(
                  // onTap: () async {
                  //   logger.i("profileRefresh clicked");
                  //   showLoading(context);
                  //   final response = await profileRefresh();
                  //   navigatorKey.currentState!.pop();
                  //   logger.i(response);
                  //   if (response['RESPONSE']['RESPCODE'] == "1012") {
                  //     registry.setValue("validLoginDet", true);
                  //     // Navigator.pushAndRemoveUntil(
                  //     //     context,
                  //     //     MaterialPageRoute(
                  //     //         builder: (_) => const landingPage(
                  //     //               jsonString: '',
                  //     //             )),
                  //     //     (route) => false);
                  //     Navigator.pushAndRemoveUntil(
                  //         context,
                  //         MaterialPageRoute(builder: (_) => const LoginPage()),
                  //         (route) => false);
                  //     showPopup(
                  //         context, response['RESPONSE']['RESPDESC'].toString());
                  //   } else if (response['RESPONSE']['RESPCODE'] != '0000') {
                  //     showPopup(navigatorKey.currentContext!,
                  //         response['RESPONSE']['RESPDESC']);
                  //   } else if (response['RESPONSE']['RESPCODE'] == '0000') {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //         behavior: SnackBarBehavior.floating,
                  //         backgroundColor: Color.fromRGBO(0, 0, 0, 0.716),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.vertical(
                  //               top: Radius.circular(5.0)),
                  //         ),
                  //         content: Text(
                  //           'Profile Refreshed Successfully!',
                  //           style: TextStyle(fontSize: 18, color: Colors.white),
                  //         ),
                  //       ),
                  //     );
                  //   }
                  // },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset("lib/phase/images/refresh.png", height: 35),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.transparent, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: profileImageBytes != null
                                ? MemoryImage(profileImageBytes)
                                : const AssetImage(
                                        'lib/phase/images/profile.png')
                                    as ImageProvider,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.star,
                              size: (loyalityIcon["iconSize"] ?? 20).toDouble(),
                              color: parseColor(
                                  loyalityIcon["iconColor"] ?? "#F37B26"),
                            ),
                            const SizedBox(width: 5),
                            Text(
                                registry.getValue("totalPoints") ??
                                    0.toString(),
                                style: TextStyle(
                                  fontSize: (loyaltyPoints["fontSize"] ?? 14)
                                      .toDouble(),
                                  fontWeight: parseFontWeight(
                                      loyaltyPoints["fontWeight"]),
                                  color: parseColor(loyaltyPoints["fontColor"]),
                                  fontFamily: themeProvider.fontFamily,
                                )),
                          ],
                        ),
                        Text(
                          loyality["heading"] ?? "Loyalty Points",
                          style: TextStyle(
                            fontWeight: parseFontWeight(loyality["fontWeight"]),
                            fontSize: (loyality["fontSize"] ?? 16).toDouble(),
                            color: parseColor(loyality["fontColor"]),
                            fontFamily: themeProvider.fontFamily,
                          ),
                        ),
                        Text(
                          registry.getValue("name") ?? '',
                          style: TextStyle(
                            fontWeight:
                                parseFontWeight(profileName["fontWeight"]),
                            fontSize:
                                (profileName["fontSize"] ?? 16).toDouble(),
                            color: parseColor(profileName["fontColor"]),
                            fontFamily: themeProvider.fontFamily,
                          ),
                        ),
                        const SizedBox(height: 5),
                        ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: screenWidth * 0.45),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (registry.getValue("isPrepaid") ?? false)
                                Icon(
                                  parseIcon(addressIcon["codePoint"]),
                                  size: (addressIcon["iconSize"] ?? 14)
                                      .toDouble(),
                                  color: parseColor(
                                      addressIcon["fontColor"] ?? "#1C3144"),
                                ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  registry.getValue("Useraddress") ?? "",
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    fontWeight: parseFontWeight(
                                        profileAddress["fontWeight"]),
                                    fontSize: (profileAddress["fontSize"] ?? 14)
                                        .toDouble(),
                                    color:
                                        parseColor(profileAddress["fontColor"]),
                                    fontFamily: themeProvider.fontFamily,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Divider(
                    color: parseColor(divider["color"] ?? "#5FBB49"),
                    thickness: (divider["height"] ?? 1).toDouble(),
                  ),
                ),
              ],
            );
          }

        case 'logout':
          {
            final buttonType = item['buttonStyleType'];
            final iconNeeded = item['IconNeeded'] ?? false;
            final label = item['label'] ?? 'Button';
            final actionKey = item['onPressed'];

            VoidCallback? onPressed;
            if (actionHandlers != null && actionKey != null) {
              onPressed = actionHandlers[actionKey];
              logger.i("actionKeyTBRRR1: ${actionHandlers}");
              logger.i("actionKeyTBRRR2: ${actionHandlers[actionKey]}");

              if (onPressed == null) {
                logger.i("actionKeyTBRRR: $onPressed");
                logger.w('No action handler found for ${item['onPressed']}');
                logger.e("No handler found for actionKey: $actionKey");
              }
            }

            final properties = themeProvider.buttonProperties[buttonType] ?? {};
            logger.i("properties: ${themeProvider.buttonProperties}");

            final textStyle = TextStyle(
              color: parseColor(properties["fontColor"] ?? "#F37B26"),
              fontSize: (properties["fontSize"] ?? 14).toDouble(),
              fontWeight: parseFontWeight(properties["fontWeight"] ?? "normal"),
              fontFamily: themeProvider.fontFamily,
              letterSpacing: (properties['letterSpacing'] ?? 1.0).toDouble(),
            );

            final screenWidth =
                MediaQuery.maybeOf(context)?.size.width ?? 360.0;

            final horizontalPadding =
                (properties['padding']?['horizontal'] ?? 40).toDouble();
            final verticalPadding =
                (properties['padding']?['vertical'] ?? 15).toDouble();

            final padding = EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            );

            final buttonWidth = screenWidth - (horizontalPadding * 2);

            final buttonChild = FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (iconNeeded)
                    Icon(
                      parseIcon(item['icon']),
                    ),
                  SizedBox(width: (item['spaceBetween'] ?? 30).toDouble()),
                  Text(
                    label,
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );

            final shape = RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Slightly sharp corners
            );

            return Padding(
              padding: padding,
              child: SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: shape,
                    backgroundColor:
                        parseColor(properties['backgroundColor'] ?? "#124682"),
                    foregroundColor:
                        parseColor(properties['foregroundColor'] ?? "#FFFFFF"),
                  ),
                  child: buttonChild,
                ),
              ),
            );
          }

        case 'editProfile':
          {
            final profileImageString = registry.getValue('profileImage');
            Uint8List? profileImageBytes;
            if (profileImageString != null && profileImageString is String) {
              try {
                profileImageBytes = base64Decode(profileImageString);
              } catch (e) {
                profileImageBytes = null;
              }
            }
            bool showEditOptions = false;

            return StatefulBuilder(
              builder: (context, setState) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Profile image
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: (item['radius'] ?? 50).toDouble(),
                        backgroundImage: profileImageBytes != null
                            ? MemoryImage(profileImageBytes!)
                            : const AssetImage('lib/phase/images/profile.png')
                                as ImageProvider,
                      ),
                    ),

                    // Edit icon button on bottom-right
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showEditOptions = !showEditOptions;
                          });
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit,
                              size: 16, color: Colors.orange.shade800),
                        ),
                      ),
                    ),

                    // Upload / Remove buttons
                    if (showEditOptions)
                      Positioned(
                        right: -110, // adjust spacing from the image
                        bottom: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // Upload logic
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreen[100],
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.file_upload, size: 16),
                              label: const Text("Upload",
                                  style: TextStyle(fontSize: 14)),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Remove logic
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[200],
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.delete, size: 16),
                              label: const Text("Remove",
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            );
          }

        default:
          return const SizedBox();
      }
    }).toList(),
  );
}
