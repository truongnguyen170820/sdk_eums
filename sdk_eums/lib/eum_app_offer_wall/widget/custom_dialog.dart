import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sdk_eums/common/routing.dart';
import 'package:sdk_eums/eum_app_offer_wall/utils/appStyle.dart';
import 'package:sdk_eums/gen/assets.gen.dart';

import '../utils/appColor.dart';

class DialogUtils {
  static void showDialogMissingPoint(BuildContext context, {dynamic data}) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return Dialog(
            insetPadding: EdgeInsets.all(0),
            insetAnimationCurve: Curves.bounceIn,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8)),
                  child: Stack(
                    children: [
                      Center(
                        child: Text('+ $data캐시',
                            style: AppStyle.bold.copyWith(
                                color: AppColor.orange4, fontSize: 24)),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: GestureDetector(
                          onTap: () {
                            Routing().popToRoot(context);
                          },
                          child: const Icon(Icons.close,
                              color: AppColor.white, size: 24),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  static void showDialogSucessPoint(BuildContext context,
      {dynamic data, VoidCallback? voidCallback}) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return Dialog(
            insetPadding: EdgeInsets.all(16),
            insetAnimationCurve: Curves.bounceIn,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Assets.icons.fireworkLeft.image(height: 40),
                          Image.asset(
                            Assets.fireworkLeft.path,
                            package: "sdk_eums",
                            height: 40,
                          ),
                          const SizedBox(width: 10),
                          RichText(
                              text: TextSpan(
                                  text: '포인트',
                                  style: AppStyle.medium
                                      .copyWith(color: AppColor.red5),
                                  children: [
                                TextSpan(
                                    text: ' 정상 적립 !',
                                    style: AppStyle.medium
                                        .copyWith(color: AppColor.black))
                              ])),
                          const SizedBox(width: 10),
                          Image.asset(
                            Assets.fireworkRight.path,
                            package: "sdk_eums",
                            height: 40,
                          )
                          // Assets.icons.fireworkRight.image(height: 40)
                        ],
                      ),
                      const SizedBox(height: 16),
                      CachedNetworkImage(
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                          imageUrl: '',
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) {
                            return Image.asset(
                              Assets.logo.path,
                              package: "sdk_eums",
                              height: 200,
                            );
                            // Assets.icons.logo.image(height: 200);
                          }),
                      const SizedBox(height: 16),
                      Text(
                        '중소상공인의 광고를 후원해 주셨습니다.',
                        style: AppStyle.medium.copyWith(color: AppColor.black),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: voidCallback,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColor.yellow,
                          ),
                          child: Text(
                            '확인',
                            style:
                                AppStyle.medium.copyWith(color: AppColor.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        });
  }
}
