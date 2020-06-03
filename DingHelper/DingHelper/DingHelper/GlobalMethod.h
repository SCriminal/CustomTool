//
//  GlobalMethod.h
//  DingHelper
//
//  Created by 隋林栋 on 2020/4/26.
//Copyright © 2020 隋林栋. All rights reserved.

#import <Foundation/Foundation.h>

@interface GlobalMethod : NSObject
//设置日期格式
+ (NSString *)exchangeDate:(NSDate *)date formatter:(NSString *)formate;
+ (NSDate *)exchangeStringToDate:(NSString *)string formatter:(NSString *)formate;
@end
