//
//  ATPayHandler.m
//  ATPayHandler
//  https://github.com/ablettchen/ATPayHandler
//
//  Created by ablett on 06/06/2019.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATPayHandler.h"
#if __has_include(<ATCategories/ATCategories.h>)
#import <ATCategories/ATCategories.h>
#else
#import "ATCategories.h"
#endif

#if __has_include(<AlipaySDK/AlipaySDK.h>)
#import <AlipaySDK/AlipaySDK.h>
#else
#import "AlipaySDK.h"
#endif

#if __has_include(<WechatOpenSDK/WXApi.h>)
#import <WechatOpenSDK/WXApi.h>
#else
#import "WXApi.h"
#endif


@interface ATPayHandler ()<WXApiDelegate>
@property (copy, nonatomic) void(^aliPayCompletion)(NSError *error, NSDictionary *result);
@property (copy, nonatomic) void(^wechatPayCompletion)(NSError *error, BaseResp *result);
@end

@implementation ATPayHandler

#pragma mark - LifeCycle

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - Privite

- (void)handleWechatResp:(BaseResp *)resp {
    if(![resp isKindOfClass:[PayResp class]]){return;}
    if (resp.errCode == 0) {
        if (self.wechatPayCompletion) {self.wechatPayCompletion(nil, resp);}
        return;
    }
    NSString *msg = (resp.errCode == -2)?@"已取消":resp.errStr;
    NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:resp.errCode
                                     userInfo:@{NSLocalizedDescriptionKey:msg}];
    if (self.wechatPayCompletion) {self.wechatPayCompletion(error, nil);}
}

- (void)handleAlipayResult:(NSDictionary *)result {
    int resultStatus = [result[@"resultStatus"] intValue];
    if (resultStatus == 9000) {
        if (self.aliPayCompletion) {self.aliPayCompletion(nil, result);}
        return;
    }
    NSString *msg = @"支付失败";
    if (resultStatus == 8000) {
        msg = @"处理中";
    }else if (resultStatus == 6001) {
        msg = @"已取消";
    }else if (resultStatus == 6002) {
        msg = @"网络连接出错";
    }
    NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:resultStatus
                                     userInfo:@{NSLocalizedDescriptionKey:msg}];
    if (self.aliPayCompletion) {self.aliPayCompletion(error, nil);}
}

#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp {
    [self handleWechatResp:resp];
}

#pragma mark - Public

- (void)aliPay:(NSString *)order
    fromScheme:(NSString *)schemeStr
    completion:(void(^)(NSError *error, NSDictionary *result))completion {
    self.aliPayCompletion = completion;
    /*! 支付宝 WAP 页走该回调 */
    @weakify(self);
    [[AlipaySDK defaultService] payOrder:order
                              fromScheme:schemeStr
                                callback:^(NSDictionary *resultDic) {
                                    @strongify(self);
                                    [self handleAlipayResult:resultDic];
                                }];
    
}

- (void)wechatPay:(id<ATWechatPayProtocol>)order completion:(void(^)(NSError *error, BaseResp *result))completion {
    self.wechatPayCompletion = completion;
    PayReq *payReq           = [[PayReq alloc] init];
    payReq.openID            = order.openID;
    payReq.partnerId         = order.partnerId;
    payReq.prepayId          = order.prepayId;
    payReq.package           = order.package;
    payReq.nonceStr          = order.nonceStr;
    payReq.timeStamp         = order.timeStamp;
    payReq.sign              = order.sign;
    [WXApi sendReq:payReq];
}

- (BOOL)alipayHandleOpenURL:(NSURL *)url {
    if (![url.host isEqualToString:@"safepay"]) {return NO;}
    /*! 支付宝钱包 app 走该回调 */
    @weakify(self);
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        @strongify(self);
        /// 处理回调结果
        [self handleAlipayResult:resultDic];
    }];
    return YES;
}

- (BOOL)wechatPayHandleOpenURL:(NSURL *)url {
    if ([WXApi handleOpenURL:url delegate:self]) {return YES;}
    return NO;
}

static ATPayHandler *sharedInstance = nil;

+ (ATPayHandler *)defaultHandler {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
