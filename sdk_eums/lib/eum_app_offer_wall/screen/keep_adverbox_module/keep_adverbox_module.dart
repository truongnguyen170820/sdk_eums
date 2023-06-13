import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sdk_eums/common/constants.dart';
import 'package:sdk_eums/common/routing.dart';
import 'package:sdk_eums/common/rx_bus.dart';
import 'package:sdk_eums/eum_app_offer_wall/screen/keep_adverbox_module/bloc/keep_adverbox_bloc.dart';
import 'package:sdk_eums/eum_app_offer_wall/utils/appColor.dart';
import 'package:sdk_eums/eum_app_offer_wall/utils/appStyle.dart';
import 'package:sdk_eums/eum_app_offer_wall/utils/app_string.dart';
import 'package:sdk_eums/eum_app_offer_wall/widget/app_alert.dart';
import 'package:sdk_eums/eum_app_offer_wall/widget/custom_dialog.dart';
import 'package:sdk_eums/eum_app_offer_wall/widget/custom_webview.dart';
import 'package:sdk_eums/gen/assets.gen.dart';

import '../../../common/events/rx_events.dart';
import '../../bloc/setting_bloc/bloc/setting_bloc.dart';

class KeepAdverboxScreen extends StatefulWidget {
  const KeepAdverboxScreen({Key? key}) : super(key: key);

  @override
  State<KeepAdverboxScreen> createState() => _KeepAdverboxScreenState();
}

class _KeepAdverboxScreenState extends State<KeepAdverboxScreen> {
  final GlobalKey<State<StatefulWidget>> globalKey =
      GlobalKey<State<StatefulWidget>>();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  dynamic numberDay;

  @override
  void initState() {
    _registerEventBus();
    super.initState();
  }

  Future<void> _registerEventBus() async {
    RxBus.register<RefreshDataKeep>().listen((event) {
      _onRefresh();
    });

    RxBus.register<ShowDataAdver>(tag: Constants.showDataAdver)
        .listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KeepAdverboxBloc>(
      create: (context) =>
          KeepAdverboxBloc()..add(KeepAdverbox(limit: Constants.LIMIT_DATA)),
      child: BlocListener<KeepAdverboxBloc, KeepAdverboxState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: _listenFetchData,
        child: BlocBuilder<KeepAdverboxBloc, KeepAdverboxState>(
          builder: (context, state) {
            return _buildContent(context, state.dataKeepAdverbox);
          },
        ),
      ),
    );
  }

  void _listenFetchData(BuildContext context, KeepAdverboxState state) {
    if (state.status == KeepAdverboxStatus.loading) {
      EasyLoading.show();
      return;
    }
    if (state.status == KeepAdverboxStatus.failure) {
      EasyLoading.dismiss();
      // AppAlert.showError(
      //     fToast,
      //     state.error != null
      //         ? state.error!.message != null
      //             ? state.error!.message!
      //             : 'Error!'
      //         : 'Error!');
      return;
    }
    if (state.status == KeepAdverboxStatus.success) {
      EasyLoading.dismiss();
    }
  }

  DateTime now = DateTime.now();

  Scaffold _buildContent(context, dynamic data) {
    return Scaffold(
      key: globalKey,
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 1,
        centerTitle: true,
        title: Text('광고 보관함',
            style: AppStyle.bold.copyWith(fontSize: 16, color: AppColor.black)),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back_ios_outlined,
              color: AppColor.dark, size: 25),
        ),
      ),
      body: SmartRefresher(
        controller: refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        header: CustomHeader(
          builder: (BuildContext context, RefreshStatus? mode) {
            return const Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.transparent)));
          },
        ),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            return mode == LoadStatus.loading
                ? Center(
                    child: Column(
                    children: const [
                      Text(' '),
                      CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black)),
                    ],
                  ))
                : Container();
          },
        ),
        enablePullDown: true,
        enablePullUp: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                      color: AppColor.red4.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('광고 볼 시간이 없다면',
                          style: AppStyle.medium.copyWith(fontSize: 20)),
                      RichText(
                          text: TextSpan(
                              text: '보관',
                              style: AppStyle.bold
                                  .copyWith(color: Colors.blue, fontSize: 25),
                              children: [
                            TextSpan(
                              text: '해두고 나중에 보세요~!',
                              style: AppStyle.bold.copyWith(
                                  color: AppColor.black, fontSize: 25),
                            )
                          ])),
                      const SizedBox(height: 5),
                      RichText(
                          text: TextSpan(
                              text: '* 하루 최대 20개',
                              style: AppStyle.regular
                                  .copyWith(color: AppColor.red, fontSize: 12),
                              children: [
                            TextSpan(
                              text: '까지 가능합니다.',
                              style: AppStyle.regular.copyWith(
                                  color: AppColor.color70, fontSize: 12),
                            )
                          ])),
                      const SizedBox(height: 2),
                      RichText(
                          text: TextSpan(
                              text: '* 3일동안 보관',
                              style: AppStyle.regular
                                  .copyWith(color: AppColor.red, fontSize: 12),
                              children: [
                            TextSpan(
                              text: '되며, 3일이 지난 광고는 다른 사람에게 갑니다',
                              style: AppStyle.regular.copyWith(
                                  color: AppColor.color70, fontSize: 12),
                            )
                          ])),
                      const SizedBox(height: 2),
                      Text(
                        '*광고가 만료되거나 소멸되면 저장된 광고가 사라질 수도 있습니다.',
                        style: AppStyle.regular
                            .copyWith(color: AppColor.color70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                data != null
                    ? Wrap(
                        children: List.generate(data.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              Routing().navigate(
                                  context,
                                  DetailKeepScreen(
                                    url: data[index]['url_link'],
                                    id: data[index]['idx'],
                                    typePoint: data[index]['typePoint'],
                                  ));
                            },
                            child: Column(
                              children: [
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Image.asset(
                                      Assets.saveAdverbox.path,
                                      package: "sdk_eums",
                                      height: 40,
                                    ),
                                    // Assets.icons.saveAdverbox.image(height: 40),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        '${data[index]['name'] ?? ''}',
                                        maxLines: 2,
                                        style: AppStyle.bold.copyWith(
                                            color: AppColor.black,
                                            fontSize: 14),
                                      ),
                                    ),
                                    // Text(
                                    //   '(소상공인 광고)',
                                    //   style: AppStyle.regular.copyWith(
                                    //       color: AppColor.black, fontSize: 14),
                                    // ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '광고 남은 기간',
                                          style: AppStyle.medium.copyWith(
                                              color: AppColor.grey5D,
                                              fontSize: 10),
                                        ),
                                        Text(
                                          '${getDayLeft(data[index]['regist_date'])} 일',
                                          style: AppStyle.bold.copyWith(
                                              color: AppColor.black,
                                              fontSize: 16),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Divider(),
                              ],
                            ),
                          );
                        }),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  int getDayLeft(String? dateTo) {
    if (dateTo != null && dateTo.isNotEmpty) {
      DateTime parseDtForm = DateTime.now().toLocal();
      DateTime parseDtTo = DateTime.parse(dateTo).toLocal();
      DateTime dateTime = DateTime(
        parseDtTo.year,
        parseDtTo.month,
        parseDtTo.day + 2,
        parseDtTo.hour,
        parseDtTo.minute,
        parseDtTo.second,
        parseDtTo.millisecond,
        parseDtTo.microsecond,
      );

      return dateTime.difference(parseDtForm).inDays > 1
          ? dateTime.difference(parseDtForm).inDays
          : dateTime.day - parseDtForm.day;
    } else {
      return -1;
    }
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(seconds: 0));
    refreshController.refreshCompleted();
    setState(() {});
    _fetchData();
  }

  _fetchData() async {
    globalKey.currentContext
        ?.read<KeepAdverboxBloc>()
        .add(KeepAdverbox(limit: Constants.LIMIT_DATA));
  }

  void _onLoading() async {
    await Future.delayed(const Duration(seconds: 0));
    refreshController.loadComplete();
    _fetchDataLoadMore();
  }

  _fetchDataLoadMore({int? offset, int? type}) async {
    // context.read<RequestBloc>().add(ListInquire(
    //     offset: offset,
    //     limit: Constants.LIMIT_DATA,
    //     type: this.idCategory,
    //     authenticationStatus: status));
  }
}

class DetailKeepScreen extends StatefulWidget {
  const DetailKeepScreen({Key? key, this.url, this.id, this.typePoint})
      : super(key: key);

  final String? url;
  final dynamic id;
  final dynamic typePoint;

  @override
  State<DetailKeepScreen> createState() => _DetailKeepScreenState();
}

class _DetailKeepScreenState extends State<DetailKeepScreen> {
  final GlobalKey<State<StatefulWidget>> globalKey =
      GlobalKey<State<StatefulWidget>>();
  FToast fToast = FToast();

  @override
  void initState() {
    fToast.init(context);
    // TODO: implement initStat
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KeepAdverboxBloc>(
        create: (context) =>
            KeepAdverboxBloc()..add(KeepAdverbox(limit: Constants.LIMIT_DATA)),
        child: MultiBlocListener(listeners: [
          BlocListener<KeepAdverboxBloc, KeepAdverboxState>(
            listenWhen: (previous, current) =>
                previous.deleteKeepStatus != current.deleteKeepStatus,
            listener: _listenFetchData,
          ),
          BlocListener<KeepAdverboxBloc, KeepAdverboxState>(
            listenWhen: (previous, current) =>
                previous.adverKeepStatus != current.adverKeepStatus,
            listener: _listenPointFetchData,
          ),
        ], child: _buildContent(context)));
  }

  void _listenPointFetchData(BuildContext context, KeepAdverboxState state) {
    if (state.adverKeepStatus == AdverKeepStatus.loading) {
      EasyLoading.show();
      return;
    }
    if (state.adverKeepStatus == AdverKeepStatus.failure) {
      EasyLoading.dismiss();
      return;
    }
    if (state.adverKeepStatus == AdverKeepStatus.success) {
      globalKey.currentContext?.read<SettingBloc>().add(InfoUser());
      EasyLoading.dismiss();
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  void _listenFetchData(BuildContext context, KeepAdverboxState state) {
    if (state.deleteKeepStatus == DeleteKeepStatus.loading) {
      EasyLoading.show();
      return;
    }
    if (state.deleteKeepStatus == DeleteKeepStatus.failure) {
      EasyLoading.dismiss();
      return;
    }
    if (state.deleteKeepStatus == DeleteKeepStatus.success) {
      RxBus.post(RefreshDataKeep());
      EasyLoading.dismiss();
      Navigator.pop(context);
      AppAlert.showSuccess(context, fToast, "Success");
    }
  }

  _buildContent(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: CustomWebView(
        urlLink: widget.url,
        title: AppString.saveAdvertisement,
        color: AppColor.red,
        colorIconBack: AppColor.white,
        showMission: true,
        onSave: () {
          globalKey.currentContext
              ?.read<KeepAdverboxBloc>()
              .add(DeleteKeep(id: widget.id));
          setState(() {});
        },
        mission: () {
          DialogUtils.showDialogSucessPoint(context, voidCallback: () {
            print("vaop day${widget.id}");
            globalKey.currentContext?.read<KeepAdverboxBloc>().add(EarnPoin(
                advertise_idx: widget.id, pointType: widget.typePoint));
          });
        },
      ),
    );
  }
}
