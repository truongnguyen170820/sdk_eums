import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sdk_eums/api_eums_offer_wall/eums_offer_wall_service.dart';
import 'package:sdk_eums/api_eums_offer_wall/eums_offer_wall_service_api.dart';

import '../../common/local_store/local_store.dart';
import '../../common/local_store/local_store_service.dart';
import '../../common/rx_bus.dart';
import '../bloc/authentication_bloc/authentication_bloc.dart';
import '../bloc/push_notification_service/bloc/push_notification_service_bloc.dart';
import '../bloc/setting_bloc/bloc/setting_bloc.dart';
import 'accumulate_money_module/accumulate_money_screen.dart';

void mainApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
  ));
  // EasyLoadingCustom.initConfigLoading();
  runApp(MyHomePage(
    eumsOfferWallService: EumsOfferWallServiceApi(),
    localStore: LocalStoreService(),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.localStore,
    required this.eumsOfferWallService,
  }) : super(key: key);
  final LocalStore localStore;
  final EumsOfferWallService eumsOfferWallService;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  Timer? _timer;
  int _start = 10;

  @override
  void initState() {

    _registerEventBus();
    // checkPermission();

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // checkPermission() async {
  //   final bool status = await FlutterOverlayWindow.isPermissionGranted();

  //   if (!status) {
  //     await FlutterOverlayWindow.requestPermission();
  //   } else {}
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _registerEventBus() async {
    // RxBus.register<TestBus>().listen((event) {});

    // RxBus.register<ShowDataAdver>(tag: Constants.showDataAdver)
    //     .listen((event) {});
  }

  void _unregisterEventBus() {
    RxBus.destroy();
  }

  @override
  void dispose() {
    _unregisterEventBus();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LocalStore>(create: (context) => widget.localStore),
        RepositoryProvider<EumsOfferWallService>(
            create: (context) => widget.eumsOfferWallService),
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
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                // theme: AppThemes().themData(context),
                home: AccumulateMoneyScreen(),
                builder: EasyLoading.init(builder: (context, child) {
                  return child ?? const SizedBox.shrink();
                }),
              ),
            ),
          )),
    );
  }
}
