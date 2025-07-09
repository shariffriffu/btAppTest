import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';


JsonWidgetRegistry registry = JsonWidgetRegistry.instance;

var logger = Logger();
final PageController pageController = PageController(viewportFraction: 0.9);
int currentPage = 0;
int selectedIndex = 0;
OverlayEntry? starOverlay;
bool isFavoritesExpanded = false;
int? selectedAmount;
Set<String> highlightedServices = {};
final GlobalKey<SlideActionState> globalSlideActionKey =
    GlobalKey<SlideActionState>();
Map<String, dynamic>? layoutJson;
bool obscureBalance = false;
final GlobalKey columnKey = GlobalKey();
final Map<String, String> selectedValues = {};
String capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
