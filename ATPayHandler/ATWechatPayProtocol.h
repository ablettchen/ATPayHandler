//
//  ATWechatPayProtocol.h
//  ATPayHandler
//
//  Created by ablett on 2019/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ATWechatPayProtocol <NSObject>
@property (copy, nonatomic) NSString *openID;       ///< 平台标识
@property (nonatomic, copy) NSString *partnerId;    ///< 商家向财付通申请的商家id
@property (nonatomic, copy) NSString *prepayId;     ///< 预支付订单
@property (nonatomic, copy) NSString *nonceStr;     ///< 随机串，防重发
@property (nonatomic, assign) UInt32 timeStamp;     ///< 时间戳，防重发
@property (nonatomic, copy) NSString *package;      ///< 商家根据财付通文档填写的数据和签名
@property (nonatomic, copy) NSString *sign;         ///< 商家根据微信开放平台文档对数据做的签名
@end

NS_ASSUME_NONNULL_END
