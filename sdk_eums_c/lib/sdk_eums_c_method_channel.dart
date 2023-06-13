import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sdk_eums_c_platform_interface.dart';

/// An implementation of [SdkEums_cPlatform] that uses method channels.
class MethodChannelSdkEums_c extends SdkEums_cPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sdk_eums_c');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future methodAdpopcorn() async {
    try {
      await methodChannel.invokeMethod<dynamic>('Adpopcorn');
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future methodAdsync() async {
    try {
      await methodChannel.invokeMethod<dynamic>('Adsync');
      return true;
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future methodMafin() async {
    try {
      await methodChannel.invokeMethod<dynamic>('mafin');
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
