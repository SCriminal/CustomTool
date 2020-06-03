//
//  GlobalMethod+MicroServiceApiExchange.h
//  Json2ObjFile
//
//  Created by 隋林栋 on 2018/3/6.
//  Copyright © 2018年 YunFeng. All rights reserved.
//

#import "GlobalMethod.h"
//header
#import "RequestHeader.h"
static NSString * const  kDescription = @"@apiDescription";
static NSString * const  kParameter = @"@apiParam";
static NSString * const  kFormatLeft = @"<#";
static NSString * const  kFormatRight = @"#>";

typedef NS_ENUM(NSUInteger, ENUM_PARAMETER_TYPE) {
    ENUM_PARAMETER_TYPE_DOUBLE,
    ENUM_PARAMETER_TYPE_STRING,
    ENUM_PARAMETER_TYPE_ERROR
};
typedef NS_ENUM(NSUInteger, ENUM_REQUEST_TYPE) {
    ENUM_REQUEST_TYPE_GET,
    ENUM_REQUEST_TYPE_GET_URL,//get方式 并且拼接参数
    ENUM_REQUEST_TYPE_POST,
    ENUM_REQUEST_TYPE_PUT,
    ENUM_REQUEST_TYPE_DELETE,
    ENUM_REQUEST_TYPE_PATCH,
    ENUM_REQUEST_TYPE_ERROR
};


@interface GlobalMethod (MicroServiceApiExchange)
//转换请求数据
+ (NSString *)exchangeMicroServiceApi:(NSString *)str prefix:(NSString *)prefix;

@end
