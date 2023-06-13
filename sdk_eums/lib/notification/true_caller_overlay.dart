import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart'
    as flutterOverlay;
import 'package:sdk_eums/api_eums_offer_wall/eums_offer_wall_service_api.dart';
import 'package:sdk_eums/common/local_store/local_store.dart';
import 'package:sdk_eums/common/local_store/local_store_service.dart';
import 'package:sdk_eums/common/routing.dart';
import 'package:sdk_eums/eum_app_offer_wall/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:sdk_eums/eum_app_offer_wall/bloc/push_notification_service/bloc/push_notification_service_bloc.dart';
import 'package:sdk_eums/eum_app_offer_wall/bloc/setting_bloc/bloc/setting_bloc.dart';
import 'package:sdk_eums/eum_app_offer_wall/screen/accumulate_money_module/bloc/accumulate_money_bloc.dart';
import 'package:sdk_eums/eum_app_offer_wall/screen/watch_adver_module/watch_adver_screen.dart';
import 'package:sdk_eums/eum_app_offer_wall/utils/appColor.dart';
import 'package:sdk_eums/gen/assets.gen.dart';
import 'package:sdk_eums/sdk_eums_library.dart';

import '../eum_app_offer_wall/utils/appStyle.dart';

class TrueCallerOverlay extends StatefulWidget {
  const TrueCallerOverlay({Key? key}) : super(key: key);

  @override
  State<TrueCallerOverlay> createState() => _TrueCallerOverlayState();
}

class _TrueCallerOverlayState extends State<TrueCallerOverlay> {
  final GlobalKey<State<StatefulWidget>> globalKey =
      GlobalKey<State<StatefulWidget>>();
  dynamic dataEvent;

  @override
  void initState() {
    super.initState();
    flutterOverlay.FlutterOverlayWindow.overlayListener.listen((event) {
      log("$event");
      setState(() {
        dataEvent = event;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterOverlay.FlutterOverlayWindow.closeOverlay();
  }

  @override
  Widget build(BuildContext context) {
 
    return Material(
      color: Colors.transparent,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<LocalStore>(
              create: (context) => LocalStoreService()),
          RepositoryProvider<EumsOfferWallService>(
              create: (context) => EumsOfferWallServiceApi())
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthenticationBloc>(
                create: (context) =>
                    AuthenticationBloc()..add(CheckSaveAccountLogged()),
              ),
              BlocProvider<PushNotificationServiceBloc>(
                create: (context) => PushNotificationServiceBloc(),
              ),
              BlocProvider<SettingBloc>(
                  create: (context) => SettingBloc()..add(InfoUser())),
            ],
            child: MultiBlocListener(
              listeners: [
                BlocListener<AuthenticationBloc, AuthenticationState>(
                  listenWhen: (previous, current) =>
                      previous.logoutStatus != current.logoutStatus,
                  listener: (context, state) {
                    if (state.logoutStatus == LogoutStatus.loading) {
                      EasyLoading.show();
                      return;
                    }
                    if (state.logoutStatus == LogoutStatus.finish) {
                      EasyLoading.dismiss();
                      return;
                    }
                  },
                ),
              ],
              child: _buildWidget(context),
            )),
      ),
    );
  }

  _buildWidget(BuildContext context) {
    return BlocProvider<AccumulateMoneyBloc>(
      create: (context) => AccumulateMoneyBloc(),
      child: MultiBlocListener(listeners: [
        BlocListener<AccumulateMoneyBloc, AccumulateMoneyState>(
          listenWhen: (previous, current) =>
              previous.accumulateMoneyStatus != current.accumulateMoneyStatus,
          listener: _listenFetchData,
        ),
        BlocListener<AccumulateMoneyBloc, AccumulateMoneyState>(
          listenWhen: (previous, current) =>
              previous.saveKeepStatus != current.saveKeepStatus,
          listener: _listenSaveKeep,
        ),
      ], child: _buildContent(context)),
    );
  }

  Color color = Colors.black;
  _buildContent(BuildContext context) {
    final showDraggable = color == Colors.black;

    return Scaffold(
      key: globalKey,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 100,
            ),
            DragTarget<Color>(
              onAccept: (data) => setState(() {
                setState(() {
                  color = data;
                  Routing().navigate(
                      context,
                      WatchAdverScreen(
                        data: dataEvent,
                      ));
                });
                color = Colors.black;
              }),
              builder: (context, candidateData, rejectedData) {
                return SizedBox(
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Assets.watchAdsNow.path,
                          package: "sdk_eums", width: 30, height: 30),
                      const SizedBox(width: 5),
                      Text(
                        "광고 바로 시청하기",
                        style: AppStyle.bold
                            .copyWith(color: AppColor.white, fontSize: 23),
                      )
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width / 2,
            ),
            IgnorePointer(
              ignoring: !showDraggable,
              child: Opacity(
                opacity: showDraggable ? 1 : 0,
                child: Draggable(
                    data: Colors.amber,
                    feedback: Image.asset(
                      Assets.icon_logo.path,
                      package: "sdk_eums",
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3,
                    ),
                    childWhenDragging: SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3,
                    ),
                    child: Image.asset(
                      Assets.icon_logo.path,
                      package: "sdk_eums",
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3,
                    )),
              ),
            ),
            const Spacer(),
            DragTarget<Color>(
              onAccept: (data) => setState(() {
                globalKey.currentContext?.read<AccumulateMoneyBloc>().add(
                    SaveKeepAdver(
                        advertise_idx: jsonDecode(dataEvent['data'])['idx']));
                color = data;
              }),
              builder: (context, candidateData, rejectedData) {
                return SizedBox(
                  // color: color,
                  height: 100,

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Assets.saveAdvertise.path,
                          package: "sdk_eums", width: 30, height: 30),
                      const SizedBox(width: 5),
                      Text(
                        "광고 보관하기",
                        style: AppStyle.bold
                            .copyWith(color: AppColor.white, fontSize: 23),
                      )
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            ),
          ],
        ),
      ),
    );
  }

  void _listenFetchData(BuildContext context, AccumulateMoneyState state) {
    if (state.accumulateMoneyStatus == AccumulateMoneyStatus.loading) {
      EasyLoading.show();
      return;
    }
    if (state.accumulateMoneyStatus == AccumulateMoneyStatus.failure) {
      EasyLoading.dismiss();
      return;
    }
    if (state.accumulateMoneyStatus == AccumulateMoneyStatus.success) {
      EasyLoading.dismiss();
    }
  }

  void _listenSaveKeep(BuildContext context, AccumulateMoneyState state) {
    if (state.saveKeepStatus == SaveKeepStatus.loading) {
      EasyLoading.show();
      return;
    }
    if (state.saveKeepStatus == SaveKeepStatus.failure) {
      EasyLoading.dismiss();
      return;
    }
    if (state.saveKeepStatus == SaveKeepStatus.success) {
      EasyLoading.dismiss();
      setState(() {
        color = Colors.black;
      });

      if (flutterOverlay.FlutterOverlayWindow.isActive() == true) {
        flutterOverlay.FlutterOverlayWindow.closeOverlay();
      }
    }
  }
}
