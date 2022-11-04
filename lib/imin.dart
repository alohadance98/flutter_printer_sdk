import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Imin {
  MethodChannel channel = const MethodChannel('com.imin.printersdk');
  ValueNotifier<String> stateNotifier = ValueNotifier("");

  Future<String> init() async {
    final String result = await channel.invokeMethod("sdkInit");
    return result;
  }

  Future<void> printText(String text) async {
    stateNotifier.value =
        await channel.invokeMethod("printText", {"arg": text});
  }
}
