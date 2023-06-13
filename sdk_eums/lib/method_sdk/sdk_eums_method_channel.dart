import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sdk_eums_c/sdk_eums_c_platform_interface.dart';

import 'sdk_eums_platform_interface.dart';

/// An implementation of [SdkEumsPlatform] that uses method channels.
class MethodChannelSdkEums extends SdkEumsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sdk_eums');

  @override
  Future methodAdpopcorn() async {
    if (Platform.isAndroid) {
      await methodChannel.invokeMethod<String>('Adpopcorn');
    } else {
      await SdkEumsPlatform.instance.methodAdpopcorn();
    }
  }

  @override
  Future methodAdsync() async {
    if (Platform.isAndroid) {
      await methodChannel.invokeMethod<String>('adsync');
    } else {
      await SdkEums_cPlatform.instance.methodAdsync();
    }
  }

  @override
  Future methodAppall() async {
    await methodChannel.invokeMethod<String>('appall');
  }

  @override
  Future methodMafin() async {
    if (Platform.isAndroid) {
      await methodChannel.invokeMethod<String>('mafin');
    } else {
      await SdkEums_cPlatform.instance.methodMafin();
    }
  }

  @override
  Future methodIvekorea() async {
    await methodChannel.invokeMethod<String>('iveKorea');
  }

  @override
  Future methodTnk() async {
    await methodChannel.invokeMethod<String>('tkn');
  }

  @override
  Future methodOHC() async {
    await methodChannel.invokeMethod<String>('ohc');
  }
}
