package com.example.sdk_eums

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.widget.Toast
import androidx.annotation.NonNull
import com.fpang.lib.FpangSession
import com.igaworks.adpopcorn.Adpopcorn
import com.kyad.adlibrary.AppAllOfferwallSDK
import com.kyad.adlibrary.AppAllOfferwallSDK.AppAllOfferwallSDKListener
import com.nextapps.naswall.NASWall
import com.ohc.ohccharge.OhcChargeActivity
import com.tnkfactory.ad.AdListType
import com.tnkfactory.ad.TnkSession
import com.yanzhenjie.permission.AndPermission
import com.yanzhenjie.permission.PermissionListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kr.ive.offerwall_sdk.IveOfferwall


/** SdkEumsPlugin */
class SdkEumsPlugin: FlutterPlugin, MethodCallHandler, ActivityAware{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var activity:Activity




  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sdk_eums")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
      Adpopcorn.setUserId(context , "abeetest")
    //   AndPermission.with(context)
    //       .requestCode(300)
    //       .permission(
    //           Manifest.permission.READ_PHONE_STATE,
    //           Manifest.permission.GET_ACCOUNTS
    //       )
    //       .callback(permissionListener)
    //       .start()

  }

    // private val permissionListener: PermissionListener = object : PermissionListener {
    //     override fun onSucceed(requestCode: Int, @NonNull grantPermissions: List<String>) {
    //         if (requestCode == 300) {
    //             AppAllOfferwallSDK.getInstance().initOfferWall(activity, "1251d48b4dded2649324974594a27e7bd84cac68", "abeeTest")
    //         }
    //     }

    //     override fun onFailed(requestCode: Int, @NonNull deniedPermissions: List<String>) {
    //         // Failure.
    //         if (requestCode == 300) {
    //             //finish();
    //         }
    //     }
    // }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
     if(call.method == "adsync"){
       FpangSession.showAdsyncList(activity, "무료충전소")
     }
      if(call.method == "Adpopcorn"){
        Adpopcorn.openOfferWall(context)
     }
        if(call.method == "appall"){
            AppAllOfferwallSDK.getInstance().showAppAllOfferwall(activity)
        }
        if(call.method == "ohc"){
            val intent = Intent(
                context,
                OhcChargeActivity::class.java
            )
            intent.putExtra("mId", "abee")
            intent.putExtra("etc2","abeetest")
            intent.putExtra("etc3", "")
            intent.putExtra("age", "")
            intent.putExtra("gender", "")
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
        }
        if(call.method == "mafin"){
            NASWall.open(activity , "abeeTest")
        }
        if(call.method == "tkn"){
            TnkSession.showAdListByType(activity, AdListType.ALL, AdListType.PPI, AdListType.CPS);
        }
        if(call.method == "iveKorea"){
            IveOfferwall.openActivity(activity , IveOfferwall.UserData("abeeglobal@abee.co.kr"))
        }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)

  }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        NASWall.init(this.activity, false)

        TnkSession.setUserName(this.activity, "abeeglobal")
        TnkSession.applicationStarted(this.activity)
        TnkSession.setCOPPA(this.activity, false)
        FpangSession.init(activity)
        FpangSession.setUserId("abee997") // 사용자 ID 설정
        FpangSession.setDebug(true) // 배포시 false 로 설정
        FpangSession.setAge(25) // 0 이면 값없음
        FpangSession.setGender("M")



    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }



    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }

    // override fun AppAllOfferwallSDKCallback(p0: Int) {
    //     when (p0) {
    //         AppAllOfferwallSDK.AppAllOfferwallSDK_SUCCES -> Toast.makeText(
    //             context,
    //             "성공",
    //             Toast.LENGTH_SHORT
    //         ).show()

    //         AppAllOfferwallSDK.AppAllOfferwallSDK_INVALID_USER_ID -> Toast.makeText(
    //             context,
    //             "잘못 된 유저아이디입니다.",
    //             Toast.LENGTH_SHORT
    //         ).show()

    //         AppAllOfferwallSDK.AppAllOfferwallSDK_INVALID_KEY -> Toast.makeText(
    //             context,
    //             "오퍼월 KEY를 확인해주세요.",
    //             Toast.LENGTH_SHORT
    //         ).show()

    //         AppAllOfferwallSDK.AppAllOfferwallSDK_NOT_GET_ADID -> Toast.makeText(
    //             context,
    //             "고객님의 폰으로는 무료충전소를 이용하실 수 없습니다. 고객센터에 문의해주세요.",
    //             Toast.LENGTH_SHORT
    //         ).show()
    //     }
    // }


}
