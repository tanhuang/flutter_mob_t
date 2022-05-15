#import "FlutterMobTPlugin.h"
#import <SMS_SDK/SMSSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareSheetConfiguration.h>

@implementation FlutterMobTPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_mob_t"
                                     binaryMessenger:[registrar messenger]];
    FlutterMobPlugin* instance = [[FlutterMobPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method]) {
        result(@"");
    } else if ([@"getCode" isEqualToString:call.method]) {
        NSDictionary* argsMap = call.arguments;
        NSString *phone = argsMap[@"phone"];
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:@"86" template:@"" result:^(NSError *error) {
            if (!error) {
                NSDictionary *dic = @{@"status":@0,@"msg":@"success",};
                result(dic);
            } else {
                NSDictionary *dic = @{@"status":@1,@"msg":error.userInfo[@"description"],};
                result(dic);
            }
        }];
    } else if ([@"commitCode" isEqualToString:call.method]) {
        NSDictionary* argsMap = call.arguments;
        NSString *phone = argsMap[@"phone"];
        NSString *code = argsMap[@"code"];
        [SMSSDK commitVerificationCode:code phoneNumber:phone zone:@"86" result:^(NSError *error) {
            if (!error) {
                NSDictionary *dic = @{@"status":@0,@"msg":@"success",};
                result(dic);
            } else {
                NSDictionary *dic = @{@"status":@1,@"msg":error.userInfo[@"description"],};
                result(dic);
            }
        }];
    } else if ([@"register" isEqualToString:call.method]) {
        [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
            [call.arguments enumerateKeysAndObjectsUsingBlock:^(id key, NSDictionary *obj, BOOL * _Nonnull stop) {
                [platformsRegister.platformsInfo setObject:obj.mutableCopy forKey:[NSString stringWithFormat:@"%@",key]];
            }];
        }];
    } else if ([@"auth" isEqualToString:call.method]) {
        NSInteger type = [call.arguments integerValue];
        [ShareSDK authorize:type settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            if (state == SSDKResponseStateSuccess) {
                NSLog(@"%@",user.rawData);
                NSDictionary *data = @{@"uid":user.uid, @"nickname":user.nickname, @"icon":user.icon};
                NSDictionary *dic = @{@"status":@0, @"msg":@"success", @"data":data};
                result(dic);
            } else if (state == SSDKResponseStateFail) {
                NSDictionary *dic = @{@"status":@1, @"msg":error.userInfo[@"description"]};
                result(dic);
            } else if (state == SSDKResponseStateCancel) {
                NSDictionary *dic = @{@"status":@2, @"msg":@"cancel"};
                result(dic);
            }
        }];
    } else if ([@"share" isEqualToString:call.method]) {
        NSDictionary* argsMap = call.arguments;
        NSString *title = argsMap[@"title"];
        NSString *text = argsMap[@"text"];
        NSString *imagePath = argsMap[@"imagePath"];
        NSString *url = argsMap[@"url"];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:text
                                         images:imagePath
                                            url:[NSURL URLWithString:url]
                                          title:title
                                           type:SSDKContentTypeAuto];
        SSUIShareSheetConfiguration *config = [[SSUIShareSheetConfiguration alloc] init];
        [ShareSDK showShareActionSheet:nil
                           customItems:@[@(SSDKPlatformSubTypeWechatSession),
                                         @(SSDKPlatformSubTypeWechatTimeline),
                                         @(SSDKPlatformSubTypeQQFriend),
                                         @(SSDKPlatformTypeSinaWeibo)]
                           shareParams:shareParams
                    sheetConfiguration:config
                        onStateChanged:^(SSDKResponseState state,
                                         SSDKPlatformType platformType,
                                         NSDictionary *userData,
                                         SSDKContentEntity *contentEntity,
                                         NSError *error,
                                         BOOL end) {
         }];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
