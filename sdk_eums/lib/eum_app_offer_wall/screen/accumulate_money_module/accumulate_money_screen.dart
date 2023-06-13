import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sdk_eums/common/events/rx_events.dart';
import 'package:sdk_eums/common/local_store/local_store.dart';
import 'package:sdk_eums/common/local_store/local_store_service.dart';
import 'package:sdk_eums/eum_app_offer_wall/screen/asked_question_module/asked_question_screen.dart';
import 'package:sdk_eums/eum_app_offer_wall/screen/detail_offwall_module/detail_offwall_screen.dart';
import 'package:sdk_eums/eum_app_offer_wall/screen/earn_cash_module/earn_cash_screen.dart';
import 'package:sdk_eums/eum_app_offer_wall/screen/keep_adverbox_module/keep_adverbox_module.dart';
import 'package:sdk_eums/eum_app_offer_wall/screen/link_addvertising_module/link_addvertising_screen.dart';
import 'package:sdk_eums/eum_app_offer_wall/screen/request_module/request_screen.dart';
import 'package:sdk_eums/eum_app_offer_wall/screen/using_term_module/using_term_screen.dart';
import 'package:sdk_eums/eum_app_offer_wall/utils/appStyle.dart';
import 'package:sdk_eums/gen/assets.gen.dart';

import '../../../common/constants.dart';
import '../../../common/routing.dart';
import '../../../common/rx_bus.dart';
import '../../../gen/fonts.gen.dart';
import '../../bloc/push_notification_service/bloc/push_notification_service_bloc.dart';
import '../../bloc/setting_bloc/setting.dart';
import '../../utils/appColor.dart';
import '../../utils/app_string.dart';
import '../charging_station_module/charging_station_screen.dart';
import '../reward_guide_module/reward_guide_screen.dart';
import '../scrap_adverbox_module/scrap_adverbox_screen.dart';
import 'bloc/accumulate_money_bloc.dart';

class AccumulateMoneyScreen extends StatefulWidget {
  const AccumulateMoneyScreen({Key? key}) : super(key: key);

  @override
  State<AccumulateMoneyScreen> createState() => _AccumulateMoneyScreenState();
}

class _AccumulateMoneyScreenState extends State<AccumulateMoneyScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<State<StatefulWidget>> globalKey =
      GlobalKey<State<StatefulWidget>>();
  bool showAction = false;
  bool showOnOff = false;
  late TabController _tabController;
  int tabIndex = 0;
  int tabPreviousIndex = 0;
  String allMedia = '캐시높은 순';
  String? selectedStation;
  late PushNotificationServiceBloc _pushNotificationServiceBloc;
  dynamic dataAdver;
  LocalStore? localStore;
  String? filter;
  String? categary;

  @override
  void initState() {
    _registerEventBus();

    localStore = LocalStoreService();
    filter = DATA_MEDIA[0]['media'];
    _pushNotificationServiceBloc = context.read<PushNotificationServiceBloc>();
    _pushNotificationServiceBloc.add(PushNotificationSetup());
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    _tabController.addListener(() {
      tabIndex = _tabController.index;
      if (tabIndex != tabPreviousIndex) {
        if (_tabController.index == 3) {
          Routing().navigate(
              context,
              ChargingStationScreen(
                tab: tabPreviousIndex,
              ));
        } else {
          switch (_tabController.index) {
            case 0:
              categary = null;
              break;
            case 1:
              categary = 'mission';
              break;
            case 2:
              categary = 'participation';
              break;
            default:
          }

          setState(() {});
        }
        _fetchData();
      }
      tabPreviousIndex = _tabController.index;
    });
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    // checkOnOfAdver();
    // startTimer();
  }

  Future<void> _registerEventBus() async {
    RxBus.register<ShowAction>().listen((event) {
      if (showAction) {
        setState(() {
          showAction = false;
        });
      }
    });

    RxBus.register<BackToTab>().listen((event) {
      print("vào đây không");
      setState(() {
        _tabController.animateTo(0);
      });
    });

    _fetchData();
  }

  void _unregisterEventBus() {
    RxBus.destroy();
  }

  // checkOnOfAdver() async {
  //   showOnOff = await localStore!.getSaveAdver();

  //   setState(() {});
  // }

  Timer? _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
          if (_start == 0) {
            // _start = 10;
            // globalKey.currentContext
            //     ?.read<AccumulateMoneyBloc>()
            //     .add(AccumulateMoneyList());
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    // _unregisterEventBus();
    super.dispose();
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
      if (Platform.isAndroid) {
        // FlutterOverlayWindow.isActive();
        // FlutterOverlayWindow.showOverlay(
        //     overlayTitle: "EUMs",
        //     overlayContent: "con cac",
        //     height: WindowSize.fullCover,
        //     width: WindowSize.fullCover);
      } else if (Platform.isIOS) {
        // EasyLoading.dismiss();
        // WidgetKit.setItem(
        //     'widgetData',
        //     jsonEncode(WidgetData('${state.dataAccumulateMoney[0]['title']}',
        //         '${Constants.baseUrlImage}${state.dataAccumulateMoney[0]['sponser_image']}')),
        //     'group.Eums');
        // WidgetKit.reloadAllTimelines();
      }
    }
  }

  void _listenNextPageOverlay(
      BuildContext context, AccumulateMoneyState state) {
    if (state.nextPageStatus == NextPageStatus.loading) {
      EasyLoading.show();
      return;
    }
    if (state.nextPageStatus == NextPageStatus.failure) {
      EasyLoading.dismiss();
      return;
    }
    if (state.nextPageStatus == NextPageStatus.success) {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccumulateMoneyBloc>(
      create: (context) => AccumulateMoneyBloc()..add(ListOfferWall()),
      child: MultiBlocListener(
          listeners: [
            BlocListener<PushNotificationServiceBloc,
                PushNotificationServiceState>(
              listener: _listenerAppPushNotification,
            ),
            BlocListener<SettingBloc, SettingState>(
              listener: _listenerSetting,
            ),
            BlocListener<AccumulateMoneyBloc, AccumulateMoneyState>(
              listener: _listenFetchData,
            ),
            BlocListener<AccumulateMoneyBloc, AccumulateMoneyState>(
              listener: _listenFetchDataList,
            ),
            BlocListener<AccumulateMoneyBloc, AccumulateMoneyState>(
              listener: _listenNextPageOverlay,
            ),
          ],
          child: GestureDetector(
            onTap: () {
              setState(() {
                showAction = false;
              });
            },
            child: Scaffold(
              key: globalKey,
              backgroundColor: AppColor.white,
              body: SafeArea(
                child: Stack(
                  children: [
                    Builder(
                      builder: (context) => Column(
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //  const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context).pop();
                                  },
                                  child: const Icon(
                                      Icons.arrow_back_ios_outlined,
                                      color: Colors.transparent,
                                      size: 20),
                                ),
                                Text('캐시적립',
                                    style: AppStyle.bold.copyWith(
                                        color: AppColor.black, fontSize: 18)),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      showAction = !showAction;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.more_vert_outlined,
                                    size: 24,
                                    color: AppColor.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColor.colorCC, width: 1)),
                            child: Column(
                              // mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      color: AppColor.colorF5,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12))),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        !showOnOff
                                            ? "벌 광고 활성화 중 입니다."
                                            : " 벌 광고 비활성화 중 입니다.",
                                        style: AppStyle.bold.copyWith(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                      const Spacer(),
                                      Text(
                                        showOnOff ? 'OFF' : 'ON',
                                        style: AppStyle.bold.copyWith(
                                            color: showOnOff
                                                ? Colors.black
                                                : AppColor.orange2,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(width: 5),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showOnOff = !showOnOff;
                                            localStore?.setSaveAdver(showOnOff);
                                            checkOnOf();
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1, vertical: 1),
                                          width: 40,
                                          decoration: BoxDecoration(
                                              color: !showOnOff
                                                  ? AppColor.orange2
                                                  : AppColor.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: !showOnOff
                                                      ? Colors.transparent
                                                      : AppColor.color70)),
                                          child: Row(
                                            children: [
                                              showOnOff
                                                  ? Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColor.color70,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              7),
                                                    )
                                                  : const SizedBox(),
                                              const Spacer(),
                                              showOnOff
                                                  ? const SizedBox()
                                                  : Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColor.white,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      child: Image.asset(
                                                        Assets.check.path,
                                                        package: "sdk_eums",
                                                        height: 7,
                                                      ), // Default: 2
                                                    ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  Assets.lineBreak.path,
                                  package: "sdk_eums",
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(Assets.historyCash.path,
                                          package: "sdk_eums", height: 72),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Routing().navigate(
                                                  context, EarnCashScreen());
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(Assets.point.path,
                                                    package: "sdk_eums",
                                                    height: 16),
                                                Text(
                                                  '  나의 캐시 적립 내역  ',
                                                  style: AppStyle.bold,
                                                ),
                                                const Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  size: 14,
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              _buildAdverBox(
                                                  callback: () {
                                                    Routing().navigate(context,
                                                        KeepAdverboxScreen());
                                                  },
                                                  icon: Image.asset(
                                                      Assets
                                                          .advertisingBox.path,
                                                      package: "sdk_eums",
                                                      height: 16),
                                                  title: AppString
                                                      .saveAdvertisement,
                                                  color: AppColor.blue1),
                                              const SizedBox(width: 8),
                                              _buildAdverBox(
                                                  callback: () {
                                                    Routing().navigate(context,
                                                        ScrapAdverBoxScreen());
                                                  },
                                                  icon: Image.asset(
                                                      Assets.advertisingScrap
                                                          .path,
                                                      package: "sdk_eums",
                                                      height: 16),
                                                  title: AppString
                                                      .systemAdvertisement,
                                                  color: AppColor.orange3)
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 16),
                              Expanded(
                                  child: TabBar(
                                indicator: const UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                      width: 3.0, color: AppColor.orange4),
                                ),
                                controller: _tabController,
                                labelPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 0),
                                isScrollable: true,
                                labelColor: AppColor.orange4,
                                indicatorColor: AppColor.orange4,
                                unselectedLabelColor: AppColor.color70,
                                labelStyle: AppStyle.bold
                                    .copyWith(color: AppColor.orange4),
                                unselectedLabelStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                                tabs: [
                                  _buildTitleTabBar(AppString.all),
                                  _buildTitleTabBar(AppString.missionType),
                                  _buildTitleTabBar(
                                      AppString.participationType),
                                  _buildTitleTabBar(AppString.chargingStation),
                                ],
                              )),
                              Container(
                                height: 35,
                                width: 100,
                                child: Center(child: _buildDropDown(context)),
                              ),
                            ],
                          ),
                          // Divider(),
                          DefaultTabController(length: 4, child: _buildTabBar())
                        ],
                      ),
                    ),
                    !showAction
                        ? SizedBox()
                        : Positioned(
                            top: MediaQuery.of(context).padding.top + 5,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Image.asset(
                                          Assets.saveAdvertise.path,
                                          package: "sdk_eums",
                                          width: 30,
                                          height: 30)),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Wrap(
                                      children: List.generate(
                                          action.length,
                                          (index) => GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    showAction = false;
                                                  });
                                                  switch (index) {
                                                    case 0:
                                                      Routing().navigate(
                                                          context,
                                                          RequestScreen());
                                                      break;
                                                    case 1:
                                                      Routing().navigate(
                                                          context,
                                                          AskedQuestionScreen());
                                                      break;
                                                    case 2:
                                                      Routing().navigate(
                                                          context,
                                                          LinkAddvertisingScreen());
                                                      break;
                                                    case 3:
                                                      Routing().navigate(
                                                          context,
                                                          RewardGuideScreen());
                                                      break;
                                                    case 4:
                                                      Routing().navigate(
                                                          context,
                                                          UsingTermScreen());
                                                      break;
                                                    default:
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: const BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: AppColor
                                                                  .colorC9))),
                                                  child: Text(
                                                    action[index],
                                                    style: AppStyle.medium
                                                        .copyWith(fontSize: 18),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  checkOnOf() async {
    if (!showOnOff) {
      _pushNotificationServiceBloc.add(PushNotificationSetup());
    } else {
      _pushNotificationServiceBloc.add(RemoveToken());
    }
  }

  Widget _buildDropDown(BuildContext context) {
    dynamic medias = DATA_MEDIA.map((item) => item['name']).toList();
    List<DropdownMenuItem<String>> items =
        medias.map<DropdownMenuItem<String>>((String? value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value ?? "",
          textAlign: TextAlign.center,
          style: AppStyle.bold.copyWith(color: AppColor.black),
          maxLines: 1,
        ),
      );
    }).toList();

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        key: GlobalKey<FormFieldState>(),
        isExpanded: true,
        dropdownColor: AppColor.white,
        value: allMedia,
        style: AppStyle.bold.copyWith(color: AppColor.black, fontSize: 14),
        hint: Text(
          allMedia,
          style: AppStyle.bold.copyWith(color: AppColor.black, fontSize: 14),
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: AppColor.black,
        ),
        items: items,
        onChanged: (value) {
          setState(() {
            allMedia = value!;
          });
          _filterMedia(value);
          // _filterMedia(value);
        },
      ),
    );
  }

  _listenerSetting(BuildContext context, SettingState state) async {
    if (state.appSettingStatus == AppSettingStatus.loading) {
      EasyLoading.show();
      return;
    }

    if (state.appSettingStatus == AppSettingStatus.failure) {
      EasyLoading.dismiss();
      return;
    }
    if (state.appSettingStatus == AppSettingStatus.success) {
      EasyLoading.dismiss();
    }
  }

  void _listenFetchDataList(BuildContext context, AccumulateMoneyState state) {
    if (state.listOfferWallStatus == ListOfferWallStatus.loading) {
      EasyLoading.show();
      return;
    }
    if (state.listOfferWallStatus == ListOfferWallStatus.failure) {
      EasyLoading.dismiss();
      return;
    }
    if (state.listOfferWallStatus == ListOfferWallStatus.success) {
      EasyLoading.dismiss();
    }
  }

  void _listenerAppPushNotification(
      BuildContext context, PushNotificationServiceState state) async {
    if (state.remoteMessage != null) {
      if (state.isForeground) {
        // show custom dialog notification and sound
        if (Platform.operatingSystem == 'android') {
          String? titleMessage = state.remoteMessage?.notification?.title;
          String? bodyMessage = state.remoteMessage?.notification?.body;
          RemoteNotification? notification = state.remoteMessage?.notification;

          _pushNotificationServiceBloc.flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              titleMessage,
              bodyMessage,
              NotificationDetails(
                android: AndroidNotificationDetails(
                    _pushNotificationServiceBloc.channel.id,
                    _pushNotificationServiceBloc.channel.name,
                    channelDescription:
                        _pushNotificationServiceBloc.channel.description,
                    playSound: true,
                    importance: Importance.max,
                    icon: '@mipmap/ic_launcher',
                    onlyAlertOnce: true),
              ));
        } else {}
      } else {
        if (Platform.isIOS) {
          // Routing().navigate(context,
          //     WatchAdverScreen(data: state.remoteMessage!.data['data']));
        }
      }
    }
  }

  _filterMedia(String? value) {
    if (value != '캐시높은 순') {
      dynamic media = (DATA_MEDIA
          .where((element) => element['name'] == value)
          .toList())[0]['media'];

      filter = media;
    } else {
      filter = DATA_MEDIA[0]['media'];
    }
    _fetchData();
  }

  _fetchData() async {
    globalKey.currentContext?.read<AccumulateMoneyBloc>().add(ListOfferWall(
        filter: filter, category: categary, limit: Constants.LIMIT_DATA));
    globalKey.currentContext?.read<SettingBloc>().add(InfoUser());
  }

  _fetchDataLoadMore({int? offset, String? categoryId}) async {
    globalKey.currentContext
        ?.read<AccumulateMoneyBloc>()
        .add(LoadmoreListOfferWall(
          filter: filter,
          category: categary,
          offset: offset,
          limit: Constants.LIMIT_DATA,
        ));
  }

  Widget _buildTabBar() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          ListViewAccumulateMoneyScreen(
            fetchData: _fetchData,
            fetchDataLoadMore: _fetchDataLoadMore,
            filter: _filterMedia,
          ),
          ListViewAccumulateMoneyScreen(
            fetchData: _fetchData,
            fetchDataLoadMore: _fetchDataLoadMore,
            filter: _filterMedia,
          ),
          ListViewAccumulateMoneyScreen(
            fetchData: _fetchData,
            fetchDataLoadMore: _fetchDataLoadMore,
            filter: _filterMedia,
          ),
          Container()
        ],
      ),
    );
  }

  Container _buildTitleTabBar(String text) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Tab(
          child: Center(
              child: Text(text,
                  style: AppStyle.bold14.copyWith(
                    fontSize: 14,
                  )))),
    );
  }

  Widget _buildAdverBox(
      {String? title,
      Widget? icon,
      required VoidCallback callback,
      Color? color}) {
    return InkWell(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon ?? const SizedBox(),
            const SizedBox(width: 5),
            Text(
              title ?? '',
              style: AppStyle.regular
                  .copyWith(fontSize: 10, color: AppColor.white),
            )
          ],
        ),
      ),
    );
  }
}

class ListViewAccumulateMoneyScreen extends StatefulWidget {
  const ListViewAccumulateMoneyScreen(
      {Key? key, this.fetchData, this.fetchDataLoadMore, this.filter})
      : super(key: key);

  final Function? fetchData;
  final Function? fetchDataLoadMore;
  final Function? filter;

  @override
  State<ListViewAccumulateMoneyScreen> createState() =>
      _ListViewAccumulateMoneyScreenState();
}

class _ListViewAccumulateMoneyScreenState
    extends State<ListViewAccumulateMoneyScreen> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  ScrollController? controller;

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    // TODO: implement initState
    super.initState();
  }

  _scrollListener() {
    if (controller?.position.userScrollDirection == ScrollDirection.reverse) {
      RxBus.post(ShowAction());
    }
    if (controller?.position.userScrollDirection == ScrollDirection.forward) {
      RxBus.post(ShowAction());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(seconds: 0));
    refreshController.refreshCompleted();
    setState(() {});
    widget.fetchData!();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(seconds: 0));
    refreshController.loadComplete();
    List<dynamic>? dataCampaign =
        context.read<AccumulateMoneyBloc>().state.dataListOfferWall;
    if (dataCampaign != null) {
      widget.fetchDataLoadMore!(offset: dataCampaign.length);
    }
  }

  _buildContent(BuildContext context) {
    return BlocBuilder<AccumulateMoneyBloc, AccumulateMoneyState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
              color: AppColor.colorF4,
              border: Border(
                  top: BorderSide(
                      color: AppColor.grey5D.withOpacity(0.2), width: 2))),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SmartRefresher(
              controller: refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              header: CustomHeader(
                builder: (BuildContext context, RefreshStatus? mode) {
                  return const Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black)));
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black)),
                          ],
                        ))
                      : SizedBox();
                },
              ),
              enablePullDown: true,
              enablePullUp: true,
              child: state.dataListOfferWall != null
                  ? ListView.builder(
                      controller: controller,
                      itemCount: state.dataListOfferWall.length,
                      itemBuilder: (context, index) {
                        return _buildItem(data: state.dataListOfferWall[index]);
                      },
                    )

                  //  Wrap(
                  //     runSpacing: 16,
                  //     children: List.generate(
                  //         state.dataListOfferWall.length,
                  //         (index) =>
                  //             _buildItem(data: state.dataListOfferWall[index])),
                  //   )
                  : const SizedBox()),
        );
      },
    );
  }

  Widget _buildItem({dynamic data}) {
    return GestureDetector(
      onTap: () {
        RxBus.post(ShowAction());
        Routing().navigate(
            context,
            DetailOffWallScreen(
              xId: data['idx'],
              type: data['type'],
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
        ),
        // decoration: Box,
        margin: const EdgeInsets.symmetric(vertical: 8),

        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,
                  imageUrl: '${Constants.baseUrlImage}${data['thumbnail']}',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) {
                    return Image.asset(Assets.saveAdvertise.path,
                        package: "sdk_eums", width: 30, height: 30);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'] ?? "",
                          maxLines: 1,
                          style: AppStyle.medium.copyWith(
                              height: 2,
                              fontSize: 16,
                              fontFamily: FontFamily.notoSansKR),
                        ),
                        Text(
                          "배달e음 첫",
                          maxLines: 1,
                          style: AppStyle.medium.copyWith(
                              height: 2,
                              fontSize: 12,
                              color: AppColor.colorF7D,
                              fontFamily: FontFamily.notoSansKR),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColor.orange4.withOpacity(0.1)),
                    child: Text(
                      Constants.formatMoney(data['reward'], suffix: '캐시'),
                      style: AppStyle.bold
                          .copyWith(fontSize: 18, color: AppColor.orange1),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

List action = [
  '1:1문의',
  '자주 묻는 질문',
  '제휴 및 광고 문의',
  '적립 사용 설명서',
  '이용약관',
];
