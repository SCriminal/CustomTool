//
//  GlobalMethod+ExchangeModelToJson.h
//  Json2ObjFile
//
//  Created by 隋林栋 on 2017/8/14.
//  Copyright © 2017年 YunFeng. All rights reserved.
//

#import "GlobalMethod.h"

/*
 @property (nonatomic, strong) NSString *certificateUrl;
 @property (nonatomic, strong) ModelAddress *location;
 @property (nonatomic, assign) NSString *birthday;
 @property (nonatomic, strong) NSString *weChat;
 @property (nonatomic, strong) NSString *logoUrl;
 @property (nonatomic, assign) double gender;
 @property (nonatomic, strong) ModelAddress *natives;
 @property (nonatomic, strong) NSString *initial;
 @property (nonatomic, assign) double identityIdentification;
 @property (nonatomic, strong) NSString *name;//name
 @property (nonatomic, strong) NSString *idCardFrontUrl;
 */
@interface GlobalMethod (ExchangeModelToJson)
//转换请求数据
+ (NSString *)exchangeModeltoJson:(NSString *)str;
@end
