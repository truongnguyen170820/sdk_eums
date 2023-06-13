import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sdk_eums/common/constants.dart';
import 'package:sdk_eums/common/events/events.dart';
import 'package:sdk_eums/common/routing.dart';
import 'package:sdk_eums/common/rx_bus.dart';
import 'package:sdk_eums/eum_app_offer_wall/screen/detail_offwall_module/bloc/detail_offwall_bloc.dart';
import 'package:sdk_eums/eum_app_offer_wall/screen/register_link_module/register_link_screen.dart';
import 'package:sdk_eums/eum_app_offer_wall/widget/app_alert.dart';
import 'package:sdk_eums/gen/assets.gen.dart';
import 'package:sdk_eums/gen/fonts.gen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/setting_bloc/bloc/setting_bloc.dart';
import '../../utils/appColor.dart';
import '../../utils/appStyle.dart';
import '../../utils/app_string.dart';
import '../../widget/custom_dialog.dart';
import '../request_module/request_screen.dart';

class DetailOffWallScreen extends StatefulWidget {
  const DetailOffWallScreen({Key? key, this.xId, this.type}) : super(key: key);

  final dynamic xId;
  final dynamic type;

  @override
  State<DetailOffWallScreen> createState() => _DetailOffWallScreenState();
}

class _DetailOffWallScreenState extends State<DetailOffWallScreen>
    with WidgetsBindingObserver {
  final GlobalKey<State<StatefulWidget>> globalKey =
      GlobalKey<State<StatefulWidget>>();
  FToast fToast = FToast();
  dynamic point;
  dynamic urlApi;

  checkInstallApp() async {
    Uri uri = Uri.parse(urlApi);
    bool isInstalled =
        await DeviceApps.isAppInstalled(uri.queryParameters['id'] ?? '');
    if (isInstalled == false) {
      launch(urlApi);
    } else {
      // ignore: use_build_context_synchronously
      AppAlert.showError(context,fToast, '이미 설치되어 있는 앱은 참여불가능합니다');
    }
  }

  @override
  void initState() {
    _registerEventBus();
    fToast.init(context);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _registerEventBus() async {
    RxBus.register<PushLinkImage>().listen((event) {});
  }

  check() async {
    Uri uri = Uri.parse(urlApi);
    List<Application> apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true, includeSystemApps: true);
    apps.forEach((app) {
      if (app.packageName == uri.queryParameters['id']) {
        globalKey.currentContext
            ?.read<DetailOffWallBloc>()
            .add(MissionCompleteOfferWall(xId: widget.xId));
      }

      // TODO Backend operation
    });
  }

  void _unregisterEventBus() {
    RxBus.destroy();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _unregisterEventBus();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (widget.type == 'install') {
        check();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailOffWallBloc>(
      create: (context) =>
          DetailOffWallBloc()..add(DetailOffWal(xId: widget.xId)),
      child: MultiBlocListener(
        listeners: [
          BlocListener<DetailOffWallBloc, DetailOffWallState>(
            listener: _listenerDetailOffWall,
          ),
          BlocListener<DetailOffWallBloc, DetailOffWallState>(
            listener: _listenerMissionOffWall,
          )
        ],
        child: _buildContent(context),
      ),
    );
  }

  _listenerMissionOffWall(
      BuildContext context, DetailOffWallState state) async {
    if (state.missionCompleteOfferWallStatus ==
        MissionCompleteOfferWallStatus.loading) {
      EasyLoading.show();
      return;
    }

    if (state.missionCompleteOfferWallStatus ==
        MissionCompleteOfferWallStatus.failure) {
      EasyLoading.dismiss();
      return;
    }
    if (state.missionCompleteOfferWallStatus ==
        MissionCompleteOfferWallStatus.success) {
      context.read<SettingBloc>().add(InfoUser());
      EasyLoading.dismiss();
      DialogUtils.showDialogMissingPoint(context, data: point);
    }
  }

  _listenerDetailOffWall(BuildContext context, DetailOffWallState state) async {
    if (state.detailOffWallStatus == DetailOffWallStatus.loading) {
      EasyLoading.show();
      return;
    }

    if (state.detailOffWallStatus == DetailOffWallStatus.failure) {
      EasyLoading.dismiss();
      return;
    }
    if (state.detailOffWallStatus == DetailOffWallStatus.success) {
      EasyLoading.dismiss();
    }
  }

  Scaffold _buildContent(BuildContext context) {
    return Scaffold(
        key: globalKey,
        backgroundColor: AppColor.colorF4,
        appBar: AppBar(
          backgroundColor: AppColor.colorF4,
          elevation: 1,
          centerTitle: true,
          title: Text(AppString.earnCash,
              style:
                  AppStyle.bold.copyWith(fontSize: 16, color: AppColor.black)),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios_outlined,
                color: AppColor.dark, size: 25),
          ),
        ),
        body: BlocBuilder<DetailOffWallBloc, DetailOffWallState>(
          builder: (context, state) {
            if (state.dataDetailOffWall != null) {
              point = state.dataDetailOffWall['reward'] ?? 0;
              urlApi = state.dataDetailOffWall['api'] ?? '';
            }
            return state.dataDetailOffWall == null
                ? SizedBox()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                                imageUrl: state.dataDetailOffWall != null
                                    ? "${Constants.baseUrlImage}${state.dataDetailOffWall['thumbnail']}"
                                    : "",
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) {
                                  return Assets.logo.image();
                                }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(
                                  state.dataDetailOffWall != null
                                      ? state.dataDetailOffWall['title']
                                      : "",
                                  maxLines: 1,
                                  style: AppStyle.medium.copyWith(
                                      height: 2,
                                      fontSize: 16,
                                      fontFamily: FontFamily.notoSansKR),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                Constants.formatMoney(
                                    state.dataDetailOffWall != null
                                        ? state.dataDetailOffWall['reward']
                                        : 0,
                                    suffix: '캐시'),
                                style: AppStyle.bold.copyWith(
                                    fontSize: 18, color: AppColor.orange1),
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          color: AppColor.colorC9,
                          thickness: 8,
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            if (widget.type == 'install') {
                              checkInstallApp();
                            } else if (widget.type == 'execute' ||
                                widget.type == 'subscribe' ||
                                widget.type == 'join') {
                              Routing().navigate(
                                  context,
                                  RegisterLinkScreen(
                                    data: state.dataDetailOffWall,
                                  ));
                            } else if (widget.type == 'shopping') {}
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColor.yellow),
                            child: Text(
                              AppString.joinAndGetCash,
                              style: AppStyle.bold.copyWith(
                                  fontSize: 16, color: AppColor.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(
                            '적립 방법',
                            style: AppStyle.bold
                                .copyWith(fontSize: 18, color: AppColor.black),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: buidlHtml(
                                html: state.dataDetailOffWall != null
                                    ? state.dataDetailOffWall['description']
                                    : '')),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          color: AppColor.colorC9.withOpacity(0.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '적립 방법',
                                style: AppStyle.bold.copyWith(
                                    fontSize: 18, color: AppColor.black),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: buidlHtml(
                                    html: state.dataDetailOffWall != null
                                        ? state.dataDetailOffWall['precaution']
                                        : ''),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Routing().navigate(context, RequestScreen());
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColor.colorC9.withOpacity(0.5)),
                            child: Text(
                              AppString.earningInquiry,
                              style: AppStyle.medium.copyWith(
                                  fontSize: 16, color: AppColor.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
          },
        ));
  }

  buidlHtml({String? html}) {
    return HtmlWidget(
      html ?? '',
      customStylesBuilder: (e) {
        if (e.classes.contains('ql-align-center')) {
          return {'text-align': 'center'};
        }

        return null;
      },
    );
  }
}
