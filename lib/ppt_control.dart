import 'package:flutter/services.dart';

class PptControl {
  static const platform = MethodChannel('ppt_control');

  static Future<void> initialize() async {
    try {
      await platform.invokeMethod('controlPowerPoint', 0);
    } on PlatformException catch (e) {
      print("Failed to initialize PowerPoint: '${e.message}'.");
    }
  }

  static Future<void> nextSlide() async {
    try {
      await platform.invokeMethod('controlPowerPoint', 1);
    } on PlatformException catch (e) {
      print("Failed to go to the next slide: '${e.message}'.");
    }
  }

  static Future<void> previousSlide() async {
    try {
      await platform.invokeMethod('controlPowerPoint', 2);
    } on PlatformException catch (e) {
      print("Failed to go to the previous slide: '${e.message}'.");
    }
  }

  static Future<int> maximumSlides() async {
    try {
      int maxSlides = await platform.invokeMethod('controlPowerPoint', 3);
      return maxSlides;
    } on PlatformException catch (e) {
      print("Failed to retrieve maximum slides: '${e.message}'.");
      return -1; // Return a default value or handle the error appropriately
    }
  }
}
