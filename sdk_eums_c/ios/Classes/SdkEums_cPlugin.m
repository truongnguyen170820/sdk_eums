#import "SdkEums_cPlugin.h"
//
#import <AdPopcornOfferwall/AdPopcornOfferwall.h>
#import <AdPopcornOfferwall/AdPopcornStyle.h>
#import <AdPopcornOfferwall/RewardInfo.h>
#import <AdPopcornOfferwall/APError.h>
#import <AdPopcornOfferwall/AdPopcornAdListViewController.h>
#import <AdPopcornOfferwall/AdPopcornNativeRewardCPM.h>
#import <AdSupport/AdSupport.h>
#import "adsync2.h"
#import <UIKit/UIKit.h>


@implementation SdkEums_cPlugin



+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"sdk_eums_c"
                                     binaryMessenger:[registrar messenger]];
    SdkEums_cPlugin* instance = [[SdkEums_cPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    FlutterViewController *controller = (FlutterViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }
    if ([@"Adsync" isEqualToString:call.method]) {
        @try {
            adsync2 *adsync = [adsync2 sharedManager];
            [adsync redraw];
            adsync.title = @"포인트 충전";
            adsync.parent=controller;
            adsync.isDevelopeMode = FALSE;
            [adsync closeOfferwall];
            
            CGFloat nWidth = [[UIScreen mainScreen] bounds].size.width; CGFloat nHeight = [[UIScreen mainScreen] bounds].size.height;
            [ adsync openOfferwallWithframe:CGRectMake(0, nHeight*0.15, nWidth, nHeight) partner_id:@"15395-20230512-801" cust_id:@"abee997"
                                  newWindow:YES];
            
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
    }
    if ([@"Adpopcorn" isEqualToString:call.method]) {
        
        [AdPopcornOfferwall initialize];
        [AdPopcornOfferwall setAppKey:@"862529194" andHashKey:@"3538bf14739f419f"];
        [AdPopcornOfferwall setUserId:@"abeetest"];
        [AdPopcornOfferwall setLogLevel:AdPopcornOfferwallLogTrace];
        [AdPopcornOfferwall shared].useIgaworksRewardServer= false;
        
        @try {
            
            
            [AdPopcornOfferwall openOfferWallWithViewController: controller delegate:self userDataDictionaryForFilter:nil];
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

//#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@end


