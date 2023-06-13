import 'package:flutter/material.dart';
import 'package:sdk_eums/sdk_eums_permission.dart';

class SdkEums {
  SdkEums._();

  static final SdkEums instant = SdkEums._();

  // late BuildContext contextMain;

  SdkEumsPermission permission = SdkEumsPermission.instant;

  void init({required Function() onRun}) async {
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();
    // NotificationConfig.instant.init();
    onRun.call();
  }

  // initContext(BuildContext context) {
  //   contextMain = context;
  // }
}
