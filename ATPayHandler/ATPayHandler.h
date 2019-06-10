//
//  ATPayHandler.h
//  ATPayHandler
//  https://github.com/ablettchen/ATPayHandler
//
//  Created by ablett on 06/06/2019.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATWechatPayProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class BaseResp;
@interface ATPayHandler : NSObject

- (void)aliPay:(NSString *)order
    fromScheme:(NSString *)schemeStr
    completion:(void(^)(NSError *error, NSDictionary *result))completion;

- (void)wechatPay:(id<ATWechatPayProtocol>)order
       completion:(void(^)(NSError *error, BaseResp *result))completion;

- (BOOL)alipayHandleOpenURL:(NSURL *)url;
- (BOOL)wechatPayHandleOpenURL:(NSURL *)url;

+ (ATPayHandler *)defaultHandler;

@end

NS_ASSUME_NONNULL_END
