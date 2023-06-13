import 'package:flutter/material.dart';
import 'package:sdk_eums/common/local_store/local_store.dart';
import 'package:sdk_eums/eum_app_offer_wall/screen/main.dart';
import 'package:sdk_eums/sdk_eums_library.dart';

import '../common/local_store/local_store_service.dart';
import 'eums_app_i.dart';

class EumsAppOfferWall extends EumsAppOfferWallService {
  LocalStore localStore = LocalStoreService();
  @override
  Future openSdk(
      {String? memId,
      String? memGen,
      String? memRegion,
      String? memBirth}) async {
    dynamic data = await EumsOfferWallService.instance.authConnect(
        memBirth: memBirth, memGen: memGen, memRegion: memRegion, memId: memId);
    await Future.delayed(const Duration(milliseconds: 350));
    localStore.setAccessToken(data['token']);
    if (await localStore.getAccessToken() != null) {
      mainApp();
    }

    // runApp(MyHomeScreen());
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(),
    );
  }
}
