// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart'
    as flutterOverlay;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sdk_eums/common/routing.dart';
import 'package:sdk_eums/eum_app_offer_wall/widget/app_alert.dart';

import '../../bloc/setting_bloc/bloc/setting_bloc.dart';
import '../../utils/appColor.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/custom_webview.dart';
import 'bloc/watch_adver_bloc.dart';

class WatchAdverScreen extends StatefulWidget {
  const WatchAdverScreen({Key? key, this.data}) : super(key: key);

  final dynamic data;

  @override
  State<WatchAdverScreen> createState() => _WatchAdverScreenState();
}

class _WatchAdverScreenState extends State<WatchAdverScreen> {
  final GlobalKey<State<StatefulWidget>> globalKey =
      GlobalKey<State<StatefulWidget>>();
  FToast fToast = FToast();

  final _key = UniqueKey();

  @override
  void initState() {
    fToast.init(context);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterOverlay.FlutterOverlayWindow.closeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WatchAdverBloc>(
      create: (context) => WatchAdverBloc(),
      // ..add(WatchAdver(id: 'abeetest')),
      child: MultiBlocListener(listeners: [
        BlocListener<WatchAdverBloc, WatchAdverState>(
            listener: _listenFetchData),
        BlocListener<WatchAdverBloc, WatchAdverState>(
            listener: _listenFetchDataEarnPoint),
        BlocListener<WatchAdverBloc, WatchAdverState>(listener: _listenSave)
      ], child: _buidlContent(context)),
    );
  }

  void _listenFetchDataEarnPoint(BuildContext context, WatchAdverState state) {
    if (state.earnMoneyStatus == EarnMoneyStatus.loading) {
      EasyLoading.show();
      return;
    }
    if (state.earnMoneyStatus == EarnMoneyStatus.failure) {
      EasyLoading.dismiss();
      return;
    }
    if (state.earnMoneyStatus == EarnMoneyStatus.success) {
      if (Platform.isIOS) {
        globalKey.currentContext?.read<SettingBloc>().add(InfoUser());
        Routing().popToRoot(context);
      }
      if (Platform.isAndroid) {
        flutterOverlay.FlutterOverlayWindow.closeOverlay();
      }
      EasyLoading.dismiss();
    }
  }

  void _listenSave(BuildContext context, WatchAdverState state) {
    if (state.saveKeepAdverboxStatus == SaveKeepAdverboxStatus.loading) {
      EasyLoading.show();
      return;
    }
    if (state.saveKeepAdverboxStatus == SaveKeepAdverboxStatus.failure) {
      EasyLoading.dismiss();
      return;
    }
    if (state.saveKeepAdverboxStatus == SaveKeepAdverboxStatus.success) {
      EasyLoading.dismiss();
      AppAlert.showSuccess(context, fToast, 'Success', );
    }
  }

  void _listenFetchData(BuildContext context, WatchAdverState state) {
    if (state.watchAdverStatus == WatchAdverStatus.loading) {
      EasyLoading.show();
      return;
    }
    if (state.watchAdverStatus == WatchAdverStatus.failure) {
      EasyLoading.dismiss();
      return;
    }
    if (state.watchAdverStatus == WatchAdverStatus.success) {
      setState(() {});

      EasyLoading.dismiss();
    }
  }

  Scaffold _buidlContent(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: CustomWebView(
        showImage: true,
        title: '',
        colorIconBack: AppColor.white,
        showMission: true,
        onSave: () {
          globalKey.currentContext?.read<WatchAdverBloc>().add(SaveAdver(
              advertise_idx: Platform.isIOS
                  ? jsonDecode(widget.data)['idx']
                  : jsonDecode(widget.data['data'])['idx']));
          setState(() {});
        },
        mission: () {
          DialogUtils.showDialogSucessPoint(context, data: widget.data,
              voidCallback: () {
            globalKey.currentContext?.read<WatchAdverBloc>().add(EarnPoin(
                advertise_idx: Platform.isIOS
                    ? jsonDecode(widget.data)['idx']
                    : jsonDecode(widget.data['data'])['idx'],
                pointType: Platform.isIOS
                    ? jsonDecode(widget.data)['typePoint']
                    : jsonDecode(widget.data['data'])['typePoint']));
          });
        },
        // urlLink: 'https://www.abee.co.kr/landingpage/babean/babeans.html',
        urlLink: Platform.isIOS
            ? jsonDecode(widget.data)['url_link']
            : jsonDecode(widget.data['data'])['url_link'],
      ),
    );
  }
}
